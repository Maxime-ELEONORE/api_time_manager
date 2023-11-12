<script setup lang="ts">
import Profil from './profil.vue'
import {useRoute, useRouter} from 'vue-router';

const route = useRoute();
const router = useRouter();
const shouldShowSidebar = () => {
  return !['/login', '/'].includes(route.path);
};
</script>
<template>
<nav v-if="shouldShowSidebar()" class="d-none d-md-block bg-light sidebar">
  <div class="sidebar-sticky d-flex flex-column mx-2 mt-5">
    <Profil class="my-1"/>
  </div>
</nav>
</template>

<style scoped>
</style>
