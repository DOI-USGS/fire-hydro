<template>
  <section id="usgs-header">
    <header
      id="navbar"
      class="header-nav"
      role="banner"
    >
      <div class="tmp-container">
        <a
          class="logo-header"
          href="https://www.usgs.gov/"
          title="Home"
        >
          <img
            class="img"
            src="@/assets/usgsHeaderAndFooter/images/logo.png"
            alt="Home"
          >
        </a>
      </div>
    </header>
  </section>
</template>

<script setup>
import { onMounted, nextTick } from 'vue';
import { useWindowSizeStore } from '@/stores/WindowSizeStore';

const windowSizeStore = useWindowSizeStore();

onMounted(() => {
  nextTick(() => {
    windowSizeStore.usgsHeaderRendered = true;
  });
});
</script>

<style scoped lang="scss">
header {
  display: block;
}
.tmp-container {
  margin-right: auto;
  margin-left: auto;
  padding-left: 15px;
  padding-right: 15px;
}
.tmp-container a {
  text-decoration: none;
  background: transparent;
}
.tmp-container:after {
  clear: both;
}
@media only screen and (max-width:490px) {
  hr {
    margin-top: 60px;
  }
}
/* header (only) nav */
.header-nav {
  background: #00264c;
}
.logo-header img {
  margin-top: 8px;
  margin-bottom: 8px;
  border: 0;
  max-width: 100%;
  height: auto;
}
.logo-header img {
  height: 65px;
}
</style>
