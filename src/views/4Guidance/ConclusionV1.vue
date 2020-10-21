<template>
  <div class="text-content">
    <h2>You know the value of water <span class="lowlight">when the well is dry</span></h2>
    <p>Much of the Western US depends on water from forested watersheds, and it’s not just flooding streams that feel the burn.  Large reservoirs store runoff, and these reservoirs are vulnerable to fire impacts too. The <a href="https://www.usgs.gov/media/images/burned-watersheds-buffalo-creek-alluvial-fan">Buffalo Creek Fire</a> in 1996 and the <a href="https://pubs.usgs.gov/sir/2012/5267/pdf/sir2012-5267.pdf">Hayman Fire</a> in 2002 caused substantial sediment loads into the Strontia Springs reservoir that provides water supply to the city of Denver, Colorado.  Denver Water, who operates the reservoir, incurred <a href="https://pubs.usgs.gov/wri/2001/4122/report.pdf">$26 million in reservoir dredging costs</a> and <a href="https://denver.cbslocal.com/2012/04/23/waterton-canyon-open-once-again-for-recreational-use/">closed the reservoir to recreation for a year and a half</a> to remove sediment and recover storage.</p>
    <div
      id="denver-photos"
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
    <p>Colorado water providers are hardly alone in struggling with the challenges that wildfire brings. The 2007 <a href="https://earthobservatory.nasa.gov/images/event/18845/zaca-wildfire-southern-california">Zaca Fire</a> near Santa Barbara, California burned over 240,000 acres. The US Forest Service estimated that post-fire erosion of sediment would cause <a href="https://www.independent.com/2007/10/11/zaca-fire-may-affect-reservoir-capacity/">over 50% loss of reservoir storage</a> in one of the main water supply reservoirs. Runoff from the burn scar of the Zaca Fire was also <a href="https://www.waterboards.ca.gov/drinking_water/programs/districts/docs/mendocino/05_jdensmore_post_fire_impacts_wq_treatment.pdf">more expensive to treat</a> to reach drinking water standards. <a href="https://www.waterboards.ca.gov/resources/data_databases/docs/Data%20Symposium%20Day%201/10_Anderson_Science%20Symposium.pdf">Water treatment costs for the City of Santa Barbara</a> increased by a factor of 60 after the fire, going from $33,000 per year to $2.1 million per year.</p>
    <div
      id="santa-barbara-photos"
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
            src="@/assets/images/fieldphotos/GibraltarReservoir.jpg" 
            alt="Sediment from the Zaca Fire runoff has filled in much of the reservoir and reduced its water holding capacity."
            loading="lazy"
          >
        </picture>
        <p class="caption">
          Sediment carried by overland flow after the Zaca Fire has filled in and reduced the water holding capacity of reservoirs that provide water to Santa Barbara, CA Credit: Doc Searls, CC
        </p>
      </div>
    </div>
    <p>Water supply watersheds in the West will continue to be under fire in the coming decades. Scientists from the USGS Water Mission Area will be working to deliver timely science to understand how severely and for how long wildfire will impact watersheds.</p>
  </div>
</template>

<script>
    export default {
        name: 'Conclusion'
    }
</script>

<style scoped lang="scss">

</style>