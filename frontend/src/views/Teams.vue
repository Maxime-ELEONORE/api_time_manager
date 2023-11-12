<script setup lang="ts">
import Teams from '../components/teams.vue'

let role = localStorage.getItem('role') || '';
</script>

<template>
  <main>
    <div v-if="role === 'Super Manager' || role === 'Manager'">
      <Teams />
    </div>
    <div v-if="role === 'User'">
      <h5>You are not authorized to access this page</h5>
    </div>
  </main>
</template>