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
          <!-- <source
            srcset="@/assets/images/fieldphotos/Brian_sampling_ai_800w.webp" 
            media="(max-width: 800px)"
            type="image/jpeg"
          >
          <source
            srcset="@/assets/images/fieldphotos/Brian_sampling_ai_800w.jpg" 
            media="(max-width: 800px)"
            type="image/jpeg"
          > -->
          
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/edited_Brian-Sampling.jpg" 
            alt="USGS Hydrologist Brian Ebel sampling soil within the Fourmile Canyon Fire burn scar"
            loading="lazy"
          >
        </picture>
      </div>
    </slide>



    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source
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
          > -->
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/edited_Sheila-Deb-Brian-Sampling.jpg" 
            alt="USGS Hydrologists Sheila Murphy, Deborah Martin, and Brian Ebel sampling soil within the Fourmile Canyon burn scar"
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
            src="@/assets/images/fieldphotos/edited_Fourmile-Labels.jpg" 
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
          > -->
          <img
            v-img:group-2
            src="@/assets/images/fieldphotos/edited_samples.jpg" 
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
