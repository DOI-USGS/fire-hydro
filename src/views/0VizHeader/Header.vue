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
            >Over 8 million acres <tspan
              x="0"
              y="15"
            >have burned in 2020, <tspan
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
        <p>1984 to 2020</p>
        <p>Last update Nov 1, 2020</p>
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

<script>
import * as d3Base from "d3";
    export default {
        name: 'Header',
        props: {
            title: {
                type: String,
                default: process.env.VUE_APP_TITLE
            }
        },
        data() {
          return {
            publicPath: process.env.BASE_URL, // this is need for the data files in the public folder, this allows the application to find the files when on different deployment roots
            d3: null, // this is used so that we can assign d3 plugins to the d3 instance
          }
        },
        mounted() {
          this.d3 = Object.assign(d3Base); // this loads d3 plugins with webpack
          this.makeChartMorph(); // begin script when window loads
        },
      methods: {
        setPanels() {
          let promises = [this.d3.csv(self.publicPath + "data/fire_timeseries.csv")]
          Promise.all(promises).then(self.callback);
        },
        callback(data) {          
          let csv_burn = data[0];

        },
        makeChartMorph() {
          const self = this;

          // create data - this would be better if read in directly from csv
          //data for area chart - area burned
          var data_burn = [{x: 0, y: 90}, 
                      {x: 2.78, y: 71}, 
                      {x: 5.56, y: 85}, 
                      {x: 8.33, y: 80}, 
                      {x: 11.11, y: 59}, 
                      {x: 13.88, y: 91}, 
                      {x: 16.67, y: 89}, 
                      {x: 19.44, y: 94}, 
                      {x: 22.22, y: 85}, 
                      {x: 25.00, y: 93}, 
                      {x: 27.78, y: 73}, 
                      {x: 30.56, y: 90}, 
                      {x: 33.33, y: 55}, 
                      {x: 36.11, y: 95}, 
                      {x: 38.89, y: 93}, 
                      {x: 41.67, y: 62}, 
                      {x: 44.44, y: 45}, 
                      {x: 47.22, y: 76}, 
                      {x: 50.00, y: 58}, 
                      {x: 52.78, y: 63}, 
                      {x: 55.55, y: 89}, 
                      {x: 58.33, y: 59}, 
                      {x: 61.11, y: 27}, 
                      {x: 63.89, y: 13}, 
                      {x: 66.67, y: 68}, 
                      {x: 69.44, y: 83}, 
                      {x: 72.22, y: 84}, 
                      {x: 75.00, y: 50}, 
                      {x: 77.78, y: 9}, 
                      {x: 80.56, y: 67}, 
                      {x: 83.33, y: 71}, 
                      {x: 86.11, y: 58}, 
                      {x: 88.88, y: 71}, 
                      {x: 91.67, y: 16}, 
                      {x: 94.44, y: 36}, 
                      {x: 97.22, y: 82}, 
                      {x: 100.0, y: 0}];


          // empty box for spacing
          var dataBox = [{x: 0, y: 150}, 
                      {x: 2.78, y: 150}, 
                      {x: 5.56, y: 150}, 
                      {x: 8.33, y: 150}, 
                      {x: 11.11, y: 150}, 
                      {x: 13.88, y: 150}, 
                      {x: 16.67, y: 150}, 
                      {x: 19.44, y: 150}, 
                      {x: 22.22, y: 150}, 
                      {x: 25.00, y: 150}, 
                      {x: 27.78, y: 150}, 
                      {x: 30.56, y: 150}, 
                      {x: 33.33, y: 150}, 
                      {x: 36.11, y: 150},
                      {x: 38.89, y: 150}, 
                      {x: 41.67, y: 150}, 
                      {x: 44.44, y: 150}, 
                      {x: 47.22, y: 150}, 
                      {x: 50.00, y: 150}, 
                      {x: 52.78, y: 150}, 
                      {x: 55.55, y: 150}, 
                      {x: 58.33, y: 150}, 
                      {x: 61.11, y: 150}, 
                      {x: 63.89, y: 150}, 
                      {x: 66.67, y: 150}, 
                      {x: 69.44, y: 150}, 
                      {x: 72.22, y: 150}, 
                      {x: 75.00, y: 150}, 
                      {x: 77.78, y: 150}, 
                      {x: 80.56, y: 150}, 
                      {x: 83.33, y: 150}, 
                      {x: 86.11, y: 150}, 
                      {x: 88.88, y: 150}, 
                      {x: 91.67, y: 150}, 
                      {x: 94.44, y: 150}, 
                      {x: 97.22, y: 150}, 
                      {x: 100.0, y: 150}];

          //this is the same as the area top line but just a line
          var dataLine_burn = [[0, 90], 
                      [2.78, 71], 
                      [5.56, 85], 
                      [8.33, 80], 
                      [11.11, 59], 
                      [13.88, 91], 
                      [16.67, 89], 
                      [19.44, 94], 
                      [22.22, 85], 
                      [25.00, 93], 
                      [27.78, 73], 
                      [30.56, 90], 
                      [33.33, 55], 
                      [36.11, 95], 
                      [38.89, 93], 
                      [41.67, 62], 
                      [44.44, 45], 
                      [47.22, 76], 
                      [50.00, 58], 
                      [52.78, 63], 
                      [55.55, 89], 
                      [58.33, 59], 
                      [61.11, 27], 
                      [63.89, 13], 
                      [66.67, 68], 
                      [69.44, 83], 
                      [72.22, 84], 
                      [75.00, 50], 
                      [77.78, 9], 
                      [80.56, 67], 
                      [83.33, 71], 
                      [86.11, 58], 
                      [88.88, 71], 
                      [91.67, 16], 
                      [94.44, 36], 
                      [97.22, 82], 
                      [100.0, 0]];
          
          // draw a line
          var line = this.d3.line();

          //make area chart
          var makeArea = this.d3.area()
              .x(function(d) { return d.x })      // Position of both line breaks on the X axis
              .y1(function(d) { return d.y })     // Y position of top line breaks
              .y0(100);                            // Y position of bottom line breaks (200 = bottom of svg area)
          
          function makeElementAppear(timeElement,delay, time_dur){
            timeElement
            .style("opacity", "0")
            .transition()
            .delay(delay)
            .duration(time_dur)
              .style("opacity", "1")
          }
          function makeElementDisppear(timeElement,delay, time_dur){
            timeElement
            .style("opacity", "1")
            .transition()
            .delay(delay)
            .duration(time_dur)
              .style("opacity", "0")
          }
          makeElementAppear(this.d3.select("#annotate-container"), 4500, 1000);
          // makeElementAppear(this.d3.select(".timeline-title"), 4000, 1000);
          makeElementAppear(this.d3.select("#axis-line"), 3000, 800);
          makeElementAppear(this.d3.select(".text-swap"), 4000, 1000);

          // this.d3.select(".timeline-title-box")
          // .attr("fill","none")
          // .attr("width", "0")
          // .transition()
          //   .delay(3000)
          //   .duration(2000)
          //   .attr("width", "450")
          //   .attr("fill", "rgb(245,169,60)");

          var dataStart = data_burn;
          var dataGroup = [
            [1, 'data_burn', "Total area burned by wildfires"],
            [2, 'data_mean', "Largest wildfires"],
            [3, 'dataBox', "Average wildfire area"]];


          // Add the initial path for area using negative space
          this.d3.select("#crop-shape")
            .append('path')
              .attr("id", "charty")
              .attr('d', makeArea(dataBox));
              // .style('fill', 'white')
              // .style("opacity", "1");
              
          //morph path to include burn area over time shape
          this.d3.select("#charty")
            .transition()
              .delay(1000)
              .duration(3000)
              .attr("d", makeArea(dataStart));

          //animate line drawing across top
          function drawLine(top_line) {
             top_line
            .attr('d', line(dataLine_burn))
            .attr("stroke", "none")
            .attr("fill", "none")
            .attr("stroke-miterlimit", "10")
            .attr("stroke-width","1px")
            .attr("stroke-dasharray","1000px")
            .attr("stroke-dashoffset","1000px")
            .transition()
              .delay(3000)
              .duration(2000)
              .attr("stroke","rgb(245,169,60)")
              .attr("stroke-linejoin", "miter")
              .attr("stroke-miterlimit", "20")
              .attr("stroke-dashoffset","0px");

          };
         drawLine(this.d3.select("#path1"), this.d3.select("#burn_2020"), this.d3.select(".text-swap"), this.d3.select(".text-swap-mean"));


        }
        
      }
    };
</script>

<style lang="scss">

    // Import Colors
    $white: rgb(255,255,255);
    $none: rgba(255,255,255,0);
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

    #header {
        position: relative;
        height: 1200px;
        background-image: linear-gradient(0deg, $fireYellowlight 40%, $none 95%), url(../../assets/images/fieldphotos/scar_2500w.png);
        background-attachment: fixed;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
        -webkit-background-size:cover; 
      @media screen and (max-width: 1000px) {
          height: 1200px;
          background-image: linear-gradient(0deg, $fireYellowlight 40%, $none 95%), url(../../assets/images/fieldphotos/scar_1000w.png);
      }
      @media screen and (max-width: 800px) {
          height: 1100px;
      }
      @media screen and (max-width: 600px) {
          height: 1200px;
          background-image: linear-gradient(0deg, $fireYellowlight 40%, $none 95%), url(../../assets/images/fieldphotos/scar_600w.png);
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
    stroke: $lightGray;
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


    #annotate-svg {
      position: absolute;
      bottom: 200px;
      right: 0;
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