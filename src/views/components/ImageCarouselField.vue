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
            srcset="@/assets/images/fieldphotos/Soil_sample_site_5_pic4_800w.jpg 800w,
            @/assets/images/fieldphotos/Soil_sample_site_5_pic4_400w.jpg 400w" 
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/Soil_sample_site_5_pic4_2200w.jpg" 
            media="(min-width: 801px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/Soil_sample_site_5_pic4_2200w.jpg" 
            alt="USGS Soil Sample Site"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/Brian_sampling_ai_800w.webp" 
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/Brian_sampling_ai_800w.jpg" 
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/Brian_sampling_ai_2500w.jpg" 
            alt="USGS Hydrologist Brian Ebel sampling soil"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>



    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/2Aug2011_incipient_runoff_400w.webp 400w" 
            media="(max-width: 992px)"
            type="image/webp"
          >
          <source
            srcset="@/assets/images/fieldphotos/2Aug2011_incipient_runoff_2200w.webp 2200w" 
            media="(min-width: 993px)"
            type="image/webp"
          >
          <source
            srcset="@/assets/images/fieldphotos/2Aug2011_incipient_runoff_400w.jpg 400w" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/2Aug2011_incipient_runoff_2200w.jpg 2200w" 
            media="(min-width: 993px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/2Aug2011_incipient_runoff_2200w.jpg" 
            alt="A burned soil sample site"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai_400.webp 400w"
            media="(max-width: 992px)"
            type="image/webp"
          >
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai_800.webp 800w"
            media="(max-width: 800px)"
            type="image/webp"
          >
          
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai_400.jpg 400w"
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai_800.jpg 800w"
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila_ai_2200.jpg" 
            alt="USGS Hydrologists Sheila Murphy, Deb, and Brian Ebel"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>
    
    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/IMG_0620_labels_800w.jpg 800w" 
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/IMG_0620_labels_2200w.jpg" 
            media="(min-width: 801px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/IMG_0620_labels_2200w.jpg" 
            alt="A burned soil sample site"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/fieldphotos/DSCN0082_400w.jpg 400w,
            @/assets/images/fieldphotos/DSCN0082_800w.jpg 800w" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/DSCN0082_2200w.jpg" 
            media="(min-width: 993px)"
            type="image/jpeg"
          >
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/DSCN0082_2200w.jpg" 
            alt="A burned soil sample site"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source
            srcset="@/assets/images/fieldphotos/DSCN0082_400w.jpg 400w,
            @/assets/images/fieldphotos/DSCN0082_800w.jpg 800w" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/DSCN0082_2200w.jpg" 
            media="(min-width: 993px)"
            type="image/jpeg"
          > -->
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/Sheila-Sampling.jpg"
            alt="Sheila Murphy sampling runoff"
            loading="lazy"
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
