<script setup lang="ts">
import {RouterView, useRoute, useRouter} from 'vue-router';
import Navbar from './components/Navbar.vue';
import Sidebar from './components/Sidebar.vue';

const route = useRoute();
const router = useRouter();
const shouldShowFooter = () => {
  return !['/login'].includes(route.path);
};
</script>

<template>
  <div id="app">
    <header>
      <Navbar />
    </header>
    <body>
      <div class="content">
        <div class="row">
          <Sidebar class="col-md-3 d-none d-md-block" />
          <div class="container col-md-8 py-3">
            <RouterView class="mt-2 mb-5"/>
          </div>
        </div>
      </div>
    </body>
    <footer v-if="shouldShowFooter()" class="text-center py-4 bg-dark text-light">
      <p>&copy; 2023 Time Manager. All rights reserved.</p>
    </footer>
  </div>
  </template>

  <style scoped>
  #app {
    display: flex;
    flex-direction: column;
  }

  main{
    min-height: 60vh;
  }

  .content {
    flex: 1;
  }
  .row {
    --bs-gutter-x: 0;
  }
</style>
