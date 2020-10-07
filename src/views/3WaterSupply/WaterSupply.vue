<template>
  <section id="water-supply-section">
    <div
      class="text-content"
    >
      <div id="water-supply-header">
        <h2>How wildfires <span class="lowlight">change watersheds</span></h2>
        <p>Forests, to a hydrologist’s eye, are both a sponge and a filter.  Rainfall drains easily into forest soils, where it can be soaked up and slowly released over time into stream.  This ability to absorb and hold on to water helps reduce and delay risks of flooding.  It also helps recharge groundwater aquifers.</p>
        <p>As the water moves through soil and rock, it is filtered.  Water flowing from forested watersheds often need only minimal treatment before drinking.  These “ecosystem pre-treatments” are provided for free by the forests, and when they’re changed, water managers have to take up the slack.</p>
      </div>
    </div>
    <div
      id="diagrams"
      class="flex-container"
    >
      <div class="flex-item">
        <img 
          id="water-supply-before" 
          src="@/assets/components/water-supply/diagrams/beforeFire.jpg" 
          alt="Diagram showing how water flows before a fire"
        >
        <p class="caption">
          Watershed before fire
        </p>
      </div>
      <div class="flex-item">
        <img 
          id="water-supply-after" 
          src="@/assets/components/water-supply/diagrams/afterFire.jpg" 
          alt="Diagram showing how water flows after a fire"
        >
        <p class="caption">
          Watershed after fire
        </p>
      </div>
    </div>
    <div class="text-content">
      <p>Wildfires short-circuits these sponge and filter functions.  The combustion of vegetation and leaf litter on the forest floor leads to more rainfall reaching the ground. Heat from the wildfire mobilizes wax-like substances in tree sap, and deposits it on the soil making the ground hydrophobic (“water-hating”). The heat from the fire bakes organic materials in the soil, making the soil less porous.</p>
      <p>When it rains, much of the rainfall does not soak into the soil, but instead moves over the surface rapidly, picking up and transporting fire debris into streams. Formerly clean, clear streams become clogged with ash, sediment, burned materials, excess nutrients, and metals.  That’s bad news for water managers who rely on this water, who then have big treatment challenges ahead before this water can be used for municipal water supply.</p>
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