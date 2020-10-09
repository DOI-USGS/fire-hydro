<template>
  <carousel
    id="image-slider"
    :autoplay="true"
    :autoplay-hover-pause="true"
    :per-page="4"
  >
    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/Soil_sample_site_5_pic4.png" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/Soil_sample_site_5_pic4.png" 
            alt="USGS Soil Sample Site"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/Brian_sampling_ai.jpg" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/Brian_sampling_ai.jpg" 
            alt="USGS Hydrologist Brian Ebel sampling soil"
          >
        </picture>
      </div>
    </slide>



    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/2Aug2011_incipient_runoff.png" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/2Aug2011_incipient_runoff.png" 
            alt="A burned soil sample site"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai.jpg"
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai.jpg" 
            alt="USGS Hydrologists Sheila Murphy, Deb, and Brian Ebel"
          >
        </picture>
      </div>
    </slide>
    
    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/IMG_0620_labels.jpg" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/IMG_0620_labels.jpg" 
            alt="A burned soil sample site"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/DSCN0082.png" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/DSCN0082.png" 
            alt="A burned soil sample site"
          >
        </picture>
      </div>
    </slide>
  </carousel>
</template>

<script>
  import { Carousel, Slide } from 'vue-carousel';

  export default {
      name: 'ImageCarouselField',
      components: {
        Carousel,
        Slide
      }
  }

</script>

<style scoped lang="scss">
  #image-slider {
    *:focus{
      outline: none;
    }
  }
  .slide {
    margin: 0;
    padding: 0;
    select:focus{
      outline: none;
    }
  }
  .slider-image-container {
    padding: 10px;
    display: block;
    margin: auto;
    max-width: 400px;
    img {
      // width: 100%;
    }
  }
</style>
