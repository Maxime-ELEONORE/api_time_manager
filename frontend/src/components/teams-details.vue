<script setup lang="ts">
import {onMounted, ref} from 'vue';
import {useRoute} from 'vue-router';
import axios from "axios";
import moment from "moment/moment";

axios.defaults.withCredentials = true;

const token = localStorage.getItem('token_auth') || '';
let role = localStorage.getItem('role') || '';
let name_team = ""
let selectedDateDebut = moment().startOf('isoWeek');
let selectedDateFin = moment(selectedDateDebut).add(6, 'day');
const route = useRoute();
const id = route.params.id;
let listWorkingTime = ref<Array<{ id: string; start: string; end: string }>>([]);
let members = ref<Array<{ id: string; email: string; username: string; role: string }>>([]);
let members_with_wt = ref<Array<{ id: string; email: string; username: string; role: string; hour: number }>>([]);
let print = ref(false);
let time = ""

const getTeam = async () => {
  try {
    const response = await axios.get(`http://localhost:4000/api/teams/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    if (response.status === 200) {
      name_team = response.data.data.name
      members.value = response.data.data.members
      await getWorkingTime(members.value)
    }
  }
  catch (error) {
    console.error("error : " + error);
  }
}
const getWorkingTime = async (members = <Array<{ id: string; email: string; username: string; role: string }>>([])) => {
  for (const member of members) {
    try {
      const response = await axios.get(`http://localhost:4000/api/workingtimes/${member.id}`, {
        headers: {
          Authorization: "Bearer " + token
        }
      });
      if (response.status === 200) {
        listWorkingTime.value = response.data.data;
        getDuration(member, listWorkingTime.value)
      }
    } catch (error) {
      console.error("error : " + error);
    }
  }
}
const getDuration = (member, listWorkingTime = <Array<{ id: string; start: string; end: string }>>([])) => {
  let calculatedData: moment.Duration = ""
  let calculatedDuration = 0
  for (const workingTime of listWorkingTime) {
    const momentWorkingTimeStart = moment(workingTime.start)
    const momentWorkingTimeEnd = moment(workingTime.end)
    if (momentWorkingTimeStart.isBetween(selectedDateDebut, selectedDateFin) && momentWorkingTimeEnd.isBetween(selectedDateDebut, selectedDateFin)) {
      calculatedData = calculateDuration(workingTime.start, workingTime.end)
      calculatedDuration += parseInt(formatDuration(calculatedData))
    }
  }
  members_with_wt.value.push({
    ...member,
    hour: calculatedDuration
  });
}
const updateDate = () => {
  selectedDateDebut = moment(selectedDateDebut)
  selectedDateFin = moment(selectedDateFin)
  members_with_wt.value = [];
  getWorkingTime(members.value)
}

const calculateDuration = (start: string, end: string) => {
  const startTime = moment(start);
  const endTime = moment(end);
  return moment.duration(endTime.diff(startTime));
};

const formatDuration = (duration: moment.Duration) => {
  const hours = duration.hours();
  const minutes = duration.minutes();
  return `${hours}h ${minutes}m`;
};

const startClock = async () => {
  print.value = true
  time = moment().format('yyyy-MM-DDTHH:mm:ss');
  try {
    const clock = {
      status: print.value,
      time: time
    }
    const response = await axios.post(`http://localhost:4000/api/teams/${id}/create-clock`, {
      clock
    }, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      console.log('New clock has been create for every user')
    }
  } catch (error) {
    console.error("error : " + error);
  }
}

const stopClock = async () => {
  print.value = false
  time = moment().format('yyyy-MM-DDTHH:mm:ss');
  try {
    const clock = {
      status: print.value,
      time: time
    }
    const response = await axios.post(`http://localhost:4000/api/teams/${id}/create-clock`, {
      clock
    }, {
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      console.log('New clock has been create for every user')
    }
  } catch (error) {
    console.error("error : " + error);
  }
}
onMounted(getTeam)
</script>
<template>
  <div class="col-md-12">
    <div class="row">
      <div class="col-md-6">
        <h1>{{ name_team }}</h1>
      </div>
      <div class="col-md-3">
        <button class="btn btn-success" @click="startClock">Start Clock for users</button>
      </div>
      <div class="col-md-3">
        <button class="btn btn-danger" @click="stopClock">Stop Clock for users</button>
      </div>
    </div>
    <hr/>
    <div class="row">
      <label>By default, the date selected is the date of the current week</label>
      <div class="col-md-4 form-group mt-3">
        <label class="form-label">Select a start date:</label>
        <input class="form-control mt-2" id="create_start" type="date" v-model="selectedDateDebut"/>
      </div>
      <div class="col-md-4 form-group mt-3">
        <label class="form-label">Select an end date:</label>
        <input class="form-control mt-2" id="create_start" type="date" v-model="selectedDateFin"/>
      </div>
      <div class="col-md-4 btn-perso-mg">
        <button class="btn btn-primary" @click="updateDate">Choose a date</button>
      </div>
    </div>
    <hr/>
    <div class="flex justify-content-between">
      <h4>Table of Users :</h4>
      <button class="btn btn-success">
        Add User
      </button>
    </div>
    <table id="teamsTable" class="table table-striped">
      <thead>
      <tr>
        <th>Username</th>
        <th>WorkTimes</th>
        <th v-if="role === 'Super Manager' || role === 'Manager'">Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="member in members_with_wt" :key="member.id">
        <td>{{ member.username }}</td>
        <td>{{ member.hour }}</td>
        <td v-if="role === 'Super Manager' || role === 'Manager'">
          <button class="btn btn-primary">Edit User</button>
          <button class="btn btn-danger delete-button ml-3">Remove</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</template>
<style>
.form-group {
  margin-top: 20px;
}

.form-label {
  font-size: 16px;
  font-weight: bold;
  color: #333;
}

.form-control {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 14px;
  margin-top: 8px;
}
.btn-perso-mg{
  margin-top: 47px;
}
</style>