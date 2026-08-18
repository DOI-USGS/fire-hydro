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
        <!-- Reading column (title, legend, chart) on the left, map on the
             right. The map is portrait and the chart is wide, so side by side
             lets the map use full viewport height. Stacks below 1100px. -->
        <div class="map-layout">
          <div class="map-sidebar">
            <div class="chart-title-container">
              <p class="chart-title">
                Wildfire in the Western U.S. in relation to Important Watersheds
              </p>
              <p>{{ yearRange }}</p>
            </div>

            <div id="map-legend">
              <!-- Scoped to the key items only; the usage prompt below the
                   chart is guidance, not a legend entry. -->
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

            </div>

            <!-- D3 mounts the bar chart here. -->
            <div id="bar-chart-mount" />

            <!-- Play control and usage prompt share a row; both are about
                 stepping through years. The button is HTML rather than drawn
                 into the chart SVG so it gets real pixel sizing, native focus
                 and keyboard handling. -->
            <div class="chart-controls">
              <button
                type="button"
                class="play-button"
                :class="{ 'is-playing': isPlaying }"
                :aria-label="isPlaying
                  ? 'Pause the year-by-year animation'
                  : 'Play the year-by-year animation'"
                @click="togglePlayPause"
              >
                <svg
                  viewBox="0 0 24 24"
                  aria-hidden="true"
                  focusable="false"
                >
                  <!-- Centroid at x=12 so the triangle reads as centred. -->
                  <path
                    v-if="!isPlaying"
                    d="M8.5 5 L8.5 19 L19 12 Z"
                  />
                  <path
                    v-else
                    d="M8 5 H11 V19 H8 Z M13 5 H16 V19 H13 Z"
                  />
                </svg>
              </button>

              <p class="legend-note">
                <span class="legend-note__pointer">
                  <span class="lowlight">Click or hover</span> the chart and map to view areas burned in each year.
                </span>
                <!-- Shown instead on touch screens, where hover does not
                     exist. -->
                <span class="legend-note__touch">
                  <span class="lowlight">Tap a bar</span> to highlight that year on the map.
                </span>
              </p>
            </div>

            <!-- Attribution. The year ranges and the WFIGS clause come from
                 the data, so they track the source seam as it moves. -->
            <p class="chart-caption">
              Fire perimeter data from <a
                href="https://mtbs.gov"
                target="_blank"
                rel="noopener noreferrer"
              >Monitoring Trends in Burn Severity (MTBS)</a>
              <span v-if="wfigsFromYear">
                for {{ firstYear }}&ndash;{{ mtbsThroughYear }}, and from the
                interagency <a
                  href="https://data-nifc.opendata.arcgis.com/datasets/nifc::wfigs-interagency-fire-perimeters"
                  target="_blank"
                  rel="noopener noreferrer"
                >WFIGS</a> perimeter feed for
                {{ wfigsFromYear }}&ndash;{{ lastYear }}, which are incomplete as of 08/16/2026.
              </span>
              <span v-else>for {{ yearRange }}.</span>
              Includes wildfires of 1,000 acres or more;
              prescribed burns are excluded. Important water supply watersheds
              (importance 50 or higher) from <a
                href="https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn"
                target="_blank"
                rel="noopener noreferrer"
              >the U.S. Department of Agriculture's Forests to Faucets.</a>
            </p>
          </div>

          <!-- Fire map SVG is fetched at runtime to keep it out of the
               bundle. The hillshade is a sibling of the SVG, not an <image>
               inside it, so it composites beneath rather than within the
               SVG's own stacking context. -->
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

// Read from the CSV so labels follow the data rather than hardcoded copy.
const firstYear = ref('');
const lastYear = ref('');

// Where the series switches perimeter source. The pipeline publishes MTBS for
// seasons it has finished mapping and WFIGS for the trailing ones, stamping
// each row with its source; the caption reads the boundary from that. Both are
// empty when the series is single-source.
const mtbsThroughYear = ref('');
const wfigsFromYear = ref('');

// Acreage for the year being shown, from playback or hover.
const currentAcres = ref('');
const yearRange = computed(() =>
  firstYear.value && lastYear.value ? `${firstYear.value}–${lastYear.value}` : ''
);

// Chart dimensions in viewBox units. The plot is primary and the viewBox is
// derived from it, so changing a margin does not shrink the plot. The top
// margin is a header band for the y-axis label; the left margin only has to
// clear the tick labels, since that label is horizontal.
const chart_margin = { top: 46, right: 8, bottom: 68, left: 46 };
const chart_height = 171;
// Gap between tick label and axis, and the advance width of the widest label
// the "~s" format produces here ("8M"), in ems.
const TICK_PADDING = 7;
const TICK_LABEL_EMS = 1.5;
// Clearance between the label and the left edge of the viewBox.
const TICK_EDGE_PAD = 4;

// Room the left margin needs for tick labels set at `units`.
function leftMarginFor(units) {
  return Math.ceil(units * TICK_LABEL_EMS) + TICK_PADDING + TICK_EDGE_PAD;
}

// The margin the chart was built with. scaleChartType respects it on resize,
// since the drawn geometry does not move.
let chart_left_margin = chart_margin.left;
const view_height = chart_height + chart_margin.top + chart_margin.bottom;
const y = d3.scaleLinear().range([chart_height, 0]);

// The chart is drawn in a 720-unit viewBox the browser scales to the column
// width, so type sized in viewBox units renders unpredictably — at half scale a
// 14-unit label is 7px. These are the intended on-screen sizes; scaleChartType
// converts them through the measured scale.
const CHART_TICK_PX = 13;
const CHART_LABEL_PX = 15;

// viewBox units per rendered pixel. Clamped so an unlaid-out or very narrow
// column cannot blow the type up to fill the plot.
function unitsPerPixel() {
  const mount = document.getElementById('bar-chart-mount');
  const width = mount ? mount.getBoundingClientRect().width : 0;
  if (!width) return 1;
  return Math.min(2.6, 720 / width);
}

// A media query cannot stand in for this: the column's width depends on the
// map beside it, which is sized partly from the viewport *height*, so the same
// viewport width can produce very different columns.
function scaleChartType() {
  const ratio = unitsPerPixel();
  // The axis geometry is fixed once drawn, so the labels cannot outgrow the
  // margin reserved for them — on a window narrowed after load they would
  // otherwise run off the left edge of the viewBox.
  const tick_units = Math.min(
    CHART_TICK_PX * ratio,
    (chart_left_margin - TICK_PADDING - TICK_EDGE_PAD) / TICK_LABEL_EMS
  );
  const mount = d3.select("#bar-chart-mount");
  mount.selectAll(".tick text").style("font-size", tick_units + "px");
  mount.selectAll(".chartAxisText").style("font-size", CHART_LABEL_PX * ratio + "px");
}

// Legend swatch outlines in a 24x24 box. Irregular on purpose: a rectangle
// would imply tidy areas, when perimeters and watersheds are ragged. Both fire
// states share one path so they read as the same phenomenon.
const SWATCH = {
  fire: 'M3.5 10.5 L7 5.5 L11.5 7 L15 3.5 L18.5 6 L17 10 L20.5 12.5 L19 17 L14 18.5 L11 16.5 L7.5 19.5 L4.5 16 L6 13 Z',
  watershed: 'M11.5 2.5 C15 2 18 4 19 7 C20.5 9.5 19 11.5 20 14 C21 17 17.5 21 14 21.5 C10 22 6 19.5 4 16 C2 12.5 3 8 6 5.5 C7.5 4 9.5 3 11.5 2.5 Z'
};

// Legend rows, driven from data so the markup stays one template.
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

// Shared palette for the chart and map.
const COLOR = {
  activeFill: 'rgb(250,109,49)',
  activeStroke: 'rgb(235,98,40)',
  barFill: 'rgba(245,169,60,0.8)',
  barStroke: 'rgba(235,156,42,0.8)',
  fireFill: 'rgba(245,169,60,0.6)',
  fireStroke: 'rgba(235,156,42,0.6)'
};

// Reactive so the play/pause button icon and styling follow it in the template.
const isPlaying = ref(false);
const yearList = [];
const acresByYear = new Map();

// Years playback has reached. Hover resets perimeters to their resting colour,
// and this keeps a year playback has not shown yet from being revealed early.
const revealedYears = new Set();
let currentYearIndex = 0;
let animationTimer = null;
const animationInterval = 400;

onMounted(async () => {
  // Load fire map SVG at runtime to avoid bundling ~1.5MB of path data
  const response = await fetch(publicPath + 'data/fire_map.svg');
  fireMapSvg.value = await response.text();

  // Wait for DOM update and a frame for browser to parse the SVG
  await nextTick();
  requestAnimationFrame(() => {
    setPanels();
  });

  window.addEventListener('resize', handleResize);
});

// Coalesced to a frame — resize fires continuously during a drag, and this
// reads layout, which would otherwise force a reflow on every event.
let resizeFrame = null;
function handleResize() {
  if (resizeFrame) return;
  resizeFrame = requestAnimationFrame(() => {
    resizeFrame = null;
    scaleChartType();
  });
}

onUnmounted(() => {
  window.removeEventListener('resize', handleResize);
  if (resizeFrame) cancelAnimationFrame(resizeFrame);
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

  // Left blank when every row shares one source, so the caption falls back to
  // crediting that source alone.
  const yearsFrom = (name) => csv_burn
    .filter(function(d) { return d.source === name; })
    .map(function(d) { return d.YEAR; });
  const mtbsYears = yearsFrom('MTBS');
  const wfigsYears = yearsFrom('WFIGS');
  if (mtbsYears.length && wfigsYears.length) {
    mtbsThroughYear.value = mtbsYears[mtbsYears.length - 1];
    wfigsFromYear.value = wfigsYears[0];
  }
}

// Years range from ~390k to ~9.2M acres, so units switch at 1M rather than
// rendering the small years as "0.4 million acres".
function formatAcres(acres) {
  if (!acres || isNaN(acres)) return '';
  if (acres >= 1e6) {
    return `${d3.format('.1f')(acres / 1e6)} million acres`;
  }
  return `${d3.format(',')(Math.round(acres / 1000) * 1000)} acres`;
}

function createBarChart(csv_burn) {
  const ratio = unitsPerPixel();

  // Tick labels are set in viewBox units that grow as the column narrows, so a
  // left margin that clears them on a wide screen clips them on a phone. Widen
  // it to fit the type this chart will actually be drawn with, never below the
  // nominal value so wide layouts are unchanged.
  chart_left_margin = Math.max(chart_margin.left, leftMarginFor(CHART_TICK_PX * ratio));
  const plot_width = 720 - chart_left_margin - chart_margin.right;

  var chart = d3.select("#bar-chart-mount")
    .append("svg")
    .attr("viewBox", [0, 0, 720, view_height].join(' '))
    .attr("class", "fire-timeseries-2");
  let g = chart.append("g")
    .attr("class", "transformedBarChart")
    .attr("transform", "translate(" + chart_left_margin + "," + chart_margin.top + ")");

  var x = d3.scaleBand()
    .range([0, plot_width])
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
      .tickSize(-plot_width)
      // A negative tickSize makes the ticks span the plot as gridlines, which
      // leaves d3 placing the labels 3 units off the axis — too close once the
      // type scales up.
      .tickPadding(7))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke-width", 1).attr("stroke-dasharray", "1, 15").attr("opacity", "0.5");

  // Y-axis label, horizontal in the header band and left-aligned to the axis.
  // The x axis needs no label — the ticks are self-evidently years.
  chart.append('text')
    .attr("x", chart_left_margin)
    .attr("y", chart_margin.top - 12)
    .attr("text-anchor", "start")
    .attr("class", "chartAxisText left")
    .text("Acres burned in the West");

  // Bars are drawn at full height immediately so the whole distribution is
  // readable before and during playback; the animation only recolours them.
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
    .on("click", function(event, d) { highlight_year(d, isPlaying.value); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying.value); });

  // Dismissal is bound to the container, not each bar: per-bar mouseout can be
  // skipped when the pointer crosses between adjacent bars.
  chart.on("mouseleave", function () {
    if (!isPlaying.value) clearHighlight();
  });

  // Bars and axes scale with the viewBox; only type needs correcting. The
  // second pass covers the case where the column is not laid out yet, which
  // makes the first measurement read 0.
  scaleChartType();
  requestAnimationFrame(scaleChartType);
}

function togglePlayPause() {
  if (isPlaying.value) {
    pauseAnimation();
  } else {
    resumeAnimation();
  }
}

function resumeAnimation() {
  isPlaying.value = true;

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
  isPlaying.value = false;

  if (animationTimer) {
    clearTimeout(animationTimer);
    animationTimer = null;
  }
}

function resetPlayButton() {
  isPlaying.value = false;
  currentYearIndex = 0;
  if (animationTimer) {
    clearTimeout(animationTimer);
    animationTimer = null;
  }
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
  if (!isPlaying.value || currentYearIndex >= yearList.length) {
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
  d3.select("#firemap-container").selectAll(".fire")
    .data(csv_burn)
    .on("click", function(event, d) { highlight_year(d, isPlaying.value); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying.value); });

  // Perimeters for different years overlap heavily, and highlight_year calls
  // raise() which reorders them. Both make per-perimeter mouseout unreliable,
  // so clearing happens once on leaving the map.
  d3.select("#firemap-container")
    .on("mouseleave", function () {
      if (!isPlaying.value) clearHighlight();
    });
}

// Returns everything to its resting state. Clearing all years on every
// highlight is what guarantees a single active year; resetting only the year
// that fired would leave a bar lit whenever a leave event is missed.
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

/* These widths compound — 90vw, then 90% of that, then the layout's padding —
   which on a phone leaves the content about two thirds of the screen. Full
   width here; .map-layout's padding still holds it off the page edge. */
@media screen and (max-width: 700px) {
  #mappy {
    width: 100%;
  }
  #map-container {
    width: 100%;
  }
}

</style>
<style lang="scss">
/* Styles for dynamically loaded fire map SVG (v-html) */
/* Legend column left, map right. align-items:center balances the legend
   against the tall portrait map. */
.map-layout {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: clamp(1rem, 3vw, 3rem);
  max-width: 1500px;
  margin: 0 auto;
  padding: 0 1rem;
}

/* Reading column: title, legend, chart. Fills what the map leaves, with a
   floor that keeps the wide bar chart legible and a ceiling so the map still
   dominates on very wide screens. */
.map-sidebar {
  flex: 1 1 0;
  min-width: 20rem;
  max-width: 44rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  /* Set once for the whole column so children inherit it. */
  font-family: 'Source Sans Pro', sans-serif;
}

.chart-caption {
  margin: 0;
  padding-top: 0.9rem;
  border-top: 1px solid var(--rule);
  font-size: 0.85rem;
  line-height: 1.35;
  color: var(--text-muted);
  max-width: none;
  text-align: left;
  font-style: normal;
}
.chart-caption a {
  font-weight: 600;
  font-size: inherit;
}


/* Overrides the em-based sizing from Visualization.vue, whose cascade made the
   title depend on an ancestor font-size. Pinned in rem against the legend's
   0.95rem body. */
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
  gap: 1.1rem;
  /* Indented to line up with the text inside the title banner above it. */
  padding-left: 0.9rem;
}

/* Play control and prompt on one line. The prompt takes the remaining width
   and wraps within it rather than pushing the button around. */
.chart-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0rem;
  /* Same indent as the legend items and the title banner text, so the button
     lines up with the column above it. Padding on the row rather than a margin
     on the button keeps the prompt's wrapped lines on the same edge. */
  padding-left: 0.9rem;
}

/* 44px square to meet the minimum touch target. flex:0 0 auto keeps it square
   when the prompt wraps, and the flex centring seats the fixed-size icon. */
.play-button {
  flex: 0 0 auto;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  padding: 0;
  border: 0;
  border-radius: 6px;
  background: var(--fire-orange);
  color: var(--white);
  cursor: pointer;
}

/* Grey while playing. The icon darkens with it — white on grey is unreadable. */
.play-button.is-playing {
  background: #d6d6d6;
  color: var(--gray-dark);
}

/* Scoped under #map-container to outrank its `svg { fill: none; width: 100% }`.
   Without the ID that rule wins on specificity and the icon renders unfilled
   and stretched to the whole button. */
#map-container .play-button svg {
  display: block;
  width: 24px;
  height: 24px;
  fill: currentColor;
}

/* Visible focus ring; the default outline is easy to lose against the chart. */
.play-button:focus-visible {
  outline: 2px solid var(--fire-red);
  outline-offset: 2px;
}

/* Guidance rather than a key entry, so it is set smaller than legend labels. */
.legend-note {
  margin: 0;
  font-size: 0.85rem;
  line-height: 1.35;
  color: var(--text-muted);
}

/* One of the two is shown at a time; see the touch breakpoint below. */
.legend-note__touch {
  display: none;
}

/* Phone-sized: no hover, so the wording switches to addressing taps. */
@media screen and (max-width: 700px) {
  .legend-note__pointer {
    display: none;
  }
  .legend-note__touch {
    display: inline;
  }
}

/* Swatch and label. align-items:start keeps the swatch on the label's first
   line rather than centring against two. */
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

/* Fills mirror the map. stroke-width is in viewBox units, which scale to well
   under a pixel at this size, hence the heavier value. */
.legend-swatch path {
  stroke-width: 1.2;
  stroke-linejoin: round;
}
.swatch--current {
  fill: var(--fire-orange);
  stroke: var(--fire-orange-stroke);
}
.swatch--past {
  fill: var(--fire-yellow-soft);
  stroke: var(--fire-yellow-stroke);
}
.swatch--watershed {
  fill: var(--watershed-fill);
  stroke: var(--watershed-stroke);
}

.legend-text {
  display: flex;
  flex-direction: column;
  font-size: 0.95rem;
  line-height: 1.25;
  color: var(--text-muted);
}


.legend-label {
  font-weight: 600;
}

/* Second line of every legend row: acreage on the current-year row, a
   qualifier on the others. */
.legend-value {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-muted);
  font-variant-numeric: tabular-nums;
  min-height: 1.35em; /* reserves the line so rows don't shift when it clears */
}


/* Doubles as the legend key for the active swatch, so it is sized as the
   primary label rather than a caption. */
.legend-year {
  font-size: 1.9rem;
  font-weight: 700;
  line-height: 1;
  color: var(--fire-red); /* darker than the swatch to clear AA on white */
  font-variant-numeric: tabular-nums;
}

/* Positioning context for the hillshade. fit-content shrinks the box to the
   svg, so the absolutely positioned raster registers with the map. */
#firemap-container {
  position: relative;
  width: fit-content;
  margin: 0 auto;
  line-height: 0; /* kills the inline-descender gap under the svg */
  flex: 0 0 auto; /* sized by the svg's aspect ratio, not by flex growth */
}

/* Shaded relief, and the land layer rather than an overlay: the flat-terrain
   tone is baked into the PNG and everything off-land is transparent, so it
   needs no blend mode. Same bbox and aspect ratio as the SVG, so inset:0
   aligns them. */
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

/* Static elements paint under the absolutely positioned hillshade without an
   explicit stacking position. */
#firemap-svg {
  position: relative;
  z-index: 1;
}

/* The map is 720x845 portrait — mapshaper derives height from the western
   states bbox. Driving size from aspect-ratio avoids the letterboxing that
   width:100% + max-height produces.

   Width is the smallest of a viewport-height fit, the map's natural size, and a
   share of the row. The last limit matters: sizing on height alone lets a tall
   window push the map to its cap and squeeze the reading column to its floor,
   which leaves the bar chart drawing a 720-unit viewBox into ~350px. */
#firemap {
  display: block;
  margin: 0 auto;
  aspect-ratio: 720 / 845;
  width: min(66.5vh, 720px, 46vw);
  height: auto;
  max-width: 100%;
}

#basemap {
  fill: none;
  stroke: none;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 1;

  /* Borders only; the land tone comes from the hillshade PNG beneath, and any
     fill here would cover the relief. Dark on the light land tone carries at a
     hairline weight, keeping the borders as reference rather than a graphic
     element competing with the fire perimeters. */
  #states {
    stroke-width: 0.75;
    stroke: var(--state-border);
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
.text-year {
  font-size: 36px;
  fill: var(--fire-orange);
  font-weight: 500;
}
.IMP {
  fill: var(--watershed-fill);
  stroke: var(--watershed-stroke);
  stroke-width: 0.3px;
  opacity: 0.6;
}
/* viewBox units, not page pixels. scaleChartType overwrites both from the
   measured column width, so these are only the pre-measurement fallback. */
.chartAxisText {
  fill: var(--text-muted);
  font-size: 16px;
  font-weight: 700;
}
.tick text{
  fill: var(--text-muted);
  font-size: 14px;
}
.tick {
  fill: var(--text-muted);
}
.caption-container  {
  padding: 2em;
  width: 80vw;
}
/* Fills the reading column so it stays aligned with the legend above it. */
.fire-timeseries-2 {
  display: block;
  width: 100%;
  height: auto;
}

/* --- Stacked layout -------------------------------------------------------
   Last in the file so it overrides the two-column rules above, several of which
   are ID selectors that a media query alone would not outrank.

   The map is a sibling of .map-sidebar, so seating it between the legend and
   the chart means collapsing those levels: display:contents promotes the
   sidebar's children into the grid, and order then sequences all of them. The
   breakpoint sits above the phone range because a portrait map beside a wide
   bar chart needs real width for both. */
@media screen and (max-width: 1100px) {
  .map-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr);
    justify-items: center;
    gap: 1.5rem;
    /* display:contents takes .map-sidebar out of the inheritance chain, so
       this moves up to the grid. */
    font-family: 'Source Sans Pro', sans-serif;
  }

  .map-sidebar {
    display: contents;
  }

  /* Title, legend, map, chart, controls, caption. The legend sits directly
     above the map so the ticking year readout stays in view during playback. */
  .map-sidebar .chart-title-container { order: 1; }
  #map-legend { order: 2; }
  #firemap-container { order: 3; }
  #bar-chart-mount { order: 4; }
  .chart-controls { order: 5; }
  .chart-caption { order: 6; }

  /* Each block spans the single column, capped to a readable measure. */
  .map-sidebar .chart-title-container,
  #map-legend,
  .chart-controls,
  #bar-chart-mount,
  .chart-caption {
    width: 100%;
    max-width: 44rem;
  }

  /* Width-driven here: a portrait map sized off viewport height would push the
     bar chart below the fold. Capped so it doesn't balloon. */
  #firemap-container {
    width: 100%;
    max-width: 520px;
  }

  #firemap {
    height: auto;
    width: 100%;
  }

  /* The grid gap separates these blocks, so their own leading would double up. */
  .chart-caption {
    padding-top: 0;
    border-top: 0;
  }

  /* All that holds the content off the page edge once the wrappers collapse. */
  .map-layout {
    padding: 0 0.75rem;
  }

  /* Compact legend: rows fold onto single lines so the key costs less scroll
     before the map appears. */
  .legend-items {
    gap: 0.5rem;
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

  /* Label and value share a line rather than stacking; wrap lets longer pairs
     fall to a second line instead of widening the column. */
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
    font-size: 0.8rem;
  }
}

</style>