<template>
  <section id="main-map-section">
    <div
      class="text-content"
    >
      <div id="main-map-header">
        <h2>Wildfires pose a <span class="lowlight">growing risk</span> to our Nation’s water supplies</h2>
        <p>
          Wildfires are a natural process in many ecosystems, playing an important role in nutrient cycling and other ecological interactions. But the size, <a
            href="https://www.usgs.gov/centers/eros/science/monitoring-trends-burn-severity?qt-science_center_objects=0#qt-science_center_objects"
            target="_blank"
          >severity</a>, and the length of the fire season have increased substantially in the western U.S. over the past few decades, and these trends are predicted to continue.
        </p>
        <p>
          The year 2020 provided stark evidence that wildfires are changing the landscape of America. Over 8 million acres – almost the size of Connecticut and New Jersey combined – were ablaze this year, including the largest recorded fires in California and Colorado history. Wildfires burned watersheds on the western side of the Cascade Mountains in Oregon, a region that is typically very wet and where fires are rare. Over $3.2 billion has been spent to suppress these fires nationally, and thousands of people have evacuated their homes.
        </p>
      </div>
    </div>
    <div id="mappy">
      <div
        id="map-container"
        role="figure"
        :aria-label="`Bar chart showing acres burned by wildfires in the western United States each year from ${firstYear} to ${lastYear}, with a trend of increasing burn area over time`"
      >
        <!-- Two columns on wide screens: the reading column (title, legend,
             chart) on the left, the map on the right. The map is portrait and
             the chart is very wide, so pairing them side by side lets the map
             run to full viewport height instead of competing for vertical space.
             Collapses to a single stack below 900px. -->
        <div class="map-layout">
          <div class="map-sidebar">
            <div class="chart-title-container">
              <p class="chart-title">
                Wildfire in the Western U.S. in relation to Important Watersheds
              </p>
              <p>{{ yearRange }}</p>
            </div>

            <div id="map-legend">
              <!-- role="list" is scoped to the key items only. The usage note
                   below is guidance, not a legend entry, so it stays outside. -->
              <div
                class="legend-items"
                role="list"
                aria-label="Map legend"
              >
                <div
                  v-for="item in LEGEND"
                  :key="item.key"
                  class="legend-entry"
                  role="listitem"
                >
                  <div class="legend-item">
                    <svg
                      class="legend-swatch"
                      viewBox="0 0 24 24"
                      aria-hidden="true"
                    >
                      <path
                        :class="item.swatchClass"
                        :d="SWATCH[item.shape]"
                      />
                    </svg>
                    <span
                      v-if="item.key === 'current'"
                      class="legend-text"
                      aria-live="polite"
                    >
                      <span class="legend-year">{{ currentYear || '—' }}</span>
                      <span class="legend-value">{{ currentAcres || 'select or play' }}</span>
                    </span>
                    <span
                      v-else
                      class="legend-text"
                    >
                      <span class="legend-label">{{ item.label }}</span>
                      <span class="legend-value">{{ item.value }}</span>
                    </span>
                  </div>
                </div>
              </div>

              <p class="legend-note">
                <span class="lowlight">Click or hover</span> to view areas burned by
                wildfire in each year.
              </p>
            </div>

            <!-- D3 mounts the bar chart here so it sits in the reading column
                 beneath the legend instead of below the whole layout. -->
            <div id="bar-chart-mount" />

            <!-- Sources sit under the chart in the reading column. Previously a
                 sibling of the whole flex row, which rendered them centred
                 beneath both columns and far from anything they describe. -->
            <p class="chart-caption">
              Fire perimeter data from <a
                href="https://mtbs.gov"
                target="_blank"
                rel="noopener noreferrer"
              >Monitoring Trends in Burn Severity (MTBS),</a> {{ yearRange }}.
              Includes wildfires of 1,000 acres or more; prescribed burns are
              excluded. Important water supply watersheds (importance 50 or
              higher) from <a
                href="https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn"
                target="_blank"
                rel="noopener noreferrer"
              >the U.S. Department of Agriculture's Forests to Faucets.</a>
            </p>
          </div>

          <!-- Fire map SVG loaded at runtime to reduce bundle size. The
               hillshade is a sibling rather than part of the SVG so the raster
               can multiply-blend beneath it — an <image> inside the SVG would
               blend against the SVG's own stacking context instead. -->
          <div
            id="firemap-container"
            role="figure"
            :aria-label="`Interactive map of the western United States showing wildfire burn perimeters from ${firstYear} to ${lastYear}, overlaid on important water supply watersheds and shaded relief. Total burned area has generally increased over this period.`"
          >
            <img
              class="firemap-hillshade"
              :src="publicPath + 'data/hillshade.png'"
              alt=""
              aria-hidden="true"
            >
            <div
              id="firemap-svg"
              v-html="fireMapSvg"
            />
          </div>
        </div>
      </div>
    </div>
    <br/>
    <br/>
    <div class="text-content">
      <p>However, financial and societal costs don’t stop when the flames go out.  Wildfires can have enormous impacts on human lives, property, and infrastructure – as well as to our water supplies. Over 50% of the Nation’s drinking water comes from forested areas. Wildfires are natural in many ecosystems, but have increased in size, severity, and frequency.  These hotter, bigger fires increase the risk of flood hazards, erosion, and impaired water quality.</p>
    </div>   
  </section>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue';
import * as d3 from 'd3';

const publicPath = import.meta.env.BASE_URL;
const fireMapSvg = ref('');
const currentYear = ref('');

// Derived from the CSV so the pipeline's year range drives the labels. Avoids
// hand-editing copy every time the data is refreshed.
const firstYear = ref('');
const lastYear = ref('');

// Acreage for the year being shown, whether from playback or hover. Replaces
// the old SVG text node that floated in the map's upper right.
const currentAcres = ref('');
const yearRange = computed(() =>
  firstYear.value && lastYear.value ? `${firstYear.value}–${lastYear.value}` : ''
);

// chart dimensions
// Plot dimensions are primary and the viewBox is derived from them, so changing
// a margin no longer silently shrinks the plot.
//
// The top margin is a header band holding the play button and the y-axis label.
// A horizontal y-axis label needs far less side room than a rotated one, so the
// left margin only has to clear the tick labels — that width went to the plot.
// The bottom margin carries the x-axis labels plus a control band beneath them
// for the play button, so it is deeper than the axis alone would need.
const chart_margin = { top: 46, right: 8, bottom: 68, left: 46 };
const chart_height = 171;
const chart_width = 720 - chart_margin.left - chart_margin.right;
const view_height = chart_height + chart_margin.top + chart_margin.bottom;
const y = d3.scaleLinear().range([chart_height, 0]);

// Legend swatch outlines, drawn in a 24x24 box. Irregular on purpose — a plain
// rectangle would imply these are tidy areas, when both fire perimeters and
// watersheds are ragged shapes. The fire path is reused for both fire states so
// they read as the same phenomenon at different moments.
const SWATCH = {
  fire: 'M3.5 10.5 L7 5.5 L11.5 7 L15 3.5 L18.5 6 L17 10 L20.5 12.5 L19 17 L14 18.5 L11 16.5 L7.5 19.5 L4.5 16 L6 13 Z',
  watershed: 'M11.5 2.5 C15 2 18 4 19 7 C20.5 9.5 19 11.5 20 14 C21 17 17.5 21 14 21.5 C10 22 6 19.5 4 16 C2 12.5 3 8 6 5.5 C7.5 4 9.5 3 11.5 2.5 Z'
};

// Legend rows. Driving the markup from data keeps the three rows structurally
// identical instead of three near-duplicate blocks. Provenance lives in the
// caption beneath the chart.
const LEGEND = [
  {
    key: 'current',
    shape: 'fire',
    swatchClass: 'swatch--current',
    label: '',
    value: ''
  },
  {
    key: 'total',
    shape: 'fire',
    swatchClass: 'swatch--past',
    label: 'Total area burned',
    value: ''
  },
  {
    key: 'watershed',
    shape: 'watershed',
    swatchClass: 'swatch--watershed',
    label: 'Important watersheds',
    value: 'for water supply'
  }
];

// Shared palette. These were previously repeated as literals across five
// functions, so a colour change meant editing every one of them.
const COLOR = {
  activeFill: 'rgb(250,109,49)',
  activeStroke: 'rgb(235,98,40)',
  barFill: 'rgba(245,169,60,0.8)',
  barStroke: 'rgba(235,156,42,0.8)',
  fireFill: 'rgba(245,169,60,0.6)',
  fireStroke: 'rgba(235,156,42,0.6)'
};

let isPlaying = false;
const yearList = [];
const acresByYear = new Map();

// Years the animation has reached. Hover resets perimeters to their resting
// colour, and without this a year the playback has not shown yet would be
// revealed early by hovering after a pause.
const revealedYears = new Set();
let currentYearIndex = 0;
let animationTimer = null;
const animationInterval = 800;

onMounted(async () => {
  // Load fire map SVG at runtime to avoid bundling ~1.5MB of path data
  const response = await fetch(publicPath + 'data/fire_map.svg');
  fireMapSvg.value = await response.text();

  // Wait for DOM update and a frame for browser to parse the SVG
  await nextTick();
  requestAnimationFrame(() => {
    setPanels();
  });

});

onUnmounted(() => {
  // Leaving the timer running would keep stepping after the view is gone
  if (animationTimer) clearTimeout(animationTimer);
});

function setPanels() {
  let promises = [d3.csv(publicPath + "data/fire_timeseries.csv")];
  Promise.all(promises).then(callback);
}

function callback(data) {
  let csv_burn = data[0];
  makeYearList(csv_burn);
  createBarChart(csv_burn);
  makeFireInteractive(csv_burn);
  // Start initial animation using the step-based system
  resumeAnimation();
}

function makeYearList(csv_burn) {
  for (let i = 0; i < csv_burn.length; i++) {
    yearList.push(csv_burn[i]['YEAR']);
    // Keyed lookup so the animation can report acreage without re-scanning
    // the parsed CSV on every step.
    acresByYear.set(csv_burn[i]['YEAR'], parseFloat(csv_burn[i]['area_acres']));
  }
  firstYear.value = yearList[0];
  lastYear.value = yearList[yearList.length - 1];
}

// Years range from ~390k to ~9.2M acres. Fixing everything to "millions" turned
// the smaller years into "0.4 million acres", so switch units at 1M.
function formatAcres(acres) {
  if (!acres || isNaN(acres)) return '';
  if (acres >= 1e6) {
    return `${d3.format('.1f')(acres / 1e6)} million acres`;
  }
  return `${d3.format(',')(Math.round(acres / 1000) * 1000)} acres`;
}

function createBarChart(csv_burn) {
  // Everything in this chart is drawn in viewBox units, which the browser then
  // squeezes into whatever width the column has. On a phone that factor is
  // about a half, so a control sized for the desktop lands near 17px — well
  // under a comfortable touch target. The chart is built once and not redrawn
  // on resize, so the size is chosen here, at creation.
  const narrow = window.matchMedia('(max-width: 700px)').matches;
  const play_size = narrow ? 62 : 34;
  // Deepen the control band to seat the larger button; without this it would
  // extend past the viewBox and be clipped by the svg edge.
  const view_height_total = view_height + (narrow ? play_size - 34 : 0);

  var chart = d3.select("#bar-chart-mount")
    .append("svg")
    .attr("viewBox", [0, 0, 720, view_height_total].join(' '))
    .attr("class", "fire-timeseries-2");
  let g = chart.append("g")
    .attr("class", "transformedBarChart")
    .attr("transform", "translate(" + chart_margin.left + "," + chart_margin.top + ")");

  var x = d3.scaleBand()
    .range([0, chart_width])
    .domain(csv_burn.map(function(d) { return d.YEAR; }))
    .padding(0.1);

  var domainArrayY = [];
  for (let i = 0; i < csv_burn.length; i++) {
    domainArrayY.push(parseFloat(csv_burn[i]['area_acres']));
  }

  let dataMax = Math.round(Math.max(...domainArrayY));
  y.domain([0, dataMax]);

  g.append("g")
    .attr("class", "chartAxis bottom")
    .attr("transform", "translate(0," + chart_height + ")")
    .call(d3.axisBottom(x).tickValues(['1990', '2000', '2010', '2020']).tickSize(3))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke", "#ffffff");

  // Four ticks, not ten: the plot is only 171 viewBox units tall, so ten
  // labels land ~17 units apart and collide as soon as the type is scaled up
  // for narrow screens. "~s" drops the trailing zeros a plain "s" leaves
  // behind, so the axis reads 0, 2M, 4M rather than 0.0M, 2.0M.
  g.append("g")
    .attr("class", "chartAxis left")
    .attr("transform", "translate(0,0)")
    .call(d3.axisLeft(y)
      .ticks(4)
      .tickFormat(d3.format("~s"))
      .tickSize(-chart_width)
      // A negative tickSize makes the ticks span the plot as gridlines, which
      // leaves d3 placing the labels 3 units off the axis — too close once the
      // type scales up.
      .tickPadding(7))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke-width", 1).attr("stroke-dasharray", "1, 15").attr("opacity", "0.5");

  // No "Year" label on the x axis — the tick values are self-evidently years,
  // and the label only competed with the play button for the control band.

  // Horizontal, in the header band above the axis. Reads without tilting your
  // head, and left-aligning it to the axis makes clear it labels the y scale.
  chart.append('text')
    .attr("x", chart_margin.left)
    .attr("y", chart_margin.top - 12)
    .attr("text-anchor", "start")
    .attr("class", "chartAxisText left")
    .text("Acres burned in the West");

  // Bars are drawn at full height immediately so the whole distribution is
  // readable before and during playback. The animation only recolours them.
  // D3 v7: event handlers receive (event, d) instead of (d).
  g.selectAll(".fire-bars")
    .data(csv_burn)
    .enter()
    .append("rect")
    .attr("class", function(d) { return "fire-bars bar year" + d.YEAR; })
    .attr("width", x.bandwidth())
    .attr("x", function(d) { return x(d.YEAR); })
    .attr("y", function(d) { return y(d.area_acres); })
    .attr("height", function(d) { return chart_height - y(d.area_acres); })
    .style("fill", COLOR.barFill)
    .style("stroke", COLOR.barStroke)
    .on("click", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); });

  // Dismissal lives on the container, not each bar. Leaving the chart is a
  // single reliable event, whereas per-bar mouseout can be skipped when the
  // pointer crosses between adjacent bars.
  chart.on("mouseleave", function () {
    if (!isPlaying) clearHighlight();
  });

  createPlayButton(chart, play_size);
}

function createPlayButton(chart, size) {
  // Control band below the x-axis labels, left-aligned with the plot area so it
  // lines up with the first bar rather than floating in the axis gutter.
  const x = chart_margin.left;
  const y = chart_margin.top + chart_height + 22;

  // Icon geometry derived from `size` so the button scales from one number.
  const playIcon = [
    `M${size * 0.32} ${size * 0.24}`,
    `L${size * 0.32} ${size * 0.76}`,
    `L${size * 0.74} ${size * 0.5} Z`
  ].join(' ');

  const barTop = size * 0.26;
  const barBottom = size * 0.74;
  const pauseIcon = [
    `M${size * 0.28} ${barTop} L${size * 0.28} ${barBottom}`,
    `L${size * 0.44} ${barBottom} L${size * 0.44} ${barTop} Z`,
    `M${size * 0.56} ${barTop} L${size * 0.56} ${barBottom}`,
    `L${size * 0.72} ${barBottom} L${size * 0.72} ${barTop} Z`
  ].join(' ');

  let button = chart.append("g")
    .attr("transform", `translate(${x},${y})`)
    .attr("class", "play_button")
    .attr("role", "button")
    .attr("tabindex", 0)
    .attr("aria-label", "Play or pause the year-by-year animation")
    .style("cursor", "pointer");

  button.append("rect")
    .attr("width", size)
    .attr("height", size)
    .attr("rx", size * 0.12) /* proportional, so the corner reads the same at either size */
    .style("fill", COLOR.activeFill);

  button.append("path")
    .attr("class", "play-icon")
    .attr("d", playIcon)
    .style("fill", "#ffffff");

  // Hidden until playback starts; togglePlayPause swaps the two.
  button.append("path")
    .attr("class", "pause-icon")
    .attr("d", pauseIcon)
    .style("fill", "#ffffff")
    .style("display", "none");

  button.append("title")
    .text("Play/pause animation");

  // click rather than mousedown so the control also responds to keyboard
  // activation, which browsers dispatch as a click.
  button.on("click", function() {
    togglePlayPause();
  });

  button.on("keydown", function(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      togglePlayPause();
    }
  });
}

function togglePlayPause() {
  if (isPlaying) {
    pauseAnimation();
  } else {
    resumeAnimation();
  }
}

function resumeAnimation() {
  isPlaying = true;

  // Show pause icon, hide play icon
  d3.select(".play-icon").style("display", "none");
  d3.select(".pause-icon").style("display", null);

  let button_rect = d3.selectAll(".play_button").selectAll("rect");
  button_rect.style("fill", "#d6d6d6");

  // If we're at the end, restart from beginning
  if (currentYearIndex >= yearList.length) {
    currentYearIndex = 0;
    resetMapState();
  }

  // Position year text elements - hidden by default
  d3.select("#firemap-container").selectAll(".text-year")
    .style("display", "none");

  stepAnimation();
}

function pauseAnimation() {
  isPlaying = false;

  if (animationTimer) {
    clearTimeout(animationTimer);
    animationTimer = null;
  }

  // Show play icon, hide pause icon
  d3.select(".play-icon").style("display", null);
  d3.select(".pause-icon").style("display", "none");

  // Restore button color
  d3.selectAll(".play_button").selectAll("rect")
    .style("fill", COLOR.activeFill);
}

function resetPlayButton() {
  isPlaying = false;
  currentYearIndex = 0;
  if (animationTimer) {
    clearTimeout(animationTimer);
    animationTimer = null;
  }
  d3.selectAll(".play_button").selectAll("rect")
    .style("fill", COLOR.activeFill);
  d3.select(".play-icon").style("display", null);
  d3.select(".pause-icon").style("display", "none");
}

function resetMapState() {
  // Bars keep their height — only the highlight colour resets, so the chart
  // stays readable between plays.
  d3.selectAll(".fire-bars")
    .interrupt()
    .style("fill", COLOR.barFill)
    .style("stroke", COLOR.barStroke);

  // Reset fires
  d3.select("#firemap-container").selectAll(".fire")
    .style("fill", "None")
    .style("stroke", "None");

  // Reset year text
  d3.select("#firemap-container").selectAll(".text-year")
    .style("display", "none");
  currentYear.value = '';
  currentAcres.value = '';
}

function stepAnimation() {
  if (!isPlaying || currentYearIndex >= yearList.length) {
    if (currentYearIndex >= yearList.length) {
      resetPlayButton();
    }
    return;
  }

  let colorDuration = 200;
  let appearDuration = animationInterval - colorDuration;
  let yr = yearList[currentYearIndex];

  // Highlight this year's bar, then let it settle back. No height animation —
  // the bars are already drawn, so the walkthrough reads as a moving highlight
  // across a complete chart rather than a chart building itself.
  d3.select(".bar.year" + yr)
    .interrupt()
    .style("fill", COLOR.activeFill)
    .style("stroke", COLOR.activeStroke)
    .transition()
    .duration(colorDuration)
    .delay(appearDuration)
    .style("fill", COLOR.barFill)
    .style("stroke", COLOR.barStroke);

  // Perimeters accumulate — each year flashes red then settles, so the map
  // builds up while the bar highlight tracks alongside it.
  d3.select("#firemap-container").select(".fire.year" + yr)
    .interrupt()
    .style("fill", COLOR.activeFill)
    .style("stroke", COLOR.activeStroke)
    .transition()
    .duration(colorDuration)
    .delay(appearDuration)
    .style("fill", COLOR.fireFill)
    .style("stroke", COLOR.fireStroke);

  // Update the legend readout
  currentYear.value = yr;
  currentAcres.value = formatAcres(acresByYear.get(yr));
  revealedYears.add(yr);

  currentYearIndex++;

  // Schedule next step
  animationTimer = setTimeout(stepAnimation, animationInterval);
}

function makeFireInteractive(csv_burn) {
  // D3 v7: event handlers receive (event, d)
  d3.select("#firemap-container").selectAll(".fire")
    .data(csv_burn)
    .on("click", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); });

  // Perimeters for different years overlap heavily, and highlight_year calls
  // raise() which reorders them. Both make per-perimeter mouseout unreliable,
  // so clearing happens once on leaving the map.
  d3.select("#firemap-container")
    .on("mouseleave", function () {
      if (!isPlaying) clearHighlight();
    });
}

// Returns everything to its resting state. Clearing all of it on every highlight
// is what guarantees a single active year — the previous approach reset only the
// year whose mouseout fired, so any missed leave event left a bar stuck lit.
function clearHighlight() {
  // Bars are always drawn at full height, so all of them can reset outright.
  d3.selectAll(".fire-bars")
    .interrupt()
    .style("fill", COLOR.barFill)
    .style("stroke", COLOR.barStroke);

  // Perimeters only return to visible if playback has reached them.
  d3.select("#firemap-container").selectAll(".fire")
    .interrupt()
    .each(function () {
      const match = (this.getAttribute("class") || "").match(/year(\d{4})/);
      const shown = match && revealedYears.has(match[1]);
      d3.select(this)
        .style("fill", shown ? COLOR.fireFill : "None")
        .style("stroke", shown ? COLOR.fireStroke : "None");
    });

  currentYear.value = '';
  currentAcres.value = '';
}

function highlight_year(data, playing) {
  if (playing) return;

  clearHighlight();

  currentYear.value = data.YEAR;
  currentAcres.value = formatAcres(parseFloat(data.area_acres));

  // raise() reorders the DOM, which is why per-element mouseout is unreliable
  // here. Dismissal is handled by mouseleave on the containers instead.
  d3.select("#firemap-container").selectAll(".fire.year" + data.YEAR)
    .style("fill", COLOR.activeFill)
    .style("stroke", COLOR.activeStroke)
    .raise();

  d3.selectAll(".bar.year" + data.YEAR)
    .style("fill", COLOR.activeFill)
    .style("stroke", COLOR.activeStroke);
}


</script>

<style scoped lang="scss">

  // Import Colors
  $white: rgb(255,255,255);
  $black: rgb(0,0,0);  
  $lightGray:rgb(237,237,237);
  $mediumGray: rgb(100,100,100);
  $darkGray: rgb(51,51,51);
  $usgsGreen: rgb(51,120,53);
  $usgsBlue: rgb(0,38,76);
  $fireRed: rgb(250,109,49);
  $fireRedlight: rgba(250,109,49,0.5);
  $fireYellow: rgb(245,169,60);
  $fireYellowlight: rgba(245,169,60,0.5);

#main-map-section   {
  position: relative;
}

#map-container {
  padding: 4em 0 0 0;
  width: 90%;
  margin: auto;
  @media screen and (min-width: 800px) {
    width: 80%;
    margin: auto;
  }
  svg { 
    fill: none;
    width: 100%;
  }
}

.caption-container{
  padding: 0 0 4em 0;
}
#mappy {
  width:90vw;
  margin: auto;
}

</style>
<style lang="scss">
/* Styles for dynamically loaded fire map SVG (v-html) */
/* Legend column left, map right. align-items: center keeps the legend visually
   balanced against the tall portrait map rather than floating at its top. */
.map-layout {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: clamp(1rem, 3vw, 3rem);
  max-width: 1500px;
  margin: 0 auto;
  padding: 0 1rem;
}

/* Reading column: title, legend, chart. Grows to fill whatever the map leaves,
   with a floor that keeps the wide bar chart legible and a ceiling so the map
   still dominates on very wide screens. */
.map-sidebar {
  flex: 1 1 0;
  min-width: 20rem;
  max-width: 44rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  /* Set once for the whole column — title, legend and caption all inherit it
     rather than each declaring its own family. */
  font-family: 'Source Sans Pro', sans-serif;
}

.chart-caption {
  margin: 0;
  padding-top: 0.9rem;
  border-top: 1px solid #e0e0e0;
  font-size: 0.85rem;
  line-height: 1.35;
  color: #4f4f4f;
  max-width: none;
  text-align: left;
  font-style: normal;
}
.chart-caption a {
  font-weight: 600;
  font-size: inherit;
}


/* Overrides the em-based sizing from Visualization.vue. Inside the sidebar the
   em cascade made the title size depend on whatever ancestor font-size applied,
   so these are pinned in rem and scaled against the legend's 0.95rem body. */
.map-sidebar .chart-title-container {
  max-width: none;
  padding: 0.6rem 0.9rem;
}
.map-sidebar .chart-title-container .chart-title {
  font-size: 1.05rem;
  font-weight: 700;
  line-height: 1.3;
}
.map-sidebar .chart-title-container p {
  font-size: 0.9rem;
}

.legend-items {
  display: flex;
  flex-direction: column;
  gap: 1.4rem;
}

/* Guidance rather than a key entry, so it is separated by a rule and set
   smaller than the legend labels. */
.legend-note {
  margin: 1.4rem 0 0;
  padding-top: 1rem;
  border-top: 1px solid #e0e0e0;
  font-size: 0.85rem;
  line-height: 1.35;
  color: #4f4f4f;
}

/* Two columns — swatch, label. align-items:start keeps the swatch on the
   label's first line rather than centring against two lines. */
.legend-item {
  display: grid;
  grid-template-columns: 1.7rem 1fr;
  gap: 0.7rem;
  align-items: start;
}

.legend-swatch {
  width: 1.7rem;
  height: 1.7rem;
  flex: none;
  overflow: visible; /* stroke sits on the path edge, so don't clip it */
}

/* Fills mirror the map exactly. stroke-width is in viewBox units, so 1 unit
   scales to well under a pixel at this size — hence the heavier value. */
.legend-swatch path {
  stroke-width: 1.2;
  stroke-linejoin: round;
}
.swatch--current {
  fill: rgb(250, 109, 49);
  stroke: rgb(235, 98, 40);
}
.swatch--past {
  fill: rgba(245, 169, 60, 0.6);
  stroke: rgba(235, 156, 42, 0.8);
}
.swatch--watershed {
  fill: #97c4cf;
  stroke: #82b1bd;
}

.legend-text {
  display: flex;
  flex-direction: column;
  font-size: 0.95rem;
  line-height: 1.25;
  color: #4f4f4f;
}

.legend-detail {
  color: #767676; /* passes AA on white at this size */
}

/* Bold to match the weight of the current-year readout, per the same pattern. */
.legend-label {
  font-weight: 600;
}

/* Second line of every legend row — the acreage readout on the current-year row,
   the qualifier on the others. */
.legend-value {
  font-size: 1rem;
  font-weight: 600;
  color: #4f4f4f;
  font-variant-numeric: tabular-nums;
  min-height: 1.35em; /* reserves the line so rows don't shift when it clears */
}

/* Retained for the current-year row's acreage. */
.legend-acres {
  font-size: 1rem;
  font-weight: 600;
  color: #4f4f4f;
  font-variant-numeric: tabular-nums;
  min-height: 1.35em; /* reserves the line so rows don't shift when it clears */
}

/* The ticking year doubles as the legend key for the red swatch, so it is
   sized to read as the primary label rather than a caption. */
.legend-year {
  font-size: 1.9rem;
  font-weight: 700;
  line-height: 1;
  color: rgb(190, 70, 20); /* darker than the swatch to clear AA on white */
  font-variant-numeric: tabular-nums;
}

/* Positioning context for the hillshade. fit-content shrinks the box to the
   svg it wraps, so the absolutely positioned raster registers with the map
   rather than with a wider container. */
#firemap-container {
  position: relative;
  width: fit-content;
  margin: 0 auto;
  line-height: 0; /* kills the inline-descender gap under the svg */
  flex: 0 0 auto; /* sized by the svg's aspect ratio, not by flex growth */
}

/* Shaded relief. This is the land layer, not an overlay — the flat-terrain
   tone is baked into the PNG and everything off-land is transparent, so it
   needs no blend mode and the states above it carry borders only. Same bbox
   and aspect ratio as the SVG, so inset:0 lines the two up. */
.firemap-hillshade {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  /* Held back so the relief stays a texture rather than competing with the
     perimeters for attention. */
  opacity: 0.6;
  pointer-events: none; /* clicks and hovers belong to the perimeters */
}

/* The svg is static, so it would paint under the absolutely positioned
   hillshade without an explicit stacking position. */
#firemap-svg {
  position: relative;
  z-index: 1;
}

/* The map is 720x845 (portrait) — mapshaper derives height from the western
   states bbox, so it is not square. Driving size from aspect-ratio plus a
   height cap means the whole map fits the viewport without the letterboxing
   that width:100% + max-height produces. max-width clamps narrow screens and
   aspect-ratio recomputes height from there. */
#firemap {
  display: block;
  margin: 0 auto;
  aspect-ratio: 720 / 845;
  height: min(78vh, 845px);
  width: auto;
  max-width: 100%;
}

#basemap {
  fill: none;
  stroke: none;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1;

  /* Borders only — the land tone now comes from the hillshade PNG beneath.
     Any fill here would cover the relief. Heavier than before because a hairline
     white border disappears into the shaded terrain it now sits on. */
  #states {
    stroke-width: 3.5;
    stroke: #ffffff;
    fill: none;
  }
}
.fire {
  fill: none;
  stroke: none;
  stroke-width: 0.5px;
  stroke-linecap: round;
  stroke-linejoin: round;
  cursor: pointer;
}
.fire-bars {
  cursor: pointer;
}
.play_button {
  cursor: pointer;
}
/* Visible focus ring — the control is keyboard reachable, and the default
   outline is easy to lose against the chart. */
.play_button:focus-visible rect {
  stroke: rgb(190, 70, 20);
  stroke-width: 2.5;
}
.play_button:focus {
  outline: none;
}
.text-year {
  font-size: 36px;
  fill: rgb(250,109,49);
  font-weight: 500;
}
.IMP {
  fill: #97c4cf;
  stroke: #82b1bd;
  stroke-width: 0.3px;
  opacity: 0.6;
}
/* Sizes are in viewBox units, not page pixels — the chart SVG scales with the
   sidebar, so these render smaller as the column narrows. Chosen to land near
   the legend's 0.95rem at a typical desktop sidebar width. Exact parity across
   all widths would need the chart drawn in pixel space and re-rendered on
   resize, which is a larger change than this. */
.chartAxisText {
  fill: #4f4f4f;
  font-size: 16px;
  font-weight: 700;
}
.tick text{
  fill: #4f4f4f;
  font-size: 14px;
}
.tick {
  fill: #4f4f4f;
}
.caption-container  {
  padding: 2em;
  width: 80vw;
}
/* Fills the reading column rather than a viewport fraction, so it tracks the
   sidebar width instead of drifting out of alignment with the legend above it. */
.fire-timeseries-2 {
  display: block;
  width: 100%;
  height: auto;
}

/* --- Stacked layout -------------------------------------------------------
   Last in the file so it overrides the two-column rules above; several of them
   are ID selectors, which a media query alone would not outrank.

   The map is a sibling of .map-sidebar, so seating it between the legend and
   the bar chart means collapsing those two levels into one: display:contents
   promotes the sidebar's children into the same grid, and order then sequences
   all five pieces freely. The breakpoint sits above the phone range because the
   side-by-side arrangement already runs out of room once the sidebar's 20rem
   floor and the portrait map have to share the width. */
@media screen and (max-width: 900px) {
  .map-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr);
    justify-items: center;
    gap: 1.5rem;
    /* .map-sidebar normally sets this for its children; display:contents takes
       it out of the inheritance chain, so it moves up to the grid. */
    font-family: 'Source Sans Pro', sans-serif;
  }

  .map-sidebar {
    display: contents;
  }

  /* Title, legend, map, chart, caption. The legend sits directly above the map
     so the ticking year readout stays in view while the animation plays. */
  .map-sidebar .chart-title-container { order: 1; }
  #map-legend { order: 2; }
  #firemap-container { order: 3; }
  #bar-chart-mount { order: 4; }
  .chart-caption { order: 5; }

  /* Each block spans the single column; the reading measure that .map-sidebar
     used to impose is gone along with its box. */
  .map-sidebar .chart-title-container,
  #map-legend,
  #bar-chart-mount,
  .chart-caption {
    width: 100%;
    max-width: 44rem;
  }

  /* Width-driven rather than height-driven here: a portrait map sized off the
     viewport height would push the bar chart well below the fold. Capped so it
     doesn't balloon at the top of the range. */
  #firemap-container {
    width: 100%;
    max-width: 520px;
  }

  #firemap {
    height: auto;
    width: 100%;
  }

  /* The grid gap now separates these blocks, so their own leading would double
     up on the space. */
  .chart-caption {
    padding-top: 0;
    border-top: 0;
  }

  /* Compact legend: the rows carry the same information but fold onto single
     lines, so the key costs a few hundred pixels of scroll instead of a full
     screen before the map appears. */
  .legend-items {
    gap: 0.7rem;
  }

  .legend-item {
    grid-template-columns: 1.4rem 1fr;
    gap: 0.55rem;
    align-items: center;
  }

  .legend-swatch {
    width: 1.4rem;
    height: 1.4rem;
  }

  /* Label and value share a line here rather than stacking. wrap lets the
     longer pairs fall to a second line on the narrowest screens instead of
     forcing the column wider. */
  .legend-text {
    flex-direction: row;
    flex-wrap: wrap;
    align-items: baseline;
    gap: 0.35rem;
  }

  /* The reserved line only exists to stop the stacked rows shifting as the
     readout changes; side by side, the row height no longer depends on it. */
  .legend-value {
    min-height: 0;
  }

  .legend-year {
    font-size: 1.45rem;
  }

  .legend-note {
    margin-top: 1rem;
    padding-top: 0.75rem;
    font-size: 0.8rem;
  }
}

/* Bar chart type is set in the chart's own viewBox units (720 wide), so it
   shrinks with the column: at phone width the column is roughly half the
   viewBox and the labels render at half their nominal size. These steps scale
   the values back up by the inverse of that ratio to hold the rendered size
   near the base 14/16px. */
@media screen and (max-width: 700px) {
  .tick text {
    font-size: 18px;
  }
  .chartAxisText {
    font-size: 20px;
  }
}

@media screen and (max-width: 480px) {
  .tick text {
    font-size: 26px;
  }
  .chartAxisText {
    font-size: 30px;
  }
}
</style>