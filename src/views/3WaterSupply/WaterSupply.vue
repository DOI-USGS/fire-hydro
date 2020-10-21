<template>
  <section id="water-supply-section">
    <div
      class="text-content"
    >
      <div id="water-supply-header">
        <h2>How wildfires <span class="lowlight">change watersheds</span></h2>
        <p>trees and other plants use the water to grow and reproduce. Leaves and branches, as well as leaf litter on the forest floor, intercept water before it reaches the ground and protect the soil from erosion. When water reaches soil, it is soaked up then slowly released to streams, which helps recharge groundwater aquifers and reduces reduce risks of rapid flooding. As the water moves through soil and rock, sediment and other chemicals are filtered out. Water flowing from forested watersheds often needs only minimal treatment before drinking.</p>
      </div>
    </div>
    <div
      id="diagrams"
      class="flex-container"
    >
      <div class="flex-item">
        <picture>
          <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.webp 1200w"
            type="image/webp"
            media="(max-width: 1200px)"
          >
          <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.jpg 1200w"
            type="image/jpeg"
            media="(max-width: 1200px)"
          >
          <img 
            id="water-supply-before"
            v-img:group-3 
            src="@/assets/components/water-supply/diagrams/beforeFire.jpg" 
            alt="Diagram showing how water flows before a fire"
            loading="lazy"
          >
        </picture>
        <p class="caption">
          A forested watershed's ability to absorb and filter precipitation is key to providing enough clean water to residents reliant on this water source.
        </p>
      </div>
      <div class="flex-item">
        <picture>
          <source
            srcset="@/assets/components/water-supply/diagrams/afterFire_1200w.webp 1200w"
            type="image/webp"
            media="(max-width: 1200px)"
          >
          <source
            srcset="@/assets/components/water-supply/diagrams/afterFire_1200w.jpg 1200w"
            type="image/jpeg"
            media="(max-width: 1200px)"
          >
          <img 
            id="water-supply-after"
            v-img:group-3 
            src="@/assets/components/water-supply/diagrams/afterFire.jpg" 
            alt="Diagram showing how water flows after a fire"
            loading="lazy"
          >
        </picture>
        <p class="caption">
          But after a fire, the ground cover, soil properties, and water flow patterns are all different.
        </p>
      </div>
    </div>
    <div class="text-content">
      <p><a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2016WR019110">Wildfires short-circuit these sponge and filter functions.</a>  A wildfire burns up the vegetation and leaf litter on the forest floor, causing more rainfall to directly fall on the soil surface when the rains arrive.  Heat from the wildfire redistributes organic substances in vegetation and soil, making the soil hydrophobic (“water-hating”). Impacts from soil heating also make the soil less porous and less able to soak up rainfall. Thus, after a wildfire burns through a landscape, much of the rainfall does not soak into the soil, but instead moves over the surface rapidly as “overland flow.”</p>
     <p>This rapidly moving water can pick up and <a href="https://iopscience.iop.org/article/10.1088/1748-9326/10/8/084007">carry the wildfire ash and sediment into streams.</a> Heavy rains can even lead to destructive <a href="https://landslides.usgs.gov/hazards/postfire_debrisflow/">debris flows.</a> Formerly clean, clear streams become clogged with ash, sediment, and burned materials. In forests that have been impacted by other disturbances, such as air pollution or mining, nutrient and <a href="https://www.sciencedirect.com/science/article/pii/S0048969720341577?via%3Dihub">metal concentrations</a> can also increase as the overland flow mobilizes more material. These watershed changes pose challenges water managers, who then must use additional treatments and incur extra costs before this water can be used for municipal water supply.</p>
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