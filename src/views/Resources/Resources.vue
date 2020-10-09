<template>
  <div
    id="resources-section"
    class="text-content"
  >
    <h2><a /><span class="lowlight">Guidance for Water Providers</span></h2>
    <p>The rapid transmission of sediment, ash, and debris to surface water can lead to impaired surface-water quality, loss of reservoir storage, and high costs to water providers and customers.  But not every watershed faces the same issues.  The guidance below was developed by research hydrologists like Murphy and Ebel to provide actionable guidance for water managers dealing with wildfires within their watersheds.</p>
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
    <h2><span class="lowlight">Further Research</span></h2>
    <ul>
      <li class="research">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Holloway, J.M., and Writer, J.W., 2020, <a href="https://doi.org/10.1016/j.scitotenv.2020.140635">Wildfire-driven changes in hydrology mobilize arsenic and metals from legacy mine waste</a>: Science of the Total Environment v. 743, 140635
      </li>
      <li class="research">
        Hermes, A.L., Ebel, B.A., Murphy, S.F., Hinckley, E-L. S, 2021, <a href="https://doi.org/10.1016/j.scitotenv.2020.142179">Fates and fingerprints of sulfur and carbon following wildfire in economically important croplands of California, U.S.</a>: Science of the Total Environment, 750, 142179
      </li>
      <li class="research">
        Penn, C.A., Clow, D.W., Sexstone, G.A., and Murphy, S.F., 2020, <a href="https://doi.org/10.1111/1752-1688.12863">Changes in climate and land cover affect seasonal streamflow forecasts in the Rio Grande Headwaters</a>: Journal of the American Water Resources Association, 1-21.
      </li>
      <li class="research">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Writer, J.H., and Ebel, B.A., 2018, <a href="https://doi.org/10.1029/2017JG004349">Fire, flood, and drought—Extreme climate events alter flow paths and stream chemistry</a>, Journal of Geophysical Research: Biogeosciences, 123, p. 2513-2526
      </li>
      <li class="research">
        Murphy, S.F., Writer, J.H., McCleskey, R.B., and Martin, D.A., 2015, <a href="https://doi.org/10.1088/1748-9326/10/8/084007">The role of precipitation type, intensity, and spatial distribution in source water quality after wildfire</a>: Environmental Research Letters, v. 10, no. 8, 084007: 1-13
      </li>
      <li class="research">
        Writer, J.H. and Murphy, S.F., 2012, <a href="https://pubs.usgs.gov/fs/2012/3095/FS12-3095.pdf">Wildfire effects on source-water quality—Lessons from Fourmile Canyon Fire, Colorado, and implications for drinking-water treatment</a>: USGS Fact Sheet 2012–3095, 4 p.
      </li>
    </ul>
    <h2><span class="lowlight">USGS Data Releases</span></h2>
    <ul>
      <li class="research">
        Murphy, S.F., McCleskey, R.B., D.A., Holloway, J.M., Writer, J.W., Martin, D.A., and Stricker, C.A., 2020, <a href="https://doi.org/10.5066/P941BIYS">Chemistry of water, stream sediment, wildfire ash, soil, dust, and mine waste for Fourmile Creek Watershed, Colorado, 2010-2019</a>: U.S. Geological Survey Data Release (IP-118730, 6/22/20).
      </li>
      <li class="research">
        Murphy, S. F., McCleskey, R. B., and Writer, J. H., 2018, <a href="https://doi.org/10.5066/F7Z60N8T">Water chemistry data for Fourmile Creek Watershed, 2010-2015.</a> U.S. Geological Survey database
      </li>
      <li class="research">
        McCleskey, R.B., Writer, J.H., and Murphy, S.F., 2012, <a href="https://pubs.usgs.gov/of/2012/1104/OF12-1104.pdf">Water chemistry of surface waters affected by the Fourmile Canyon wildfire, Colorado, 2010–2011</a>: USGS Open-File Report 2012–1104, 11 p.
      </li>
    </ul>
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

// ul li:before {
//   content: "🔥";
//   font-size: 10pt;
// }

ul {
  list-style: none; /* Remove default bullets */
}

ul li::before {
  // content: "🔥";
  content: "■";  /* Add content: \2022 is the CSS Code/unicode for a bullet */
  color: $fireRed; /* Change the color */
  font-weight: bold; /* If you want it to be bold */
  display: inline-block; /* Needed to add space between the bullet and the text */
  width: 1.5em; /* Also needed for space (tweak if needed) */
  margin-left: -1em; /* Also needed for space (tweak if needed) */
}

.research {
  margin: 20px 0;
}
</style>
