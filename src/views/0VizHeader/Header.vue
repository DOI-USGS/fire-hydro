<template>
  <div id="header-wrapper">
    <div id="header">
      <div class="text-content">
        <h1 id="title">
          {{ title }}
        </h1>
        <p id="subheader">
          Communities across the United States and the globe rely on clean water flowing from forested watersheds. But these water source areas are impacted by the effects of wildfire. <br><br>To help water providers and land managers prepare for impacts from wildfire on water supplies, the U.S. Geological Survey is working to measure and predict post-fire water quality and quantity.
        </p>
      </div>
      <div id="annotate-container">
        <svg
          id="annotate-svg"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 200 150"
          width="200px"
          height="150px"
          :style="{ right: annotateRight }"
        >
          <g transform="translate(-10 0)">
            <rect
              id="box-2020"
              width="160"
              height="60"
              style="fill: rgb(245,169,60)"
            />
            <text
              id="text-2020"
              transform="translate(15 19.61)"
              style="font-size: .9em; font-weight: 200"
            >Over 9 million acres <tspan
              x="0"
              y="15"
            >burned in 2020, <tspan
              x="0"
              y="30"
            >the most on record</tspan></tspan></text>
            <g
              id="arrow-2020"
              transform="translate(155 35)"
            >
              <path
                d="M23.54,37.23A60.65,60.65,0,0,0,3.09.45C1.37-1-1.15,1.47.58,3A57.73,57.73,0,0,1,20.13,38.17a1.79,1.79,0,0,0,2.18,1.24,1.81,1.81,0,0,0,1.23-2.18Z"
                style="fill: rgb(245,169,60)"
              />
              <path
                d="M25.51,37.91,26.86,21.7a2,2,0,0,0-4,0L21.47,37.91a2,2,0,0,0,4,0Z"
                style="fill: rgb(245,169,60)"
              />
              <path
                d="M21.66,35.31c-4.93-.6-9.89-1-14.82-1.63a2,2,0,0,0-2,2,2.07,2.07,0,0,0,2,2c4.93.6,9.89,1,14.82,1.63a2,2,0,0,0,2-2,2.07,2.07,0,0,0-2-2Z"
                style="fill: rgb(245,169,60)"
              />
            </g>
          </g>
        </svg>
      </div>

      <div id="time_line" />
      
      <svg
        id="crop-shape"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 120"
        preserveAspectRatio="none"
        role="img"
        aria-label="Decorative animated silhouette suggesting the shape of wildfire burn area over time in the western United States"
      >
        <path id="path1" />
        <g id="axes" />

        <rect
          id="white-block"
          width="100"
          height="120"
          x="0"
          y="100"
          style="fill:white; stroke: white;"
        />
      </svg>
    </div> 
    <div id="time-title">
      <svg
        id="axes-svg"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 1000 3"
      >
        <line
          id="axis-line"
          x1="0"
          y1="0"
          x2="2000"
          y2="0"
        />
      </svg>
      <div
        id="header-chart-title"
        class="chart-title-container"
      >
        <p class="chart-title">
          Area burned by wildfires in the Western U.S.
        </p>
        <p>{{ yearRange }}</p>
        <div class="fade-effect" />
      </div>
    </div>
    <div 
      id="byline-wrapper" 
      class="text-content"
    >
      <p class="byline">
        U.S. Geological Survey<br>Water Resources Mission Area
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import * as d3 from 'd3';

const title = import.meta.env.VITE_APP_LONG_TITLE;
const publicPath = import.meta.env.BASE_URL;

// Read from the data so it stays in step with the shape below it.
const yearRange = ref('');

// Horizontal position of the callout arrow, measured from the right edge. It
// points at 2020 on the silhouette, so the offset depends on how many years the
// series runs. Derived from the same rows the shape is built from so it tracks
// the series length.
const annotateRight = ref('5.3%');

const ANNOTATED_YEAR = '2020';

onMounted(async () => {
  const rows = await d3.csv(publicPath + 'data/fire_timeseries.csv');
  yearRange.value = `${rows[0].YEAR} to ${rows[rows.length - 1].YEAR}`;

  // Same x mapping makeChartMorph uses, inverted because #annotate-svg is
  // positioned from the right. It shares a containing block with #crop-shape,
  // so the percentage refers to the same width for both.
  const idx = rows.findIndex(function(d) { return d.YEAR === ANNOTATED_YEAR; });
  if (idx >= 0 && rows.length > 1) {
    annotateRight.value = `${100 - (idx / (rows.length - 1)) * 100}%`;
  }

  makeChartMorph(rows);
});

function makeChartMorph(rows) {
  // Built from the same timeseries the map's bar chart reads, so the
  // silhouette and the chart stay in step as the pipeline updates.
  const acres = rows.map(function(d) { return parseFloat(d.area_acres); });
  const peak = Math.max(...acres);
  const last = acres.length - 1;

  // y runs down from the top of the 0 0 100 120 viewBox and the area fills to
  // y0 = 100, so the peak year sits at 0 and touches the top of the frame.
  const data_burn = acres.map(function(a, i) {
    return { x: (i / last) * 100, y: 100 - (a / peak) * 100 };
  });

  // empty box for spacing — same point count as the shape it morphs into, so
  // the path interpolation is vertex to vertex
  const dataBox = data_burn.map(function(d) { return { x: d.x, y: 150 }; });

  // line data
  const dataLine_burn = data_burn.map(function(d) { return [d.x, d.y]; });

  const line = d3.line();

  const makeArea = d3.area()
    .x(function(d) { return d.x })
    .y1(function(d) { return d.y })
    .y0(100);

  function makeElementAppear(timeElement, delay, time_dur) {
    timeElement
      .style("opacity", "0")
      .transition()
      .delay(delay)
      .duration(time_dur)
      .style("opacity", "1");
  }

  makeElementAppear(d3.select("#annotate-container"), 4500, 1000);
  makeElementAppear(d3.select("#axis-line"), 3000, 800);
  makeElementAppear(d3.select(".text-swap"), 4000, 1000);

  // Add the initial path for area using negative space
  d3.select("#crop-shape")
    .append('path')
    .attr("id", "charty")
    .attr('d', makeArea(dataBox));
      
  // morph path to include burn area over time shape
  d3.select("#charty")
    .transition()
    .delay(1000)
    .duration(3000)
    .attr("d", makeArea(data_burn));

  // animate line drawing across top
  d3.select("#path1")
    .attr('d', line(dataLine_burn))
    .attr("stroke", "none")
    .attr("fill", "none")
    .attr("stroke-miterlimit", "10")
    .attr("stroke-width", "1px")
    .attr("stroke-dasharray", "1000px")
    .attr("stroke-dashoffset", "1000px")
    .transition()
    .delay(3000)
    .duration(2000)
    .attr("stroke", "rgb(245,169,60)")
    .attr("stroke-linejoin", "miter")
    .attr("stroke-miterlimit", "20")
    .attr("stroke-dashoffset", "0px");
}
</script>

<style lang="scss">

    #header {
        position: relative;
        height: 1200px;
        background-image: linear-gradient(0deg, var(--fire-yellow-wash) 40%, transparent 95%), url(../../assets/images/fieldphotos/scar_2500w.png);
        background-attachment: fixed;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
        -webkit-background-size:cover; 
      @media screen and (max-width: 1000px) {
          height: 1200px;
          background-image: linear-gradient(0deg, var(--fire-yellow-wash) 40%, transparent 95%), url(../../assets/images/fieldphotos/scar_1000w.png);
      }
      @media screen and (max-width: 800px) {
          height: 1100px;
      }
      @media screen and (max-width: 600px) {
          height: 1200px;
          background-image: linear-gradient(0deg, var(--fire-yellow-wash) 40%, transparent 95%), url(../../assets/images/fieldphotos/scar_600w.png);
      }
      @media screen and (max-width: 400px) {
          height: 1200px;
      }
      @supports (-webkit-touch-callout: inherit) {
        background-attachment: scroll;
        #title {
          background-color: rgb(245,169,60);
          padding: 80px 20px 20px 20px;
          margin: 100px 0 100px 0;
        }
      }
    }

#time-title {
  margin: 10px;
  @media screen and (max-width: 350px) {
          width: 100vw;
      }

  #axes-svg {
      margin-top: 0px;
      z-index: 1;
    }

  #axis-line {
    stroke-width: 4px;
    stroke: var(--gray-light);
  }
  
  .fade-effect {
    position: absolute;
    top: 0;
    bottom: 0;
    right: 0;
    width: 100%;
    background: white;
    animation: slide 5s cubic-bezier(.5,.5,0,1);
    animation-fill-mode: forwards;
    animation-delay: 5s;
  }
}

#charty {
  fill: white;
  opacity: 1;
}

#path1 {
  stroke-linejoin: miter;
}

select{
  font-size: 1.4em;
  border:0;
  padding: .2em;
}
    #header p {
      color: white;
    }

    #byline-wrapper {
      margin-top: 100px;
    }

    #crop-shape, #time_line, #line-axes {
        position: absolute;
        bottom: 0;
        width: 100%;
        height: 250px;
    }

    @media (min-width: 700px) {
        .svg--sm {
            display: none;
        }
    }

    .byline {
        font-style: italic;
        padding: 1em 0 0 0;
    }

    #crop-shape {
      z-index: 0;
    }

    /* The arrow points at 2020, partway in from the right end of the series.
       `right` is set from the data in script setup (see annotateRight); this
       value is only the pre-hydration fallback. */
    #annotate-svg {
      position: absolute;
      bottom: 200px;
      right: 5.3%;
    }

#annotate-container {
  width: 200px;
  float: right;
  @media screen and (max-width: 1000px) {
          margin-top: 0px;
      }
      @media screen and (max-width: 800px) {
          width:180px;
      }
      @media screen and (max-width: 600px) {
          width:170px;
      }
      @media screen and (max-width: 400px) {
          width:150px;
      }
}

// Animation
@keyframes slide {
  0% { width: 100; }
  60% { width: 100; }
  90% { width: 0; }
  100% { width: 0; }  
}

</style>
