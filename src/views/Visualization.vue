<template>
  <div id="visualization">
    <Header />
    <MainMap />
    <WaterSupply />
    <Guidance />
    <USGS />
    <Resources />
    <img 
      id="thumbnail"
      src="@/assets/images/scar-thumb.jpg" 
      alt="metatag thumbnail"
      loading="lazy"
    >
  </div>
</template>

<script setup>
import { defineAsyncComponent } from 'vue';

const Header = defineAsyncComponent(() => import("./0VizHeader/Header.vue"));
const MainMap = defineAsyncComponent(() => import("./2MainMap/MainMap.vue"));
const WaterSupply = defineAsyncComponent(() => import("./3WaterSupply/WaterSupply.vue"));
const Guidance = defineAsyncComponent(() => import("./4Guidance/Guidance.vue"));
const USGS = defineAsyncComponent(() => import("./5USGS/USGS.vue"));
const Resources = defineAsyncComponent(() => import("./Resources/Resources.vue"));
</script>

<style scoped>
/* Site-wide element and layout styles used to live here. They are global, not
   this component's, so they now sit in src/assets/css — tokens.css for the
   palette, base.css for the rules. */

/* Present only so the image is picked up as the page's metatag thumbnail; it
   is never meant to be seen. */
#thumbnail {
  opacity: 0;
}
</style>
