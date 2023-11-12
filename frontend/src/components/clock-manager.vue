<script setup lang="ts">
import Button from 'primevue/button';
import { ref, onMounted } from 'vue';
import moment from "moment";
import axios from "axios";
axios.defaults.withCredentials = true;

let user_id = localStorage.getItem('user_id') || '';
let token = localStorage.getItem('token_auth') || '';
let intervalId: number | null = null;
let start = ref(false);
let startWorkingTime = "";
let endWorkingTime = "";
let time = ""
let currentDate = ref(new Date());
let dateNow = moment();
let clock_time = moment();
let timer: moment.Duration = "";
let printTimer = ref("00:00:00")
const updateDate = () => {
  dateNow = moment();
  timer = moment.duration(dateNow - clock_time)
  printTimer.value = moment.utc(timer.asMilliseconds()).format("HH:mm:ss");
};
async function loadData() {
  try {
    const response = await axios.get(`http://localhost:4000/api/clocks/${user_id}`, {
      headers: {
        Authorization: "Bearer " + token
      }
    }
    );
    const responseData = response.data.data;
    const lastClock = responseData[responseData.length - 1];
    if(lastClock.status === true){
      start.value = true
      clock_time = moment(lastClock.time)
      startWorkingTime = moment(lastClock.time).format('yyyy-MM-DDTHH:mm:ss')
      intervalId = setInterval(updateDate, 1000);
    }
  } catch (error) {
    console.error('An error has occurred :', error);
  }
}

onMounted(loadData);

const createWorkingTimes = async () => {
  try {
    const working_time = {
      start: startWorkingTime,
      end: endWorkingTime
    }
    const response = await axios.post(`http://localhost:4000/api/workingtimes/${user_id}`, {
      working_time
    }, {
      headers: {
        Authorization: "Bearer " + token
      },
    })
    if (response.status === 201) {
      console.log('New workingtime has been create')
      document.dispatchEvent(new Event("createWorkingTime"))
    }
  }
  catch (error) {
    console.error(error)
    console.log('Une erreur est survenue')
  }
}
const updateCurrentDate = () => {
  currentDate.value = new Date()
}
setInterval(updateCurrentDate, 1000)
const createClock = async () => {
  intervalId = setInterval(updateDate, 1000);
  start.value = true
  time = moment(currentDate.value).format('yyyy-MM-DDTHH:mm:ss');
  try {
    const clock = {
      time: time,
      status: true,
    }
    const response = await axios.post(`http://localhost:4000/api/clocks/${user_id}`,{
      clock
    }, {
      headers: {
        Authorization: "Bearer " + token
      }
    })
    if (response.status === 201) {
      startWorkingTime = moment(time).format('yyyy-MM-DDTHH:mm:ss')
      console.log('New clock has been create')
      start.value = true
      clock_time = moment(currentDate.value)
    }
  } catch (error) {
    console.log('An error has occurred')
    console.error(error)
  }
}

const stopClock = async () => {
  if (intervalId !== null) {
    clearInterval(intervalId);
  }
  time = moment(currentDate.value).format('yyyy-MM-DDTHH:mm:ss');
  try {
    const clock = {
      time: time,
      status: false,
    }
    const response = await axios.post(`http://localhost:4000/api/clocks/${user_id}`,{
      clock
    }, {
      headers: {
        Authorization: "Bearer " + token
      }
    })
    if (response.status === 201) {
      endWorkingTime = moment(time).format('yyyy-MM-DDTHH:mm:ss')
      printTimer.value = "00:00:00"
      console.log('New clock has been create')
      start.value = false
      createWorkingTimes()
    }
  } catch (error) {
    console.log('An error has occurred')
    console.error(error)
  }
}
</script>

<template>
  <div class="card">
    <p class="mb-3">Create Clock</p>
    <p class="centered-text">{{ printTimer }}s</p>
    <button v-if="start === false" @click="createClock" class="centered-text btn btn-success">Start</button>
    <button v-if="start === true" @click="stopClock" class="centered-text btn btn-danger">Stop</button>
  </div>
</template>

<style scoped>

.card {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
}

.centered-text {
  text-align: center;
  margin-top: 10px;
}
</style>

