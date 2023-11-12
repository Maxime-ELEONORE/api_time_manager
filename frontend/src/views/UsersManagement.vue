<script setup lang="ts">

let role = localStorage.getItem('role') || '';

</script>
<template>
  <div class="mt-3" v-if="role === 'Super Manager' || role === 'Manager'">
    <User/>
  </div>
  <div v-if="role === 'User'">
    <h5>You are not authorized to access this page</h5>
  </div>
</template>

<script lang="ts">
import User from "@/components/user.vue";


export default {
  components: {User}
}
</script>

<style>

</style>