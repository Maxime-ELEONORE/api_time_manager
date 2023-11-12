<script setup lang="ts">
import {inject, onMounted, ref, watch} from "vue";
import Button from "primevue/button";
import moment from "moment";

const dialogRef = inject("dialogRef");
const isDisabled = ref(false);
const initialWorkingTime = ref(null);
const create_start = ref('');
const create_end = ref('');

const closeDialog = () => {
  dialogRef.value.close({
    id: initialWorkingTime.value ? initialWorkingTime.value.id : '',
    start: create_start,
    end: create_end
  });
};
const cancelDialog = () => {
  dialogRef.value.close();
};

onMounted(() => {
  initialWorkingTime.value = dialogRef.value.data;
  create_start.value = initialWorkingTime.value ? initialWorkingTime.value.start : undefined;
  create_end.value = initialWorkingTime.value ? initialWorkingTime.value.end : undefined;
  watch([create_start, create_end], () => {
    console.log(create_start);
    console.log(create_end);
    isDisabled.value = !create_start.value || !create_end.value
        || !moment(create_start.value).hour() || !moment(create_end.value).hour()
        || !moment(create_start.value).minute() || !moment(create_end.value).minute()
        || moment(create_start.value).isAfter(moment(create_end.value));
  })
});
</script>

<template>
  <div class="card mr-8 ml-8 mt-3 mb-4 p-5">
    <label class="font-bold">Start</label>
    <input class="min-w-full" id="create_start" type="datetime-local" v-model="create_start">
    <label class="font-bold">End</label>
    <input class="min-w-full" id="create_end" type="datetime-local" v-model="create_end">

    <button class="btn btn-primary" @click="closeDialog" :disabled="isDisabled">
      {{ initialWorkingTime ? "Edit" : "Create" }}
    </button>
    <button class="btn btn-danger" @click="cancelDialog">
      Cancel
    </button>
  </div>
</template>

<style>

</style>