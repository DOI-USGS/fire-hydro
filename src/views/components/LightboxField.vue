<template>
  <div>
    <div
      id="lightbox-field"
      class="flex-container"
    >
      <img
        v-img:group-2
        src="@/assets/images/fieldphotos/ColdSprings_BrianDebSheila.jpg" 
        alt="USGS Hydrologists Sheila Murphy, Deb, and Brian Ebel"
      >
      <img 
        v-img:group-2
        src="@/assets/images/fieldphotos/Soil_sample_site_5_pic4.png" 
        alt="USGS Soil Sample Site"
      >
      <img
        v-img:group-2
        src="@/assets/images/fieldphotos/Brian_sampling.png" 
        alt="USGS Hydrologist Brian Ebel sampling soil"
      >
      <img
        v-img:group-2
        src="@/assets/images/fieldphotos/IMG_0620_labels.jpg" 
        alt="A burned soil sample site"
      >
      <img
        v-img:group-2
        src="@/assets/images/fieldphotos/2Aug2011_incipient_runoff.png" 
        alt="A burned soil sample site"
      >
      <img
        v-img:group-2
        src="@/assets/images/fieldphotos/DSCN0082.png" 
        alt="A burned soil sample site"
      >
    </div>       
  </div>
</template>

<script>    

    export default {
        name: 'LightboxField',
    };

        

</script>

<style lang="scss" scoped>
    img{
        padding: 10px;
        height: 400px;
        width: auto;
        @media screen and (max-width: 600px) {
            padding: 10px 0;
            width: auto;
            height: 100%;
        }
    }
    #lightbox-field{
        margin: 5em 0;
    }
</style>>
