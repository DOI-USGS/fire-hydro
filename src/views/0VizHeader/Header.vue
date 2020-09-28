<template>
  <div id="header-wrapper">
    <div id="header">
      <h1>{{ title }}</h1>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 100 100"
        preserveAspectRatio="none"
      >
        <polygon
          class="fire-rate-crop"
          fill="white"
          points="97.100 50.000, 94.200 0.000, 94.200 0.000, 94.200 1.900, 94.000 3.000, 93.900 6.100, 93.900 7.800, 93.800 9.500, 93.100 29.000, 93.100 29.000, 92.100 54.600, 92.100 54.600, 91.800 61.100, 91.800 61.400, 91.700 63.400, 91.700 63.600, 91.500 67.200, 91.500 67.500, 91.400 68.000, 91.400 68.700, 91.400 68.700, 91.400 69.200, 91.400 69.200, 91.300 69.600, 91.300 69.600, 91.300 69.900, 91.300 69.900, 91.300 70.100, 91.300 70.100, 91.300 71.000, 91.300 71.000, 88.000 64.300, 85.300 7.800, 81.900 14.900, 78.900 73.400, 76.100 45.600, 73.200 52.700, 70.000 9.000, 66.700 1.500, 63.800 15.300, 60.600 21.400, 57.500 67.500, 54.500 32.900, 51.600 72.700, 48.400 29.700, 45.600 49.300, 42.500 98.100, 39.500 80.500, 36.600 44.400, 33.300 90.900, 30.300 67.300, 26.600 90.900, 23.600 89.500, 21.300 79.200, 18.000 60.300, 14.800 91.700, 12.000 56.400, 8.900 84.700, 5.800 82.200, 2.400 80.000, 0.000 100.000, 100.000 100.000, 100.000 0.000"
        />
      </svg>
    </div>
  </div>
</template>

<script>
    export default {
        name: 'Visualization',
        props: {
            title: {
                type: String,
                default: process.env.VUE_APP_TITLE
            }
        }
    }
</script>

<style lang="scss">

    // Import Colors
    $white: rgba(255,255,255,1);
    $black: rgba(0,0,0,0.8);  
    $lightGray:rgba(237,237,237,1);
    $mediumGray: rgba(100,100,100,1);
    $darkGray: rgba(51,51,51,1);
    $usgsGreen: rgba(51,120,53,1);
    $usgsBlue: rgba(0,38,76,1);
    $fireRed: rgba(163,54,48,0.8);
    $fireYellow: rgba(249,178,68,1);

    #header-wrapper{
        background-image: url('/src/assets/components/header/fire-map.png');
    }
    #header {
        position: relative;
        height: 800px;
        background-image: linear-gradient($black, $fireRed);
    }

    #header h1 {
        padding: 100px 15%;
        text-align: left;
        line-height: 1em;
    }

    svg {
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
</style>