<script setup lang="ts">
import ClockManager from '../components/clock-manager.vue'
import ChartPresence from "@/components/chart-presence.vue";
import ChartPercent from "@/components/chart-percent-presence.vue";
import DatePicker from "@/components/data-picker.vue"
</script>

<template>
  <main>
    <div class="row">
      <div class="col-md-4">
        <DatePicker />
      </div>
      <div class="col-md-4">
        <ClockManager />
      </div>
      <div class="col-md-4">
        <ChartPercent />
      </div>
    </div>
    <ChartPresence/>
  </main>
</template>
