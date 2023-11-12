<script setup lang="ts">
import {onMounted, ref} from "vue";
import axios from "axios";
import moment from "moment";
import CreateWorkingTime from "@/components/create-working-time.vue";
import DynamicDialog from "primevue/dynamicdialog";
import Toast from "primevue/toast";
import {useDialog} from "primevue/usedialog";
import {WorkingTimeInterface} from "@/models/WorkingTimeInterface";
import {useToast} from "primevue/usetoast";

axios.defaults.withCredentials = true;

let user_id = localStorage.getItem('user_id') || '';
let token = localStorage.getItem('token_auth') || '';
let role = localStorage.getItem('role') || '';
let listWorkingTime = ref<Array<{ id: string; start: string; end: string }>>([]);
const dialog = useDialog();
const toast = useToast();

const getWorkingTime = async () => {
  try {
    const response = await axios.get(`http://localhost:4000/api/workingtimes/${user_id}`, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      listWorkingTime.value = response.data.data;
      listWorkingTime.value.sort((a, b) => {
        const dateA = moment(a.start).toDate();
        const dateB = moment(b.start).toDate();
        return dateB - dateA;
      });
    }
  } catch (error) {
    console.error("error : " + error);
  }
}

const createWorkingTime = async (workingTime) => {
  try {
    const response = await axios.post(`http://localhost:4000/api/workingtimes}`, {workingTime}, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      toast.add({
        severity: 'success',
        summary: 'Success',
        detail: 'WorkingTime created successfully',
      });
      await getWorkingTime();
    }
  } catch (error) {
    toast.add({
      severity: 'error',
      summary: 'Error',
      detail: 'An error occurred while creating the workingtime',
    });
  }
};
const editWorkingTime = async (workingTime) => {
  const working_time = {
    start: workingTime.start,
    end: workingTime.end
  }
  try {
    const response = await axios.put(`http://localhost:4000/api/workingtimes/${workingTime.id}`, {working_time}, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      toast.add({
        severity: 'success',
        summary: 'Success',
        detail: 'WorkingTime edited successfully',
      });
      await getWorkingTime();
    }
  } catch (error) {
    toast.add({
      severity: 'error',
      summary: 'Error',
      detail: 'An error occurred while editing the workingtime',
    });
  }
};
const openAddWorkingTimeDialog = () => {
  dialog.open(CreateWorkingTime, {
    props: {
      header: 'Create workingtime',
      modal: true
    },
    data: null,
    onClose: (item) => {
      if (item.data) {
        const workingtime = {
          start: item.data.start.value,
          end: item.data.end.value
        } as WorkingTimeInterface
        createWorkingTime(workingtime);
      } else {
        toast.add({
          severity: 'info',
          summary: 'Info',
          detail: 'WorkingTime not created',
        });
      }
    }
  })
};
const openEditWorkingTimeDialog = (item) => {
  dialog.open(CreateWorkingTime,
      {
        props: {
          header: 'Edit workingtime',
          modal: true
        },
        data: item,
        onClose: (item) => {
          if (item.data) {
            const workingtime = {
              id: item.data.id,
              start: item.data.start.value,
              end: item.data.end.value
            } as WorkingTimeInterface
            editWorkingTime(workingtime);
          } else {
            toast.add({
              severity: 'info',
              summary: 'Info',
              detail: 'WorkingTime not modified',
            });
          }
        }
      });
}

const deleteWorkingTime = async (workingTimeId: string) => {
  try {
    const response = await axios.delete(`http://localhost:4000/api/workingtimes/${workingTimeId}`, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 204) {
      toast.add({
        severity: 'success',
        summary: 'Success',
        detail: 'WorkingTime deleted successfully',
      });
      listWorkingTime.value = listWorkingTime.value.filter(item => item.id !== workingTimeId);
    }
  } catch (error) {
    console.error("error : " + error);
    toast.add({
      severity: 'error',
      summary: 'Error',
      detail: 'An error occurred while deleting the workingtime',
    });
  }
}

const calculateDuration = (start: string, end: string) => {
  const startTime = moment(start);
  const endTime = moment(end);
  const duration = moment.duration(endTime.diff(startTime));
  return formatDuration(duration);
};

const formatDuration = (duration: moment.Duration) => {
  const hours = duration.hours();
  const minutes = duration.minutes();
  return `${hours}h ${minutes}m`;
};

onMounted(getWorkingTime);
</script>
<template>
  <Toast/>
  <DynamicDialog/>
  <div class="col-md-12">
    <h1>Working Times</h1>
    <div class="flex justify-content-end">
      <button class="btn btn-primary" @click="openAddWorkingTimeDialog">
        Create
      </button>
    </div>
    <table id="workingTimeTable" class="table table-striped">
      <thead>
      <tr>
        <th>Start</th>
        <th>End</th>
        <th>Duration</th>
        <th v-if="role === 'Super Manager' || role === 'Manager'">Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="item in listWorkingTime" :key="item.id">
        <td>{{ moment(item.start).format('yyyy-MM-DD HH:mm:ss') }}</td>
        <td>{{ moment(item.end).format('yyyy-MM-DD HH:mm:ss') }}</td>
        <td>{{ calculateDuration(item.start, item.end) }}</td>
        <td v-if="role === 'Super Manager' || role === 'Manager'">
          <button class="btn btn-primary" @click="openEditWorkingTimeDialog(item)">Edit</button>
          <button @click="deleteWorkingTime(item.id)" class="btn btn-danger delete-button">Delete</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</template>
<style>
.delete-button {
  margin-left: 10px;
}
</style>