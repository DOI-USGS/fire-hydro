<template>
  <section>
    <div class="text-content">
      <h2>Guidance for <span class="lowlight">Water Providers</span></h2>
      <p>The rapid conveyance of sediment, ash, and debris to surface water can lead to impaired surface-water quality, loss of reservoir storage, and high costs to water providers and customers. Water supplies in watersheds that have experienced wildfire may face a variety of impacts, such as:</p>
      <ul class="styled-li">
        <li>Increased turbidity (sediment) and concentrations of nitrate, phosphorus, dissolved organic carbon, and manganese,</li>
        <li>Sedimentation, eutrophication, and metal mobilization in reservoirs,</li>
        <li>Impaired water-treatment efficiency,</li>
        <li>Stream habitat alteration, or</li>
        <li>Fish kills</li>
      </ul>
      <p>After the Buffalo Creek Fire in 1996 and the <a href="https://pubs.usgs.gov/sir/2012/5267/pdf/sir2012-5267.pdf">Hayman Fire</a> in 2002, substantial sediment loads were delivered to a downstream reservoir that provides water to millions of people in and near Denver, Colorado. Over <a href="https://pubs.usgs.gov/wri/2001/4122/report.pdf">$26 million</a> was then spent on dredging the sediment to restore water storage capacity of the reservoir. After the Zaca fire in 2007, water treatment costs for the City of Santa Barbara, California, <a href="https://www.waterboards.ca.gov/drinking_water/programs/districts/docs/mendocino/05_jdensmore_post_fire_impacts_wq_treatment.pdf">increased by a factor of 60,</a> from $33,000 to $2.1 million per year.</p>
    </div>
    
    <div
      id="example-photos"
      class="flex-container"
    >
      <div class="flex-item">
        <picture>
          <!-- <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.webp 1200w"
            type="image/webp"
            media="(max-width: 1200px)"
          >
          <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.jpg 1200w"
            type="image/jpeg"
            media="(max-width: 1200px)"
          > -->
          <img
            v-img:group-4
            src="@/assets/images/examples/AlvFan.jpg" 
            alt="An alluvial fan caused by sediment erosion during a post-wildfire rainstorm near Denver, Colorado."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          As a consequence of the Buffalo Creek wildfire, a 100-year rainstorm in July 1996 caused erosion upstream and deposition of this alluvial fan at the mouth of a tributary to Buffalo Creek. Credit: R.H. Meade, USGS
        </p>
      </div>
      <div class="flex-item">
        <picture>
          <!-- <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.webp 1200w"
            type="image/webp"
            media="(max-width: 1200px)"
          >
          <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.jpg 1200w"
            type="image/jpeg"
            media="(max-width: 1200px)"
          > -->
          <img
            v-img:group-4
            src="@/assets/images/fieldphotos/GibraltarReservoir.jpg" 
            alt="Sediment from the Zaca Fire runoff has filled in much of the reservoir and reduced its water holding capacity."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          Sediment from the Zaca Fire runoff has filled in much of the reservoir and reduced its water holding capacity Credit: Doc Searls, CC
        </p>
      </div>
      <div class="flex-item">
        <picture>
          <!-- <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.webp 1200w"
            type="image/webp"
            media="(max-width: 1200px)"
          >
          <source
            srcset="@/assets/components/water-supply/diagrams/beforeFire_1200w.jpg 1200w"
            type="image/jpeg"
            media="(max-width: 1200px)"
          > -->
          <img
            v-img:group-4
            src="@/assets/images/fieldphotos/DebrisStrontiaSprings.jpg" 
            alt="Wildfire debris carrying high levels of manganese filled the Strontia Springs reservoir outside of Denver, CO."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          Wildfire debris carrying high levels of manganese filled the Strontia Springs reservoir outside of Denver, CO. Credit: John Moody, USGS
        </p>
      </div>
    </div>
    <div class="text-content">
      <p>Not every watershed faces the same impacts to water supplies. Many factors affect the potential for post-wildfire flooding and water-quality issues in a watershed, such as: </p>
      <ul class="styled-li">
        <li>Slope steepness</li>
        <li>Local geology and soil type</li>
        <li>Proportion of watershed burned</li>
        <li>Burn severity</li>
        <li>Timing, amount, and intensity of post-fire precipitation</li>
        <li>Connectivity of burned areas with stream channels and with each other</li>
        <li>Historical land use</li>
      </ul>
      <h3>Adaptation Strategies</h3>
      <p>Water managers do have tools available to mitigate and adapt to the impacts of wildfires within a watershed. Potential adaptation strategies for water-treatment facilities include:</p>
      <ul class="styled-li">
        <li>Fill off-channel water-supply reservoirs prior to high-intensity rainfall season</li>
        <li>Close intakes when forecasts suggest high-intensity rain storms</li>
        <li>Establish alternative water supplies</li>
        <li>Pre-sedimentation basins</li>
        <li>Increase sedimentation capacity</li>
        <li>Real-time monitoring networks</li>
      </ul>
    </div>
    
  </section>
</template>

<script>
    export default {
        name: 'Guidance'
    }
</script>

<style scoped lang="scss">

</style>