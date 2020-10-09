<template>
  <carousel
    id="image-slider"
    :autoplay="true"
    :autoplay-hover-pause="true"
    :per-page="3"
  >
    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/NASAEO/boulder_ali_2011158_swir_lrg.jpg"
            type="image/jpeg"
          >
          <img
            v-img:group-1
            src="@/assets/images/NASAEO/boulder_ali_2011158_swir_lrg.jpg" 
            alt="NASA false-color Aerial photography of the Fourmile burn scar"
            title="NASA false-color Aerial photography of the Fourmile burn scar"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/NASAEO/boulder_ali_2011158_lrg_ai.jpg"
            type="image/jpeg"
          >
          <img
            v-img:group-1
            src="@/assets/images/NASAEO/boulder_ali_2011158_lrg_ai.jpg" 
            alt="NASA Aerial photography of the Fourmile burn scar"
            title="NASA Aerial photography of the Fourmile burn scar"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <source
            srcset="@/assets/images/NASAEO/fourmile_tmo_2010249_lrg_ai.jpg" 
            type="image/jpeg"
          >
          <img
            v-img:group-1
            src="@/assets/images/NASAEO/fourmile_tmo_2010249_lrg_ai.jpg" 
            alt="NASA Aerial photography of the Fourmile fire's smoke plume"
            title="NASA Aerial photography of the Fourmile fire's smoke plume"
          >
        </picture>
      </div>
    </slide>
  </carousel>
</template>

<script>
  import { Carousel, Slide } from 'vue-carousel';

  export default {
      name: 'ImageCarouselFourmile',
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
