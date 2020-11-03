<template>
  <div id="visualization">
    <Header />
    <!-- <Intro /> -->
    <MainMap />
    <WaterSupply />
    <Guidance />
    <USGS />
    <Resources />
  </div>
</template>

<script>

    export default {
        name: 'Visualization',
        components: {
            Header: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "header"*/ "./0VizHeader/Header"),
            // Intro: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "intro"*/ "./1Intro/Intro"),
            MainMap: () => import(/*webpackChunkName: "mainmap"*/ "./2MainMap/MainMap"),
            WaterSupply: () => import(/*webpackChunkName: "watersupply"*/ "./3WaterSupply/WaterSupply"),
            Guidance: () => import( /*webpackChunkName: "guidance"*/ "./4Guidance/Guidance"),
            USGS: () => import(/*webpackChunkName: "USGS"*/ "./5USGS/USGS"),
            Resources: () => import(/*webpackChunkName: "resources"*/ "./Resources/Resources")
        }
    }
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


  //Import Type
  @import url("https://use.typekit.net/jja8kth.css");
  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans&display=swap');



  // General Typographic Styling
  body {
      margin: 0;
      padding: 0;
      color: $black;
      background-color: $white;
      line-height: 1.5;
      font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif;
      font-weight: 400;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      width: 100%;
  }
  h1{
    color: white;
    font-size: 6em;
    margin: 0;
    padding: 200px 0 50px 0;
    text-align: left;
    line-height: 1em;
    @media screen and (max-width: 1000px) {
        font-size: 5em;
        padding: 180px 0 50px 0;
    }
    @media screen and (max-width: 800px) {
        font-size: 5.5em;
        padding: 170px 0 50px 0;
    }
    @media screen and (max-width: 600px) {
        font-size: 4em;
        padding: 160px 0 50px 0;
    }
    @media screen and (max-width: 400px) {
        font-size: 3em;
        padding: 140px 0 50px 0;
    }
  }
  h2{
    font-size: 2em;
    margin-top: 80px;
    font-weight: bold;

  }
  h3{
      font-size: 1.4em;
      padding-top: .5em;
      font-weight: 700;
      @media screen and (max-width: 600px) {
        font-size: .8em;
    }
  }
  .lowlight {
      background: linear-gradient(180deg,rgba(255,255,255,0) 60%, $fireYellowlight 40%);
      line-height: 1.3em;
      padding: 0 5px;
    }

 

  .caption {
    // font-style: italic;
    font-size: .8em;
    padding: 1em 4em 0 4em; 
    margin: auto;
    text-align: left;
    max-width: 700px;
  }

  .bold-caption {
    margin-bottom: 1em;
    font-style: bold;
  }

  .button-header {
    padding: 10px 0 0 0;
    margin: 0;
  }

  .button-subheader {
    font-style: italic;
    color: white;
    font-size: .8em;
  }
  a button{ 
    margin: 20px;
  }

  .chart-title-container {
    background-color: $fireYellow;
    padding: .5em 1em;
    min-width: 350px;
    max-width: 700px;
    margin: auto;
    position: relative;
    p{
      padding: 0;
      margin: 0;
    }
    .chart-title{
      font-size: 1.1em;
      font-weight: bold;
    }
  }

  // Medium screens and up
  @media screen and (min-width: 601px){
    #app{
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
  }





  // General Layout  

  .text-content {
    min-width: 350px;
    max-width: 700px;
    margin: 0 auto;
    padding: 0 2em 0 2em;     
  }

  .flex-container {
    display: flex;
    justify-content: space-evenly;
    align-content: space-around;
    max-width: 100%;
    margin: auto;
  }

  .flex-item {
    flex: 1;
    align-self: center;
    text-align: center;
    max-width: 90%;
  }

  .flex-item img {
    padding: 20px;
  }

  @media (max-width: 600px) {
    .flex-container {
      flex-direction: column;
    }
    .flex-item {
      flex: none;
      padding: 0 0 1em 0;
      height: 100%;
    }
  }


  // List Item Styling
  ul .styled-li {
    list-style: none; /* Remove default bullets */
    list-style-type: none;
  }

  li {
    margin: 10px 0;
  }

  .styled-li li::before {
    // content: "🔥";
    content: "■";  /* Add content: \2022 is the CSS Code/unicode for a bullet */
    color: $fireRed; /* Change the color */
    font-weight: bold; /* If you want it to be bold */
    display: inline-block; /* Needed to add space between the bullet and the text */
    width: 1.5em; /* Also needed for space (tweak if needed) */
    margin-left: -1em; /* Also needed for space (tweak if needed) */
  }


 // Link Styling
  /* unvisited link */
  a{
    color: $fireRed;
    text-decoration-color: $fireYellow;
  }

  a:link {
    color: $fireRed;
    text-decoration-color: $fireYellow;
  }

  /* visited link */
  a:visited {
    color: $fireRedlight;
    text-decoration-color: $fireYellow;
  }

  /* mouse over link */
  a:hover {
    cursor: pointer;
    text-decoration-color: $fireYellow;
    text-decoration-thickness: 1px;
    text-underline-offset: 3px;
    text-decoration-style: wavy;
  }

  /* selected link */
  a:active {
    font-style: bold;
    color: black;
    text-decoration-color: $fireYellow;
    text-decoration-thickness: 2px;
    text-underline-offset: 3px;
    text-decoration-style: wavy;
  }
</style>