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

                    <!-- The current-year row is a live readout; the others are
                         static labels. One live region per row so a screen
                         reader announces "2020, 9.2 million acres" as a single
                         update rather than two competing ones. -->
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

                    <button
                      class="legend-info"
                      type="button"
                      :aria-expanded="openInfo === item.key"
                      :aria-controls="`legend-info-${item.key}`"
                      @click="toggleInfo(item.key)"
                    >
                      <span class="only">About the {{ item.label || 'highlighted year' }} data</span>
                      <svg
                        viewBox="0 0 16 16"
                        aria-hidden="true"
                      >
                        <circle
                          cx="8"
                          cy="8"
                          r="7"
                        />
                        <path d="M8 6.6v4.6M8 4.4v1.1" />
                      </svg>
                    </button>
                  </div>

                  <div
                    v-show="openInfo === item.key"
                    :id="`legend-info-${item.key}`"
                    class="legend-info-panel"
                  >
                    <p>{{ item.info }}</p>
                    <a
                      :href="item.href"
                      target="_blank"
                      rel="noopener noreferrer"
                    >{{ item.source }}</a>
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
          </div>

          <!-- Fire map SVG loaded at runtime to reduce bundle size -->
          <div
            id="firemap-container"
            role="figure"
            :aria-label="`Interactive map of the western United States showing wildfire burn perimeters from ${firstYear} to ${lastYear}, overlaid on important water supply watersheds. Total burned area has generally increased over this period.`"
            v-html="fireMapSvg"
          />
        </div>
      </div>
      <div class="caption-container flex-container">
        <p class="caption">
          Fire perimeter data from <a
            href="https://mtbs.gov"
            target="_blank"
          >Monitoring Trends in Burn Severity (MTBS),</a> {{ yearRange }}. Includes
          wildfires of 1,000 acres or more; prescribed burns are excluded.<br>
          Important water supply watersheds, based on amount of surface water supply generated and withdrawn (Importance >= 50), from <a
            href="https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn"
            target="_blank"
          >U.S. Department of Agriculture's Forest to Faucets.</a>
        </p>
      </div>        
    </div>
    <div class="text-content">
      <p>However, financial and societal costs don’t stop when the flames go out.  Wildfires can have enormous impacts on human lives, property, and infrastructure – as well as to our water supplies. Over 50% of the Nation’s drinking water comes from forested areas. Wildfires are natural in many ecosystems, but have increased in size, severity, and frequency.  These hotter, bigger fires increase the risk of flood hazards, erosion, and impaired water quality.</p>
    </div>   
  </section>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue';
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
const chart_margin = { top: 46, right: 8, bottom: 34, left: 46 };
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

// Legend rows, including the provenance that used to sit in the caption below
// the map. Driving the markup from data keeps the three rows structurally
// identical instead of three near-duplicate blocks.
const LEGEND = [
  {
    key: 'current',
    shape: 'fire',
    swatchClass: 'swatch--current',
    label: '',
    value: '',
    info: 'Area burned in the year being shown. Perimeters cover wildfires of 1,000 acres or more, mapped from Landsat imagery; prescribed burns are excluded.',
    source: 'Monitoring Trends in Burn Severity (MTBS)',
    href: 'https://mtbs.gov'
  },
  {
    key: 'total',
    shape: 'fire',
    swatchClass: 'swatch--past',
    label: 'Total area burned',
    value: '',
    info: 'Every wildfire perimeter recorded across the full period, accumulated as the animation advances.',
    source: 'Monitoring Trends in Burn Severity (MTBS)',
    href: 'https://mtbs.gov'
  },
  {
    key: 'watershed',
    shape: 'watershed',
    swatchClass: 'swatch--watershed',
    label: 'Important watersheds',
    value: 'for water supply',
    info: 'Watersheds ranked 50 or higher for importance to surface drinking water, based on the amount of supply generated and withdrawn.',
    source: "USDA Forest Service, Forests to Faucets 2.0",
    href: 'https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn'
  }
];

// Only one panel open at a time — three expanded panels would push the bar
// chart out of view in the sidebar.
const openInfo = ref(null);
function toggleInfo(key) {
  openInfo.value = openInfo.value === key ? null : key;
}

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
  var chart = d3.select("#bar-chart-mount")
    .append("svg")
    .attr("viewBox", [0, 0, 720, view_height].join(' '))
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

  g.append("g")
    .attr("class", "chartAxis left")
    .attr("transform", "translate(0,0)")
    .call(d3.axisLeft(y).ticks(10, "s").tickSize(-chart_width))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke-width", 1).attr("stroke-dasharray", "1, 15").attr("opacity", "0.5");

  chart.select(".chartAxis.bottom")
    .append('text')
    .attr('transform', 'translate(' + chart_width / 2 + ', 30)')
    .attr("text-anchor", "middle")
    .attr("class", "chartAxisText bottom")
    .text("Year");

  chart.select(".chartAxis.left")
    .append('text')
    .attr("y", -30)
    .attr("x", -chart_height / 2)
    .attr("text-anchor", "middle")
    .attr("class", "chartAxisText left")
    .text("Acres burned in the West")
    .attr("transform", "rotate(-90)");

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
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseout", function(event, d) { dehighlight_year(d, isPlaying); });

  createPlayButton(chart);
}

function createPlayButton(chart) {
  // Sits inside the plot area rather than the axis gutter. The early years of
  // the record are low, so the upper-left of the plot is reliably empty.
  const size = 42;
  const inset = 6;
  const x = chart_margin.left + inset;
  const y = chart_margin.top + inset;

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
    .attr("rx", 4)
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

  currentYearIndex++;

  // Schedule next step
  animationTimer = setTimeout(stepAnimation, animationInterval);
}

function makeFireInteractive(csv_burn) {
  // D3 v7: event handlers receive (event, d)
  d3.select("#firemap-container").selectAll(".fire")
    .data(csv_burn)
    .on("click", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseout", function(event, d) { dehighlight_year(d, isPlaying); });
}

function highlight_year(data, playing) {
  if (playing === false) {
    currentYear.value = data.YEAR;
    currentAcres.value = formatAcres(parseFloat(data.area_acres));

    d3.selectAll(".fire.year" + data.YEAR)
      .style("fill", COLOR.activeFill)
      .style("stroke", COLOR.activeStroke)
      .raise();

    d3.selectAll(".bar.year" + data.YEAR)
      .style("fill", COLOR.activeFill)
      .style("stroke", COLOR.activeStroke);
  }
}

function dehighlight_year(data, playing) {
  if (playing === false) {
    currentYear.value = '';
    currentAcres.value = '';

    for (let i = 0; i < yearList.length; i++) {
      let current_year = parseFloat(data.YEAR);
      let selected_year = parseFloat(yearList[i]);
      if (current_year > selected_year) {
        d3.selectAll(".fire.year" + selected_year).raise();
      }
    }

    d3.selectAll(".bar.year" + data.YEAR)
      .style("fill", COLOR.barFill)
      .style("stroke", COLOR.barStroke);

    d3.selectAll(".fire.year" + data.YEAR)
      .style("fill", COLOR.fireFill)
      .style("stroke", COLOR.fireStroke)
      .raise();

    for (let i = 0; i < yearList.length; i++) {
      let current_year = parseFloat(data.YEAR);
      let selected_year = parseFloat(yearList[i]);
      if (current_year < selected_year) {
        d3.selectAll(".fire.year" + selected_year).raise();
      }
    }
  }
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
}

#map-legend {
  font-family: 'Source Sans Pro', sans-serif;
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

/* Acreage sits under the year as the same readout, so it is weighted closer to
   the year than the muted detail text on the other legend rows. */
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

#firemap-container {
  line-height: 0; /* kills the inline-descender gap under the svg */
  flex: 0 0 auto; /* sized by the svg's aspect ratio, not by flex growth */
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

@media screen and (max-width: 700px) {
  #firemap {
    /* Give the map the full column on phones — vertical space is cheaper than
       horizontal, and the perimeters get too small to read otherwise. */
    height: auto;
    width: 100%;
  }
}
#basemap {
  fill: none;
  stroke: none;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1;

  #states {
    stroke-width: 1.75;
    stroke: #fcfcfc;
    fill: #f0f0f0;
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
.chartAxisText {
  fill: #4f4f4f; /* #4f4f4f */
  font-size: 1em;
  font-weight: bold;
}
.tick text{
  fill: #4f4f4f;
  font-size: 12px;
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
</style>