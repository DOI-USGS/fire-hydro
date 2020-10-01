<template>
  <div id="visualization">
    <Header />
    <Intro />
    <MainMap />
    <WaterSupply />
    <ImageCarousel />
    <Resources />
  </div>
</template>

<script>

    export default {
        name: 'Visualization',
        components: {
            Header: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "header"*/ "./0VizHeader/Header"),
            Intro: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "intro"*/ "./1Intro/Intro"),
            MainMap: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "mainmap"*/ "./2MainMap/MainMap"),
            ImageCarousel: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "imagecarousel"*/ "./components/ImageCarousel"),
            WaterSupply: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "watersupply"*/ "./3WaterSupply/WaterSupply"),
            Resources: () => import(/* webpackPrefetch: true */ /*webpackChunkName: "resources"*/ "./Resources/Resources")
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
    font-weight: 900;
    margin: 0;
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
      background: linear-gradient(180deg,rgba(255,255,255,0) 70%, $fireYellowlight 30%);
      line-height: 1.3em;
    }

 

  .caption {
    font-style: italic;
    font-size: .8em;
    padding: 0 2em 0 2em;
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
  }

  .flex-item {
    flex: 1;
    align-self: center;
    text-align: center;
  }

  .flex-item img {
    padding: 20px;
    max-width: 750px;
  }

  @media (max-width: 600px) {
    .flex-container {
      flex-direction: column;
    }
    .flex-item {
      flex: none;
      padding: 0 0 1em 0;
    }
  }

</style>