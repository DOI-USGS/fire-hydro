<template>
  <section id="intro">
    <div
      id="intro-text-content"
      class="text-content"
    >
      <h2>Ten years ago, the <span class="lowlight">Fourmile Canyon Fire</span> burned through the forest near Boulder, Colorado.</h2>
      <p>The forest west of Boulder was dry. Meager August rainstorms in 2010 had delivered only 25-50% of the typical rainfall. When the Fourmile Canyon Fire started on September 6th, Labor Day, it spread rapidly because of low humidity and high winds.  Over 160 homes and 5,700 acres of forest were burned in only four days.</p>
    </div> 
    <ImageCarouselFourmile />
    <div class="text-content">
      <!-- <LightboxFourmile /> -->
      <p>Scientists from the U.S. Geological Survey (USGS) responded to the fires right away. The USGS <a href="https://www.usgs.gov/centers/co-water">Colorado Water Science Center</a> installed two stream gages downstream of the burned area to serve as part of a flood warning system. A Researchers like hydrologists <a href="https://www.usgs.gov/staff-profiles/sheila-murphy?qt-staff_profile_science_products=0#qt-staff_profile_science_products">Sheila Murphy,</a> <a href="https://www.usgs.gov/staff-profiles/brian-a-ebel?qt-staff_profile_science_products=0#">Brian Ebel,</a> and lots of others – were on the ground immediately. They began work in the burn scar, taking water samples, measuring stream and precipitation patterns, and tracking water quality changes.  </p>
      <p>Usually, afternoon thunderstorms in Colorado are a blessing, bringing cool air and welcome rains to replenish water supplies.  But after the Fourmile Canyon fire, the landscape of the watershed was transformed  and local water providers were concerned.  Post-wildfire landscapes mean massive loads of sediment and pollutants entering the water supply, which would be very difficult and expensive to treat. When the summer rains arrived in a July 13th storm, the <a href="https://co.water.usgs.gov/webcams/fourmile/video/20110713/index.html">USGS gage at Fourmile Creek</a> captured a timelapse of rapid flooding, and the creek’s discharge skyrocketed sending a 4-foot surge down the creek.  Summer thunderstorms in 2011 and 2012 delivered flash floods and choked the streams with ash and sediment, which played a large role in <a href="https://iopscience.iop.org/article/10.1088/1748-9326/10/8/084007">impairing drinking water.</a></p>      
      <!-- <LightboxField /> -->
    </div>
    <ImageCarouselField />
    <div class="text-content">
      <p>Studies of the <a href="https://pubs.usgs.gov/fs/2012/3095/FS12-3095.pdf">Fourmile Canyon Fire’s impact on the watershed</a> over the last ten years have advanced scientific understanding of post-wildfire water quality problems. These studies show that changes in forest soils after wildfires have long term impacts on water quality and water supply. Following the fire, Murphy and other USGS scientists continued to <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2017JG004349">document the recovery of the watershed</a> providing actionable guidance to water providers for post-wildfire water availability.</p>
      <a href="#resources-section"><button class="usa-accordion__button"><h3 class="button-header">Read the Guidance</h3><p class="button-subheader">Tips for Water Managers</p></button></a>
    </div>
  </section>
</template>

<script> 
    import { LightGallery } from 'vue-light-gallery';
    // import LightboxFourmile from "../components/LightboxFourmile"
    // import LightboxField from "../components/LightboxField"
    import ImageCarouselFourmile from "../components/ImageCarouselFourmile"
    import ImageCarouselField from "../components/ImageCarouselField"
  
    export default {
        name: 'Intro',
        components: {
          // LightboxFourmile,
          // LightboxField,
          ImageCarouselFourmile,
          ImageCarouselField
        }
    }
</script>

<style scoped lang="scss">

//Import Colors 
  $fireYellow: rgb(245,169,60);
  $fireYellowlight: rgba(245,169,60,0.5);
  $darkGray: rgb(51,51,51);

    .usa-accordion__button{
      // background-image: url($chevronDown);
      background-size: 15px 10px;
      background-color: $fireYellow;
      color: $darkGray;
      text-align: center;  
    }
</style>