<template>
  <div
    id="resources-section"
    class="text-content"
  >
    <h2><span class="lowlight">Further Research</span></h2>
    <p>For more information about USGS work on wildfires and water supplies, visit <a href="https://www.usgs.gov/special-topic/fire">Wildland Fire Science</a>, the <a href="https://ca.water.usgs.gov/wildfires/wildfires-water-quality.html">California Water Science Center,</a> or any of the USGS peer-reviewed research on wildfires, some of which is listed below.</p>
    <ul class="styled-li">
      <li class="research-li">
        Hermes, A.L., Ebel, B.A., Murphy, S.F., Hinckley, E-L. S, 2021, <a href="https://doi.org/10.1016/j.scitotenv.2020.142179">Fates and fingerprints of sulfur and carbon following wildfire in economically important croplands of California, U.S.</a>: Science of the Total Environment, 750, 142179
      </li>
      <li class="research-li">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Holloway, J.M., and Writer, J.W., 2020, <a href="https://doi.org/10.1016/j.scitotenv.2020.140635">Wildfire-driven changes in hydrology mobilize arsenic and metals from legacy mine waste</a>: Science of the Total Environment v. 743, 140635
      </li>
      <li class="research-li">
        Penn, C.A., Clow, D.W., Sexstone, G.A., and Murphy, S.F., 2020, <a href="https://doi.org/10.1111/1752-1688.12863">Changes in climate and land cover affect seasonal streamflow forecasts in the Rio Grande Headwaters</a>: Journal of the American Water Resources Association, 1-21.
      </li>
      <li class="research-li">
        Ebel, B. A., 2020. <a href="https://www.sciencedirect.com/science/article/abs/pii/S0022169420302250?via%3Dihub">Temporal evolution of measured and simulated infiltration following wildfire in the Colorado Front Range, USA: Shifting thresholds of runoff generation and hydrologic hazards.</a> Journal of Hydrology, 124765.
      </li>
      <li class="research-li">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Writer, J.H., and Ebel, B.A., 2018, <a href="https://doi.org/10.1029/2017JG004349">Fire, flood, and drought—Extreme climate events alter flow paths and stream chemistry</a>, Journal of Geophysical Research: Biogeosciences, 123, p. 2513-2526
      </li>
      <li class="research-li">
        Ebel, B. A., Rengers, F. K., and Tucker, G. E. (2016). <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2016WR019110">Observed and simulated hydrologic response for a first‐order catchment during extreme rainfall 3 years after wildfire disturbance.</a> Water Resources Research, 52(12), 9367-9389.
      </li>
      <li class="research-li">
        Murphy, S.F., Writer, J.H., McCleskey, R.B., and Martin, D.A., 2015, <a href="https://doi.org/10.1088/1748-9326/10/8/084007">The role of precipitation type, intensity, and spatial distribution in source water quality after wildfire</a>: Environmental Research Letters, v. 10, no. 8, 084007: 1-13
      </li>
      <li class="research-li">
        Ebel, B. A., Moody, J. A., and Martin, D. A. (2012). <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2011WR011470">Hydrologic conditions controlling runoff generation immediately after wildfire.</a> Water Resources Research, 48(3).
      </li>
      <li class="research-li">
        Writer, J.H. and Murphy, S.F., 2012, <a href="https://pubs.usgs.gov/fs/2012/3095/FS12-3095.pdf">Wildfire effects on source-water quality—Lessons from Fourmile Canyon Fire, Colorado, and implications for drinking-water treatment</a>: USGS Fact Sheet 2012–3095, 4 p.
      </li>
      <li class="research-li">
        Moody, J. A., and Ebel, B. A. (2012). <a href="https://www.sciencedirect.com/science/article/abs/pii/S0341816212000094?via%3Dihub">Hyper-dry conditions provide new insights into the cause of extreme floods after wildfire.</a> Catena, 93, 58-63.
      </li>
      <li class="research-li">
        Moody, J. A. (2011). <a href="https://pubs.usgs.gov/sir/2011/5236/report/SIR11-5236.pdf">An analytical method for predicting post-wildfire peak discharges.</a> US Geological Survey Scientific Investigations Report, 5236, 36.
      </li>
    </ul>
    <h2><span class="lowlight">USGS Data Releases</span></h2>
    <ul class="styled-li">
      <li class="research-li">
        Murphy, S.F., McCleskey, R.B., D.A., Holloway, J.M., Writer, J.W., Martin, D.A., and Stricker, C.A., 2020, <a href="https://doi.org/10.5066/P941BIYS">Chemistry of water, stream sediment, wildfire ash, soil, dust, and mine waste for Fourmile Creek Watershed, Colorado, 2010-2019</a>: U.S. Geological Survey Data Release (IP-118730, 6/22/20).
      </li>
      <li class="research-li">
        Murphy, S. F., McCleskey, R. B., and Writer, J. H., 2018, <a href="https://doi.org/10.5066/F7Z60N8T">Water chemistry data for Fourmile Creek Watershed, 2010-2015.</a> U.S. Geological Survey database
      </li>
      <li class="research-li">
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


#resources-section {
  margin-bottom: 100px;
}

 
 

.research-li {
  margin: 20px 0;
}

</style>
