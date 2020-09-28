<template>
  <section id="main-map-section">
    <div
      class="text-content"
    >
      <div id="main-map-header">
        <h2><span class="lowlight">Main Point about connection between Fires and Hydrology (main map header)</span></h2>
      </div>
      <div>
        <img 
          id="main-map" 
          src="@/assets/components/main-map/main-map.png" 
          alt="Main Map of wildfires in the west, with important forests, water supply areas, and mine waste sites"
        >
        <p class="caption">
          Turpis cursus in hac habitasse platea dictumst. Lorem ipsum dolor sit amet.
        </p>
      </div>
      <div>
        <p>Iaculis at erat pellentesque adipiscing. Eget nullam non nisi est sit amet. Porttitor nisi porta lorem mollis. Magnis dis parturient montes nascetur ridiculus. Leo in vitae turpis massa sed elementum tempus egestas. Tortor posuere ac ut consequat semper viverra nam.</p>
        <p>Suspendisse interdum consectetur libero id. Orci nulla pellentesque dignissim enim sit. Nam venenatis. Egestas congue quisque egestas diam in arcu. Proin libero nunc consequat interdum varius sit amet. Cursus eget nunc scelerisque viverra mauris in.</p>
      </div>      
    </div>
  </section>
</template>

<script>
    export default {
        name: 'MainMap'
    }
</script>

<style scoped lang="scss">
    #main-map {
        width: 100%;
        height: auto;
    }
</style>