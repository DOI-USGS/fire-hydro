<template>
  <section>
    <div class="text-content">
      <h2><span class="lowlight">Adapting</span> to the complexity of wildfire impacts</h2>
      <p>The rapid conveyance of sediment, ash, and debris to surface water can lead to impaired surface-water quality, loss of reservoir storage, and high costs to water providers and customers. Water supplies in watersheds that have experienced wildfire may face a variety of impacts, such as:</p>
      <ul class="styled-li">
        <li class="styled-li">
          Increased turbidity (sediment) and concentrations of nitrate, phosphorus, dissolved organic carbon, and manganese,
        </li>
        <li class="styled-li">
          Sedimentation, eutrophication, and metal mobilization in reservoirs,
        </li>
        <li class="styled-li">
          Impaired water-treatment efficiency, and/or
        </li>
        <li class="styled-li">
          Stream habitat alteration
        </li>
      </ul>
      <p>
        After the <a
          href="https://www.usgs.gov/media/images/burned-watersheds-buffalo-creek-alluvial-fan"
          target="_blank"
        >Buffalo Creek Fire</a> in 1996 and the <a
          href="https://pubs.usgs.gov/sir/2012/5267/pdf/sir2012-5267.pdf"
          target="_blank"
        >Hayman Fire</a> in 2002, substantial sediment loads were delivered to a downstream reservoir that provides water to millions of people in and near Denver, Colorado. Over <a
          href="https://pubs.usgs.gov/wri/2001/4122/report.pdf"
          target="_blank"
        >$26 million</a> was then spent on dredging the sediment to restore water storage capacity of the reservoir. After the <a
          href="https://earthobservatory.nasa.gov/images/event/18845/zaca-wildfire-southern-california"
          target="_blank"
        >Zaca Fire</a> in 2007, water treatment costs for the City of Santa Barbara, California, <a
          href="https://www.waterboards.ca.gov/drinking_water/programs/districts/docs/mendocino/05_jdensmore_post_fire_impacts_wq_treatment.pdf"
          target="_blank"
        >increased by a factor of 60,</a> from $33,000 to $2.1 million per year.
      </p>
    </div>
    
    <div
      id="example-photos"
      class="flex-container"
    >
      <div class="flex-item">
        <picture>
          <!--          <source
            srcset="@/assets/images/examples/Buffalo-Creek-Fan.jpg 1200w"
            type="image/jpeg"
          > -->
          <img
            v-img:group-4
            src="@/assets/images/examples/Buffalo-Creek-Fan.jpg" 
            alt="An alluvial fan caused by sediment erosion during a post-wildfire rainstorm near Denver, Colorado."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          A rainstorm in July 1996 caused erosion inside the Buffalo Creek wildfire burn scar, which deposited this alluvial fan at the mouth of a tributary to Buffalo Creek.<br>Credit: R.H. Meade, USGS
        </p>
      </div>
      <div class="flex-item">
        <picture>
          <!--       <source
            srcset="@/assets/images/examples/Gibraltar-Reservoir.jpg 1200w"
            type="image/jpeg"
          > -->
          <img
            v-img:group-4
            src="@/assets/images/examples/Gibraltar-Reservoir.jpg" 
            alt="Sediment from the Zaca Fire runoff has filled in much of the reservoir and reduced its water holding capacity."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          Sediment carried by overland flow after the Zaca Fire has filled in and reduced the water holding capacity of reservoirs that provide water to Santa Barbara, CA.<br>Credit: Doc Searls, CC
        </p>
      </div>
    </div>
    <div class="text-content">
      <p>Not every watershed that experiences a wildfire faces the same impacts to water supplies. Many factors affect the potential for post-wildfire flooding and water-quality issues in a watershed, such as: </p>
      <ul class="styled-li">
        <li class="styled-li">
          Slope steepness
        </li>
        <li class="styled-li">
          Local geology and soil type
        </li>
        <li class="styled-li">
          Proportion of watershed burned
        </li>
        <li class="styled-li">
          Burn severity
        </li>
        <li class="styled-li">
          Timing, amount, and intensity of post-fire precipitation
        </li>
        <li class="styled-li">
          Connectivity of burned areas with stream channels and with each other
        </li>
        <li class="styled-li">
          Historical land use
        </li>
      </ul>
      <h3>Adaptation Strategies</h3>
      <p>Water managers do have tools available to mitigate and adapt to the impacts of wildfires within a watershed. Potential adaptation strategies for water-treatment facilities include:</p>
      <ul class="styled-li">
        <li class="styled-li">
          Filling off-channel water-supply reservoirs prior to high-intensity rainfall season
        </li>
        <li class="styled-li">
          Closing intakes when forecasts predict high-intensity rain storms
        </li>
        <li class="styled-li">
          Establishing alternative water supplies
        </li>
        <li class="styled-li">
          Planning and installing pre-sedimentation basins to minimize delivery of eroded ash and sediment to reservoirs
        </li>
        <li class="styled-li">
          Increasing sedimentation capacity
        </li>
        <li class="styled-li">
          Collaborating with land and fire managers to identify and prioritize fuel treatments to reduce the potential for large, severe wildfires
        </li>
        <li class="styled-li">
          Installing real-time monitoring networks that can send alerts of high rainfall intensity, flooding, or high turbidity, which can inform decision making about water infrastructure management during storm events
        </li>
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