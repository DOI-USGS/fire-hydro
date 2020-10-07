<template>
  <div
    id="resources-section"
    class="text-content"
  >
    <h2><a /><span class="lowlight">Guidance for Water Providers</span></h2>
    <p>The rapid transmission of sediment, ash, and debris to surface water can lead to impaired surface-water quality, loss of reservoir storage, and high costs to water providers and customers.  But not every watershed faces the same issues.</p>
    <div class="usa-accordion usa-accordion--bordered">
      <div class="accordion">
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Impact Factors
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Many factors affect the potential for post-wildfire flooding and water-quality issues in a watershed, such as:</p>
          <ul>
            <li>Slope steepness</li>
            <li>Local geology and soil type</li>
            <li>Proportion of watershed burned</li>
            <li>Burn severity</li>
            <li>Timing, amount, and intensity of post-fire precipitation</li>
            <li>Connectivity of burned areas with stream channels and with each other</li>
            <li>Historical land use</li>
          </ul>
        </div>
      </div>
      <div class="accordion">
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Impacts on Water
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Water supplies in watersheds that have experienced a fire face a variety of impacts, such as: </p>
          <ul>
            <li>Increased turbidity (sediment) and concentrations of nitrate, phosphorus, dissolved organic carbon, and manganese</li>
            <li>Sedimentation, eutrophication, and metal mobilization in reservoirs</li>
            <li>Impaired water-treatment efficiency</li>
            <li>Stream habitat alteration, fish kills</li>
          </ul>
        </div>
      </div>
      <div class="accordion">
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Adaptation Strategies
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Potential adaptation strategies for water-treatment facilities include:</p>
          <ul>
            <li>Fill off-channel water-supply reservoirs prior to high-intensity rainfall season</li>
            <li>Close intakes when forecasts suggest high-intensity rain storms</li>
            <li>Establish alternative water supplies</li>
            <li>Pre-sedimentation basins</li>
            <li>Increase sedimentation capacity</li>
            <li>Real-time monitoring networks</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        name: 'Resources',
        //  mounted() {
        //     // This is a fix for the weird USWDS glitch that causes the Methods section accordion menus to be open on page load
        //     const targetAccordionDivs = document.querySelectorAll('div.target');
        //     targetAccordionDivs.forEach((div) => {
        //         div.setAttribute('hidden', '""');
        //     });
        // }
    }
</script>

<style lang="scss" scoped>
$chevronLeft: '~@/assets/images/chevron-left.png';
$chevronDown: '~@/assets/images/chevron-down.png';

// Import Colors
  $white: rgb(255,255,255);
  $black: rgb(0,0,0);  
  $lightGray:rgb(237,237,237);
  $mediumGray: rgb(100,100,100);
  $darkGray: rgb(51,51,51);
  $usgsGreen: rgb(51,120,53);
  $usgsBlue: rgb(0,38,76);
  $fireRed: rgb(250,109,49);
  $fireRedlight: rgba(250,109,49,0.5);
  $fireYellow: rgb(245,169,60);
  $fireYellowlight: rgba(245,169,60,0.5);


  h2{
    margin-bottom: 10px;
  }
  button:not([disabled]):focus{
    outline: none;
  }
  .usa-accordion__button{
    // background-image: url($chevronDown);
    background-size: 15px 10px;
    background-color: $fireYellow;
    color: $darkGray;
  }
  .usa-accordion__button[aria-expanded=false]{
    // background-image: url($chevronLeft);
    background-size: 10px 15px;
    background-color: $darkGray;
    color: $fireYellow;
  }

.accordion {
  margin: 2em 0;
}
#app h2.usa-accordion__heading {
  margin: 0;
}

#resources-section {
  margin-bottom: 100px;
}
</style>
