<template>
  <div id="header-wrapper">
    <div id="header" >
      <div class="text-content" >
        <h1>{{ title }}</h1>
        <p id="subheader">After wildfires, burned landscapes respond to rain as though they are covered in plastic wrap. USGS hydrologists are studying what that means for the Western US’s water supply.</p>
      </div>
      <div id="time_line">
        </div>
     <svg
        id="crop-shape"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 100"
        preserveAspectRatio="none"
      >
   <!--      <polygon
          class="fire-rate-crop"
          points="97.100 50.000, 94.200 0.000, 94.200 0.000, 94.200 1.900, 94.000 3.000, 93.900 6.100, 93.900 7.800, 93.800 9.500, 93.100 29.000, 93.100 29.000, 92.100 54.600, 92.100 54.600, 91.800 61.100, 91.800 61.400, 91.700 63.400, 91.700 63.600, 91.500 67.200, 91.500 67.500, 91.400 68.000, 91.400 68.700, 91.400 68.700, 91.400 69.200, 91.400 69.200, 91.300 69.600, 91.300 69.600, 91.300 69.900, 91.300 69.900, 91.300 70.100, 91.300 70.100, 91.300 71.000, 91.300 71.000, 88.000 64.300, 85.300 7.800, 81.900 14.900, 78.900 73.400, 76.100 45.600, 73.200 52.700, 70.000 9.000, 66.700 1.500, 63.800 15.300, 60.600 21.400, 57.500 67.500, 54.500 32.900, 51.600 72.700, 48.400 29.700, 45.600 49.300, 42.500 98.100, 39.500 80.500, 36.600 44.400, 33.300 90.900, 30.300 67.300, 26.600 90.900, 23.600 89.500, 21.300 79.200, 18.000 60.300, 14.800 91.700, 12.000 56.400, 8.900 84.700, 5.800 82.200, 2.400 80.000, 0.000 100.000, 100.000 100.000, 100.000 0.000"
        />
        <polyline
          class="fire-rate-line"
          points="100.000 0.000, 97.100 50.000, 94.200 0.000, 94.200 0.000, 94.200 1.900, 94.000 3.000, 93.900 6.100, 93.900 7.800, 93.800 9.500, 93.100 29.000, 93.100 29.000, 92.100 54.600, 92.100 54.600, 91.800 61.100, 91.800 61.400, 91.700 63.400, 91.700 63.600, 91.500 67.200, 91.500 67.500, 91.400 68.000, 91.400 68.700, 91.400 68.700, 91.400 69.200, 91.400 69.200, 91.300 69.600, 91.300 69.600, 91.300 69.900, 91.300 69.900, 91.300 70.100, 91.300 70.100, 91.300 71.000, 91.300 71.000, 88.000 64.300, 85.300 7.800, 81.900 14.900, 78.900 73.400, 76.100 45.600, 73.200 52.700, 70.000 9.000, 66.700 1.500, 63.800 15.300, 60.600 21.400, 57.500 67.500, 54.500 32.900, 51.600 72.700, 48.400 29.700, 45.600 49.300, 42.500 98.100, 39.500 80.500, 36.600 44.400, 33.300 90.900, 30.300 67.300, 26.600 90.900, 23.600 89.500, 21.300 79.200, 18.000 60.300, 14.800 91.700, 12.000 56.400, 8.900 84.700, 5.800 82.200, 2.400 80.000, 0.000 100.000"
          /> -->
>
          <path id="path1" style="stroke: green; stroke-width: 2ps; fill: none;"  />
           <path id="path2" style="stroke: green; stroke-width: 2ps; fill: none;"  />
           <polygon id="poly_test" fill="yellow" stroke="blue" stroke-width="2" points="0,100 0,50 10,50 20,50 30,50 40,50 60,50 70,50 80,50 90,50 100,50 100,100"></polygon>
      </svg>
    </div>
    <div 
      id="byline-wrapper" 
      class="text-content"
    >
      <p class="byline">
        U.S. Geological Survey<br>Water Mission Area
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
            gdp: [
              {country: "USA", value: 20.5 },
              {country: "China", value: 13.4 },
              {country: "Germany", value: 4.0 },
              {country: "Japan", value: 4.9 },
              {country: "France", value: 2.8 }
            ]
          }
        },
        mounted() {
          this.d3 = Object.assign(d3Base); // this loads d3 plugins with webpack
          this.makeChartDraw();  // begin script when window loads
          this.makeChartMorph();
        },
      methods: {
        makeChartMorph() {
          const w = 100;
          const h = 100;

          const timeline = this.d3.select("#time_line")
            .append("svg")
            .attr("class", "#time_burn")
            .attr("viewBox", [0, 0, w, h]);

          const g = timeline.append("g");

          
          


          




        },
        makeChartDraw() {
          const self = this;

          var trend = this.d3.select(".fire-rate-line");
          var trendback = this.d3.select(".fire-rate-crop");

          function drawLine(svgElement, svgBack){
            svgElement
            .attr("stroke","none")
            .attr("fill", "none")
            .attr("stroke-width","1px")
            .attr('stroke-dasharray','1300px')
            .attr('stroke-dashoffset', '-1300px')
            .transition()
              .duration(5000)
              .delay(1000)
              .attr("stroke", " rgb(250,109,49)")
              .attr('stroke-dashoffset','0px');

            svgBack
            .attr("opacity", "0")
            .transition()
              .duration(1000)
              .delay(6000)
              .attr("color", "white")
              .attr("fill", "white")
              .attr("background-color", "white")
              .attr("opacity", "1")

          }
          drawLine(trend, trendback);

          var line = this.d3.line();
          var data1 = [[0, 100], [10, 100], [20, 100], [30, 100], [40, 100], [50, 100], [60, 100], [70, 100], [80, 100], [90, 100], [100, 100]];
          var data2 = [[0, 0], [10, 30], [20, 10], [30, 40], [40, 20], [50, 60], [60, 90], [70, 30], [80, 60], [90, 50], [100, 80]];

          function transLine(path_id){
            path_id
            .attr('d', line(data1))
            .transition()
            .duration(1000)
            .attr('d', line(data2));
          };
          transLine(this.d3.select('#path1'));

          var line = this.d3.line();
          var poly1 = [[0, 100], [10, 100], [20, 100], [30, 100], [40, 100], [50, 100], [60, 100], [70, 100], [80, 100], [90, 100], [100, 100]];
          var poly2 = [[0, 100], [0, 30], [20, 10], [30, 40], [40, 20], [50, 60], [60, 90], [70, 30], [80, 60], [90, 50], [100, 100]];

          function transPoly(path_id){
            path_id
            .transition()
            .duration(1000)
            .attr('points', line(poly2));
          }
          transPoly(this.d3.select('#poly_test'));
        }
      }
    };
</script>

<style lang="scss">

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

    #header {
        position: relative;
        height: 900px;
        background-image: url(../../assets/images/fieldphotos/scar.png);
        /* background-image: linear-gradient($black, $fireYellow); */
        background-attachment: fixed;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
    }

    #header h1 {
        padding: 200px 0 50px 0;
        text-align: left;
        line-height: 1em;
    }

    #header p {
      color: white;
    }

    #crop-shape, #time_line {
        position: absolute;
        bottom: 0;
        width: 100%;
        height: 200px;
 
    }

    // @media (max-width: 699px) {
    //   .svg--lg {
    //     display: none;
    //   }
    // }

    @media (min-width: 700px) {
        .svg--sm {
            display: none;
        }
    }

    .byline {
        font-style: italic;
        padding: 1em 0 0 0;
    }
</style>