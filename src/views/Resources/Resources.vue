<template>
  <div
    id="resources-section"
    class="text-content"
  >
    <h2><span class="lowlight">Further Research</span></h2>
    <p>This webpage was based on the papers listed below. For more information about USGS work on wildfires and water supplies, visit <a href="https://www.usgs.gov/mission-areas/water-resources/science/water-quality-after-wildfire?qt-science_center_objects=0#qt-science_center_objects">USGS Wildland Fire Science, USGS Water Resources Mission Area,</a>, the California Water Science Center, or <a href="https://pubs.er.usgs.gov/publication/ofr20191002">additional USGS peer-reviewed research on wildfires</a>.</p>
    <ul class="styled-li">
      <li class="research-li">
        Ebel, B. A. 2020. <a href="https://www.sciencedirect.com/science/article/abs/pii/S0022169420302250?via%3Dihub">Temporal evolution of measured and simulated infiltration following wildfire in the Colorado Front Range, USA: Shifting thresholds of runoff generation and hydrologic hazards.</a> Journal of Hydrology, 585, 124765.
      </li>
      <li class="research-li">
        Ebel, B. A., Moody, J. A., and Martin, D. A. 2012. <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2011WR011470">Hydrologic conditions controlling runoff generation immediately after wildfire.</a> Water Resources Research, 48(3).
      </li>
      <li class="research-li">
        Ebel, B. A., Rengers, F. K., and Tucker, G. E. 2016. <a href="https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2016WR019110">Observed and simulated hydrologic response for a first‐order catchment during extreme rainfall 3 years after wildfire disturbance.</a> Water Resources Research, 52(12), 9367-9389.
      </li>
      <li class="research-li">
        Martin, D. A. 2016. <a href="https://royalsocietypublishing.org/doi/full/10.1098/rstb.2015.0172">At the nexus of fire, water and society.</a> Phil. Trans. R. Soc. B. 371: 20150172.
      </li>
      <li class="research-li">
        Moody, J. A. 2011. <a href="https://pubs.usgs.gov/sir/2011/5236/report/SIR11-5236.pdf">An analytical method for predicting post-wildfire peak discharges.</a> US Geological Survey Scientific Investigations Report, 5236, 36.
      </li>
      <li class="research-li">
        Moody, J. A., and Ebel, B. A. 2012. <a href="https://www.sciencedirect.com/science/article/abs/pii/S0341816212000094?via%3Dihub">Hyper-dry conditions provide new insights into the cause of extreme floods after wildfire.</a> Catena, 93, 58-63.
      </li>
      <li class="research-li">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Holloway, J.M., and Writer, J.W. 2020. <a href="https://doi.org/10.1016/j.scitotenv.2020.140635">Wildfire-driven changes in hydrology mobilize arsenic and metals from legacy mine waste</a>: Science of the Total Environment 743, 140635
      </li>
      <li class="research-li">
        Murphy, S.F., McCleskey, R.B., Martin, D.A., Writer, J.H., and Ebel, B.A. 2018. <a href="https://doi.org/10.1029/2017JG004349">Fire, flood, and drought—Extreme climate events alter flow paths and stream chemistry</a>, Journal of Geophysical Research: Biogeosciences, 123, p. 2513-2526
      </li>
      <li class="research-li">
        Murphy, S.F., Writer, J.H., McCleskey, R.B., and Martin, D.A. 2015. <a href="https://doi.org/10.1088/1748-9326/10/8/084007">The role of precipitation type, intensity, and spatial distribution in source water quality after wildfire</a>: Environmental Research Letters, 10, 8, 084007: 1-13
      </li>
      <li class="research-li">
        Writer, J.H. and Murphy, S.F. 2012. <a href="https://pubs.usgs.gov/fs/2012/3095/FS12-3095.pdf">Wildfire effects on source-water quality—Lessons from Fourmile Canyon Fire, Colorado, and implications for drinking-water treatment</a>: USGS Fact Sheet 2012–3095, 4 p.
      </li>
    </ul>
  </div>
</template>

<script>
    export default {
        name: 'Resources',
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
