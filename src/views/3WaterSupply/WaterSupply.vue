<template>
  <section id="water-supply-section">
    <div
      class="text-content"
    >
      <div id="water-supply-header">
        <h2><span class="lowlight">Main Point about Fires and Water Supply</span></h2>
      </div>
    </div>
    <div class="flex-container">
      <div class="flex-item">
        <img 
          id="water-supply-before" 
          src="@/assets/components/water-supply/diagrams/beforeFire.png" 
          alt="Diagram showing how water flows before a fire"
        >
        <p class="caption">
          Orci nulla pellentesque dignissim enim sit. Nam venenatis.
        </p>
      </div>
      <div class="flex-item">
        <img 
          id="water-supply-after" 
          src="@/assets/components/water-supply/diagrams/afterFire.png" 
          alt="Diagram showing how water flows after a fire"
        >
        <p class="caption">
          Porttitor nisi porta lorem mollis.
        </p>
      </div>
    </div>
    <div class="text-content">
      <p>Iaculis at erat pellentesque adipiscing. Eget nullam non nisi est sit amet. Porttitor nisi porta lorem mollis. Magnis dis parturient montes nascetur ridiculus. Leo in vitae turpis massa sed elementum tempus egestas. Tortor posuere ac ut consequat semper viverra nam.</p>
      <p>Suspendisse interdum consectetur libero id. Orci nulla pellentesque dignissim enim sit. Nam venenatis. Egestas congue quisque egestas diam in arcu. Proin libero nunc consequat interdum varius sit amet. Cursus eget nunc scelerisque viverra mauris in.</p>
    </div>      
  </section>
</template>

<script>
    export default {
        name: 'WaterSupply'
    }
</script>

<style scoped lang="scss">
    // #main-map {
    //     width: 100%;
    //     height: auto;
    // }


</style>