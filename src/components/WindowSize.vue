<template>
  <section id="window-size-component">
    <p>window width {{ windowSizeStore.windowWidth }} -- height {{ windowSizeStore.windowHeight }}</p>
  </section>
</template>

<script setup>
import { useWindowSizeStore } from '@/stores/WindowSizeStore';

const windowSizeStore = useWindowSizeStore();
</script>

<style scoped lang="scss">
#window-size-component {
  width: 100%;
  position: fixed;
  z-index: 999;
  color: white;
  font-size: 8pt;
  font-weight: lighter;
  background-color: rgba(155, 158, 156, 0.8);
  p {
    margin: 0;
    padding:0 0 0.1em 1em;
  }
}
</style>
