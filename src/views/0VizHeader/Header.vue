<template>
  <div id="header-wrapper">
    <div id="header">
      <div class="text-content">
        <h1>{{ title }}</h1>
        <p id="subheader">
          Post wildfire, burned landscapes respond to rain as though they are covered in plastic wrap   . USGS hydrologists are studying what that means for water supply in the Western United States.
        </p>
      </div>
      <div id="annotate-container">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 303.96 154.98">
          <g  transform="translate(120 80)" >
              <rect id="box-2020" width="150" height="60" style="fill: rgb(245,169,60)"/>
              <text id="text-2020" transform="translate(7.55 19.61)" style="font-size: 1.2em; font-weight: 200" >Over 8 million acres <tspan x="0" y="15">have burned in 2020, <tspan x="0" y="30">the most on record</tspan></tspan></text>
              <g id="arrow-2020" transform="translate(155 35)">
                 <path d="M23.54,37.23A60.65,60.65,0,0,0,3.09.45C1.37-1-1.15,1.47.58,3A57.73,57.73,0,0,1,20.13,38.17a1.79,1.79,0,0,0,2.18,1.24,1.81,1.81,0,0,0,1.23-2.18Z" style="fill: rgb(245,169,60)"/>
                <path d="M25.51,37.91,26.86,21.7a2,2,0,0,0-4,0L21.47,37.91a2,2,0,0,0,4,0Z" style="fill: rgb(245,169,60)"/>
                <path d="M21.66,35.31c-4.93-.6-9.89-1-14.82-1.63a2,2,0,0,0-2,2,2.07,2.07,0,0,0,2,2c4.93.6,9.89,1,14.82,1.63a2,2,0,0,0,2-2,2.07,2.07,0,0,0-2-2Z" style="fill: rgb(245,169,60)"/>
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
      
      <select id="dataDrop"></select>
      <svg
        id="axes-svg"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 350 50"
      >
        <rect
          class="timeline-title-box"
          x="0"
          y="-5"
          height="40"
        />
        <text
          class="timeline-title"
          x="7"
          y="24"
          style="font-size: 1.4em; font-weight: 600"
        >in the western U.S. from 1984 to 2020</text>
      
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
          var data_burn = [{x: 0, y: 89}, 
                      {x: 2.78, y: 70}, 
                      {x: 5.56, y: 84}, 
                      {x: 8.33, y: 80}, 
                      {x: 11.11, y: 57}, 
                      {x: 13.88, y: 91}, 
                      {x: 16.67, y: 89}, 
                      {x: 19.44, y: 94}, 
                      {x: 22.22, y: 85}, 
                      {x: 25.00, y: 92}, 
                      {x: 27.78, y: 72}, 
                      {x: 30.56, y: 89}, 
                      {x: 33.33, y: 53}, 
                      {x: 36.11, y: 95}, 
                      {x: 38.89, y: 92}, 
                      {x: 41.67, y: 61}, 
                      {x: 44.44, y: 43}, 
                      {x: 47.22, y: 75}, 
                      {x: 50.00, y: 57}, 
                      {x: 52.78, y: 62}, 
                      {x: 55.55, y: 88}, 
                      {x: 58.33, y: 58}, 
                      {x: 61.11, y: 24}, 
                      {x: 63.89, y: 10}, 
                      {x: 66.67, y: 67}, 
                      {x: 69.44, y: 83}, 
                      {x: 72.22, y: 83}, 
                      {x: 75.00, y: 48}, 
                      {x: 77.78, y: 6}, 
                      {x: 80.56, y: 67}, 
                      {x: 83.33, y: 70}, 
                      {x: 86.11, y: 56}, 
                      {x: 88.88, y: 70}, 
                      {x: 91.67, y: 13}, 
                      {x: 94.44, y: 34}, 
                      {x: 97.22, y: 82}, 
                      {x: 100.0, y: 0}];

          var data_mean = [{x: 0, y: 99}, 
                      {x: 2.78, y: 90}, 
                      {x: 5.56, y: 97}, 
                      {x: 8.33, y: 90}, 
                      {x: 11.11, y: 61}, 
                      {x: 13.88, y: 100}, 
                      {x: 16.67, y: 89}, 
                      {x: 19.44, y: 99}, 
                      {x: 22.22, y: 90}, 
                      {x: 25.00, y: 77}, 
                      {x: 27.78, y: 91}, 
                      {x: 30.56, y: 91}, 
                      {x: 33.33, y: 77}, 
                      {x: 36.11, y: 88}, 
                      {x: 38.89, y: 97}, 
                      {x: 41.67, y: 80}, 
                      {x: 44.44, y: 83}, 
                      {x: 47.22, y: 93}, 
                      {x: 50.00, y: 63}, 
                      {x: 52.78, y: 80}, 
                      {x: 55.55, y: 89}, 
                      {x: 58.33, y: 83}, 
                      {x: 61.11, y: 80}, 
                      {x: 63.89, y: 71}, 
                      {x: 66.67, y: 83}, 
                      {x: 69.44, y: 87}, 
                      {x: 72.22, y: 94}, 
                      {x: 75.00, y: 79}, 
                      {x: 77.78, y: 70}, 
                      {x: 80.56, y: 79}, 
                      {x: 83.33, y: 80}, 
                      {x: 86.11, y: 70}, 
                      {x: 88.88, y: 83}, 
                      {x: 91.67, y: 69}, 
                      {x: 94.44, y: 61}, 
                      {x: 97.22, y: 88}, 
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
          var dataLine_burn = [[0, 89], 
                      [2.78, 70], 
                      [5.56, 84], 
                      [8.33, 80], 
                      [11.11, 57], 
                      [13.88, 91], 
                      [16.67, 89], 
                      [19.44, 94], 
                      [22.22, 85], 
                      [25.00, 92], 
                      [27.78, 72], 
                      [30.56, 89], 
                      [33.33, 53], 
                      [36.11, 95], 
                      [38.89, 92], 
                      [41.67, 61], 
                      [44.44, 43], 
                      [47.22, 75], 
                      [50.00, 57], 
                      [52.78, 62], 
                      [55.55, 88], 
                      [58.33, 58], 
                      [61.11, 24], 
                      [63.89, 10], 
                      [66.67, 67], 
                      [69.44, 83], 
                      [72.22, 83], 
                      [75.00, 48], 
                      [77.78, 6], 
                      [80.56, 66], 
                      [83.33, 70], 
                      [86.11, 56], 
                      [88.88, 70], 
                      [91.67, 13], 
                      [94.44, 34], 
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
          makeElementAppear(this.d3.select("#annotate-container"), 4500, 1000);
          makeElementAppear(this.d3.select(".timeline-title"), 4000, 1000);


          this.d3.select(".timeline-title-box")
          .attr("fill","none")
          .attr("width", "0")
          .transition()
            .delay(3000)
            .duration(2000)
            .attr("width", "350")
            .attr("fill", "rgb(245,169,60)");

          var dataStart = data_mean;
          var dataGroup = [
            [1, 'data_burn', "Total area burned by wildfires"],
            [2, 'data_mean', "Largest wildfires"],
            [3, 'dataBox', "Average wildfire area"]];

          //drop down menu to change data
          var dropdown = this.d3.select("#dataDrop")

          var options = dropdown.selectAll('option')
            .data(dataGroup)
            .enter()
            .append('option')
            .attr('value', (d) => d[1])
            .text((d) => d[2]);

          options.property("selected", function(d) {
            return(d[1] === dataStart)
          });

          dropdown.on("change", function(d) {console.log(d)});

          // Add the initial path for area using negative space
          this.d3.select("#crop-shape")
            .append('path')
              .attr("id", "charty")
              .attr('d', makeArea(dataBox))
              .style('fill', 'white')
              .style("opacity", "1");
              
          //morph path to include burn area over time shape
          var firstDraw = this.d3.select("#charty")
            .transition()
              .delay(1000)
              .duration(3000)
              .attr("d", makeArea(dataStart))
          
          dropdown.on("change", )

          //animate line drawing across top
          this.d3.select("#path1")
            .attr('d', line(dataLine_burn))
            .attr("stroke", "none")
            .attr("fill", "none")
            .attr("stroke-dasharray","1000px")
            .attr("stroke-dashoffset","1000px")
            .transition()
              .delay(3000)
              .duration(2000)
              .attr("stroke","rgb(245,169,60)")
              .attr("stroke-linejoin", "miter")
              .attr("stroke-dashoffset","0px")
              .attr("stroke-miterlimit", "10")
              .attr("stroke-width","1px");

          /* dropdown
            .selectAll('myOptions')
              .data(dataGroup)
              .enter()
              .append('option')
              .text((d) => d[2]) // text in the menu
              .attr("value", (d) => d[1]); // value returned */

          makeElementAppear(dropdown, 4000, 1000);

          //function to morph to mean
          function updateChart(myData){
            this.d3.select("#charty")
            .transition()
              .duration(3000)
              .attr("d", makeArea(myData))
          };

          /* //run function when selected
          dropdown.on("change", function(d) {
             // recover the option that has been chosen
              var selectedOption = this.d3.select(data).property("value")
              console.log(selectedOption)

              // run the updateChart function with this selected option
              updateChart(selectedOption)
            }); */
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
        height: 900px;
        background-image: linear-gradient(0deg, $fireYellowlight 40%, $none 95%), url(../../assets/images/fieldphotos/scar_3000w.jpg);
        background-attachment: fixed;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
      @media screen and (max-width: 1000px) {
          height: 950px;
      }
      @media screen and (max-width: 800px) {
          height: 800px;
      }
      @media screen and (max-width: 600px) {
          height: 700px;
      }
      @media screen and (max-width: 400px) {
          height: 650px;
      }
    }

#time-title {
  #dataDrop {
    margin-top: 0px;
    color: black;
    z-index:1;
    display: block;
    width: 280px;;
    font-weight: 600;
  }

  #axes-svg{
    display: block;
    z-index:0;
  }

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
    #axes-svg {
      margin-top: 0px;
      z-index: 1;
    }

    #crop-shape {
      z-index: 0;
    }

    #time-title {
      width: 350px;
      float: left;
      @media screen and (max-width: 350px) {
          width: 100vw;
      }
    }
    #dataDrop {
      width: 280px;
      float: left;
    }
#annotate-container{
  width: 350px;
  float: right;
  @media screen and (max-width: 1000px) {
          margin-top: 100px;

      }
      @media screen and (max-width: 800px) {
          margin-top: -25px;
          width:300px;
      }
      @media screen and (max-width: 600px) {
          margin-top: -70px;
          width:250px;
      }
      @media screen and (max-width: 400px) {
          margin-top: -50px;
          width:200px;
      }
}

</style>