<template>
  <section id="intro">
    <div
      id="intro-text-content"
      class="text-content"
    >
      <h2>Ten years ago this fall, the <span class="lowlight">Fourmile Canyon Fire</span> burned through Colorado.</h2>
      <p>The forest west of Boulder was dry. Meager August rainstorms in 2010 had delivered only 25-50% of the typical rainfall. When the Fourmile Canyon Fire started on September 6th, Labor Day, it spread rapidly because of low humidity and high winds.  Over 160 homes and 5,700 acres of forest were burned in only two days.</p>
    </div> 
    <ImageCarouselFourmile />
    <div class="text-content">
      <!-- <LightboxFourmile /> -->
      <p>After the fire was put out, the perils from the fire were not over. Summer thunderstorms in 2011 and 2012 delivered flash floods and choked the streams with ash, sediments, metals, and excess nutrients from runoff. Usually, afternoon thunderstorms in Colorado are a blessing, bringing cool the mountain air and welcome rains to recharge water supplies.  But the landscape of the watershed was so changed after the Fourmile Canyon fire that local water providers were concerned about water supplies to nearby cities.</p>      
      <p>Scientists from the U.S. Geological Survey’s Water Mission Area responded to the fires right away.  Researchers – like Hydrologist Sheila Murphy – were on the ground taking water samples, measuring stream response, and tracking water quality changes.</p>
      <!-- <LightboxField /> -->
    </div>
    <ImageCarouselField />
    <div class="text-content">
      <p>Studies of the Fourmile Canyon Fire’s impact on the watershed over the last ten years have advanced scientific understanding of post-wildfire water quality problems. Their studies showed that layers of ash from the fire prevented water from heavy summer thunderstorms from absorbing into the ground, and instead flowed played a large role in impairing of drinking water (Murphy et al., 2015). Murphy, working with other WMA scientists, documented the recovery of the watershed for 5 years after the fire to deliver actionable guidance to water providers for post-wildfire water availability (Murphy et al., 2018).</p>
      <a href="#resources-section"><button class="usa-accordion__button"><h3>Read the Guidance</h3></button></a>
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