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
          <!-- <source srcset="@/assets/intro/images/imageSlider/slider_01.webp"
                      media="(max-width: 992px)"
                      type = "image/webp"  > -->
          <source
            srcset="@/assets/images/fieldphotos/EmersonGulch.png" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            src="@/assets/images/fieldphotos/EmersonGulch.png" 
            alt="A steep hilside burned by wildfire"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source srcset="@/assets/intro/images/imageSlider/slider_01.webp"
                      media="(max-width: 992px)"
                      type = "image/webp"  > -->
          <source
            srcset="@/assets/images/fieldphotos/runoff.png" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            src="@/assets/images/fieldphotos/runoff.png" 
            alt="A steep hilside burned by wildfire"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source srcset="@/assets/intro/images/imageSlider/slider_01.webp"
                      media="(max-width: 992px)"
                      type = "image/webp"  > -->
          <source
            srcset="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila.jpg" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            src="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila.jpg" 
            alt="Sheila, Brian, and Deb in the field"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source srcset="@/assets/intro/images/imageSlider/slider_01.webp"
                      media="(max-width: 992px)"
                      type = "image/webp"  > -->
          <source
            srcset="@/assets/images/fieldphotos/runoff2.jpg" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            src="@/assets/images/fieldphotos/runoff2.jpg" 
            alt="A steep hilside burned by wildfire"
          >
        </picture>
      </div>
    </slide>

    <slide class="slide">
      <div class="slider-image-container">
        <picture>
          <!-- <source srcset="@/assets/intro/images/imageSlider/slider_01.webp"
                      media="(max-width: 992px)"
                      type = "image/webp"  > -->
          <source
            srcset="@/assets/images/fieldphotos/SoilSampleSite2.jpg" 
            media="(max-width: 992px)"
            type="image/jpeg"
          >
          <img
            src="@/assets/images/fieldphotos/SoilSampleSite2.jpg" 
            alt="A steep hilside burned by wildfire"
          >
        </picture>
      </div>
    </slide>
  </carousel>
</template>

<script>
  export default {
      name: 'ImageCarousel'
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
      width: 100%;
    }
  }
</style>
