<template>
  <div class="m-5 p-5 bg-white-alpha-10 border-round-2xl">
    <div>
      <h1 class="text-primary">WorkingTime</h1>
      <h2>{{ date }}</h2>
    </div>
    <div class="w-full flex justify-content-center align-items-center gap-8 mt-5">
      <Button @click="createWorkingTime(user.id)">Create</button>
      <Button @click="updateWorkingTime(user.id)">Modify</button>
      <Button @click="deleteWorkingTime(workingTime.id)">Delete</button>
    </div>
  </div>
</template>

<script lang="ts">
import Button from 'primevue/button';
import WorkingTimeRepository from '@/repositories/working-time.repository';
import type {WorkingTimeInterface} from '@/models/WorkingTimeInterface';
import type {UserInterface} from "@/models/UserInterface";
import moment from "moment";


export default {
  props: {
    user: Object as () => UserInterface,
    workingTime: Object as () => WorkingTimeInterface,
  },
  components: {
    Button,
  },
  data() {
    return {
      date: moment(this.$props.workingTime?.start).format('DD/MM/yyyy HH:mm:ss')
    };
  },
  methods: {
    createWorkingTime(userId: number) {
      WorkingTimeRepository.createWorkingTime(userId, {} as WorkingTimeInterface).then(
          (response: any) => {
            console.log(response.data.data as WorkingTimeInterface);
          }
      );
    },
    updateWorkingTime(id: number) {
      WorkingTimeRepository.updateWorkingTime(id, {} as WorkingTimeInterface);
    },
    deleteWorkingTime(id: number) {
      WorkingTimeRepository.deleteWorkingTime(id);
    },
  },
};
</script>

<style></style>