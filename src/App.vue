<template>
  <div>
    <WindowSize v-if="typeOfEnv === '-test build-'" />
    <HeaderUSWDSBanner />
    <HeaderUSGS />
    <WorkInProgressWarning v-if="typeOfEnv !== ''" />
    <RouterView />
    <PreFooterCodeLinks />
    <FooterUSGS />
  </div>
</template>

<script setup>
  import { onMounted, onUnmounted } from "vue";
  import { RouterView } from 'vue-router';
  import WindowSize from "@/components/WindowSize.vue";
  import HeaderUSWDSBanner from "@/components/HeaderUSWDSBanner.vue";
  import HeaderUSGS from '@/components/HeaderUSGS.vue';
  import WorkInProgressWarning from "@/components/WorkInProgressWarning.vue";
  import PreFooterCodeLinks from "@/components/PreFooterCodeLinks.vue";
  import FooterUSGS from '@/components/FooterUSGS.vue';
  import { useWindowSizeStore } from '@/stores/WindowSizeStore';

  const windowSizeStore = useWindowSizeStore();
  const typeOfEnv = import.meta.env.VITE_APP_TIER;

  function handleResize() {
    windowSizeStore.windowWidth = window.innerWidth;
    windowSizeStore.windowHeight = window.innerHeight;
  }

  onMounted(() => {
    window.addEventListener('resize', handleResize);
    handleResize();
  });

  onUnmounted(() => {
    window.removeEventListener('resize', handleResize);
  });
</script>

<style lang="scss">
</style>
