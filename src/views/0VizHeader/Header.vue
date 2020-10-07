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
          }
        },
        mounted() {
          this.d3 = Object.assign(d3Base); // this loads d3 plugins with webpack
          this.makeChartDraw();  // begin script when window loads
          this.makeChartMorph();
        },
      methods: {
        makeChartMorph() {
          const self = this;
          const w = 100;
          const h = 100;

          const timeline = this.d3.select("#time_line")
            .append("svg")
            .attr("class", "#time_burn")
            .attr("viewBox", [0, 0, w, h])
            .append("g")
              .attr("id", "drawHere");

          

          // create data
          //this would be better if read in directly from csv
          var data = [{x: 0, y: 94.93}, 
                      {x: 2.78, y: 72}, 
                      {x: 5.56, y: 89}, 
                      {x: 8.33, y: 84}, 
                      {x: 11.11, y: 61}, 
                      {x: 13.88, y: 95}, 
                      {x: 16.67, y: 93}, 
                      {x: 19.44, y: 98}, 
                      {x: 22.22, y: 89}, 
                      {x: 25.00, y: 97}, 
                      {x: 27.78, y: 75}, 
                      {x: 30.56, y: 94}, 
                      {x: 33.33, y: 54}, 
                      {x: 36.11, y: 100}, 
                      {x: 38.89, y: 97}, 
                      {x: 41.67, y: 62}, 
                      {x: 44.44, y: 46}, 
                      {x: 47.22, y: 79}, 
                      {x: 50.00, y: 59}, 
                      {x: 52.78, y: 63}, 
                      {x: 55.55, y: 93}, 
                      {x: 58.33, y: 61}, 
                      {x: 61.11, y: 26}, 
                      {x: 63.89, y: 14}, 
                      {x: 66.67, y: 72}, 
                      {x: 69.44, y: 89}, 
                      {x: 72.22, y: 88}, 
                      {x: 75.00, y: 52}, 
                      {x: 77.78, y: 0}, 
                      {x: 80.56, y: 71}, 
                      {x: 83.33, y: 82}, 
                      {x: 86.11, y: 66}, 
                      {x: 88.88, y: 72}, 
                      {x: 91.67, y: 12}, 
                      {x: 94.44, y: 31}, 
                      {x: 97.22, y: 84}, 
                      {x: 100.0, y: 5}];
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

          //areas
          var makeArea = this.d3.area()
              .x(function(d) { return d.x })      // Position of both line breaks on the X axis
              .y1(function(d) { return d.y })     // Y position of top line breaks
              .y0(100);                            // Y position of bottom line breaks (200 = bottom of svg area)

          // Add the initial path for area
          this.d3.select("#crop-shape")
            .append('path')
              .attr("id", "charty")
              .attr('d', makeArea(dataBox))
              .style('fill', 'white');
          //draw area for burn area over time shape
          this.d3.select("#charty")
            .transition()
              .delay(2000)
              .duration(5000)
              .attr("d", makeArea(data))

          //animate line drawing across top

        },


        // this does drawing line animation
        makeChartDraw() {
          const self = this;

          var trend = this.d3.select("#charty");

          function drawLine(svgElement){
            svgElement
            .attr("stroke","none")
            .attr("stroke-width","1px")
            .attr('stroke-dasharray','1300px')
            .attr('stroke-dashoffset', '-1300px')
            .transition()
              .duration(5000)
              .delay(1000)
              .attr("stroke", "rgb(250,109,49)")
              .attr('stroke-dashoffset','0px');

          }

          //this transition works between two lines of same number of points but color fill does not move with
          drawLine(trend);

          var line = this.d3.line();
          var data1 = [[0, 100], [10, 100], [20, 100], [30, 100], [40, 100], [50, 100], [60, 100], [70, 100], [80, 100], [90, 100], [100, 100]];
          var data2 = [[0, 0], [10, 30], [20, 10], [30, 40], [40, 20], [50, 60], [60, 90], [70, 30], [80, 60], [90, 50], [100, 80]];

          function transLine(path_id){
            path_id
            .attr('d', line(data1))
            .attr("fill", "white")
            .transition()
            .duration(1000)
            .attr('d', line(data2))
            .attr("fill", "white");
          };
          //transLine(this.d3.select('#path1'));

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