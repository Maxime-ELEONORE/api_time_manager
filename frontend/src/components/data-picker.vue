<script setup lang="ts">
import { ref } from 'vue';

let selectedDate = ref(localStorage.getItem('today') || '');
const updateDate = () => {
  localStorage.setItem('today', selectedDate.value);
  document.dispatchEvent(new Event("updateDate"))
};


</script>

<template>
  <div class="card">
    <div class="form-group mt-3">
      <label for="datepicker">Sélectionner une date :</label>
      <input class="min-w-full mt-3" id="create_start" type="date" v-model="selectedDate" @input="updateDate" />
    </div>
  </div>
</template>

<style>
.card {
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
  min-height: 205px;
  padding: 10px;
}
</style>
