<template>
  <div id="header-wrapper">
    <div id="header">
      <div class="text-content">
        <h1>{{ title }}</h1>
        <p id="subheader">
          Post wildfire, burned landscapes respond to rain as though they are covered in plastic wrap   . USGS hydrologists are studying what that means for water supply in the Western United States.
        </p>
      </div>
      <div id="time_line" />
      <svg
        id="crop-shape"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 150"
        preserveAspectRatio="none"
      >
        <path id="path1" />
        <g id="axes" />

        <rect
          id="white-block"
          width="100"
          height="50"
          x="0"
          y="100"
          style="fill:white;"
        />
      </svg>
   
      <svg
        id="line-axes"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 100"
        preserveAspectRatio="none"
      >
        <path id="axis-x" />
        <path id="axis-y" />
      </svg>
    </div> 
    <div>
      <svg
        id="Layer_1"
        data-name="Layer 1"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 1549.76 24.92"
      >
        <line
          class="cls-1"
          x1="50.45"
          y1="10.53"
          x2="1491.45"
          y2="10.53"
        />
        <text
          class="cls-2"
          transform="translate(1504 17.14)"
        >2020</text>
        <text
          class="cls-2"
          transform="translate(0 17.14)"
        >1984</text>
        <path d="M1478.85,3.58l4.92,4.13,2.38,2,1.2,1c.26.22,1,.66,1.11,1s-.85,1.47-1.14,1.87l-1.84,2.52-3.91,5.35a1.5,1.5,0,1,0,2.59,1.52l4.37-6c.72-1,1.47-2,2.17-3a3.58,3.58,0,0,0,.71-3,4.93,4.93,0,0,0-1.79-2.27c-.94-.8-1.89-1.59-2.84-2.38L1481,1.46c-1.47-1.23-3.6.88-2.12,2.12Z" />
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
          this.makeChartMorph(); // begin script when window loads
        },
      methods: {
        makeChartMorph() {
          const self = this;

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

          //this is the same as the area top line
          var dataLine = [[0, 94.93], 
                      [2.78, 72], 
                      [5.56, 89], 
                      [8.33, 84], 
                      [11.11, 61], 
                      [13.88, 95], 
                      [16.67, 93], 
                      [19.44, 98], 
                      [22.22, 89], 
                      [25.00, 97], 
                      [27.78, 75], 
                      [30.56, 94], 
                      [33.33, 54], 
                      [36.11, 100], 
                      [38.89, 97], 
                      [41.67, 62], 
                      [44.44, 46], 
                      [47.22, 79], 
                      [50.00, 59], 
                      [52.78, 63], 
                      [55.55, 93], 
                      [58.33, 61], 
                      [61.11, 26], 
                      [63.89, 14], 
                      [66.67, 72], 
                      [69.44, 89], 
                      [72.22, 88], 
                      [75.00, 52], 
                      [77.78, 0], 
                      [80.56, 71], 
                      [83.33, 82], 
                      [86.11, 66], 
                      [88.88, 72], 
                      [91.67, 12], 
                      [94.44, 31], 
                      [97.22, 84], 
                      [100.0, 5]];
          //lines
          var line = this.d3.line();

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
              .style('fill', 'white')
              .style("opacity", "1");
              
          //morph path to burn area over time shape
          this.d3.select("#charty")
            .transition()
              .delay(1000)
              .duration(3000)
              .attr("d", makeArea(data))

          //animate line drawing across top
          this.d3.select("#path1")
            .attr('d', line(dataLine))
            .attr("stroke", "none")
            .attr("fill", "none")
            .attr("stroke-dasharray","1000px")
            .attr("stroke-dashoffset","1000px")
            .attr("stroke-linejoin", "miter")
            .attr("stroke-miterlimit", "10")
            .transition()
              .delay(3000)
              .duration(3000)
              .attr("stroke","rgb(245,169,60)")
              .attr("stroke-linejoin", "miter")
              .attr("stroke-dashoffset","0px")
              .attr("stroke-miterlimit", "10")
              .attr("stroke-width","1px")

/*           //add x axis
          var svg = this.d3.select("#axes")

          var x = this.d3.scaleLinear()
            .domain([1984, 2020])
            .range([0, 100])

          svg .append('g')
          .attr("transform","translate(0,130)")
          .call(this.d3.axisBottom(x));
 */
          //draw x-axis
          this.d3.select("#axis-x")
          .attr('d', line([[5,100], [95,100]]))
          .attr("stroke","none")
          .attr("stroke-dasharray","100px")
          .attr("stroke-dashoffset","100px")
          .transition()
            .delay(3000)
            .duration(3000)
            .attr("stroke-dashoffset","0px")
            .attr("stroke", "black")
            .attr("stroke-width", "2px");
/* 
          this.d3.select("#line-axes").append("g")
          .append("text")
            .attr("x", "95")
            .attr("y", "90")
            .attr("font-size", "20px")
            .text("2020") */

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

    #byline-wrapper {
      margin-top: 100px;
    }

    #crop-shape, #time_line, #line-axes {
        position: absolute;
        bottom: 0;
        width: 100%;
        height: 250px;
 
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