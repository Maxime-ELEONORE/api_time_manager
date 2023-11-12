<script setup lang="ts">
import { ref, onMounted } from 'vue';
import Chart from 'chart.js/auto';
import axios from 'axios';
import moment from "moment";
axios.defaults.withCredentials = true;

const chartRef = ref<HTMLCanvasElement | null>(null);
let today = localStorage.getItem('today') || '';
let momentToday = moment(today);
let monday = momentToday.clone().startOf('isoWeek');
let momentEndWeek = moment(monday).add(6, 'day');

let normalHours = 0;
let nightHours = 0;
let overtimeHours = 0;

const user_id = localStorage.getItem('user_id') || '';
const token = localStorage.getItem('token_auth') || '';

type WorkingTime = {
  start: string;
  end: string;
};

let chartInstance = null;

const listWorkingTime = ref<WorkingTime[]>([]);
let listWorkingTimeWeek = ref<WorkingTime[]>([]);

function calculateHours(workingTimes) {
  let totalHours = 0;
  let totalNightHours = 0;
  overtimeHours = 0;

  workingTimes.forEach(time => {
    let start = moment(time.start);
    let end = moment(time.end);
    let current = moment(start);

    while (current < end) {
      let isNightTime = current.hour() >= 22 || current.hour() < 7;
      let nextHour = moment(current).add(1, 'hour').startOf('hour');
      let segmentEnd = nextHour < end ? nextHour : end;
      let duration = moment.duration(segmentEnd.diff(current)).asHours();

      if (isNightTime) {
        totalNightHours += duration;
      }

      totalHours += duration;
      current = nextHour;
    }
  });

  if (totalHours > 35) {
    overtimeHours = totalHours - 35;
    totalHours = 35;
  }

  normalHours = totalHours - totalNightHours;
  nightHours = totalNightHours;
}

const getWorkingTime = async () => {
  try {
    const response = await axios.get(`http://localhost:4000/api/workingtimes/${user_id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    if (response.status === 200) {
      listWorkingTime.value = response.data.data;
      updateChartData();
    }
  } catch (error) {
    console.error("error : " + error);
  }
};

const updateChartData = () => {
  listWorkingTime.value.forEach(workingTime => {
    const startTime = moment(workingTime.start);
    const endTime = moment(workingTime.end);

    if (startTime.isBetween(monday, momentEndWeek) && endTime.isBetween(monday, momentEndWeek)) {
      listWorkingTimeWeek.value.push(workingTime);
    }
  });
  calculateHours(listWorkingTimeWeek.value);

  if (chartInstance) {
    chartInstance.destroy();
  }

  if (chartRef.value) {
    const ctx = chartRef.value.getContext('2d');
    if (ctx) {
      chartRef.value.innerHTML = '';
      chartInstance = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: ['Overtime Hours', 'Night Hours', 'Normal Hours'],
          datasets: [{
            data: [overtimeHours, nightHours, normalHours],
            backgroundColor: ['#ff9f40', '#3da2a2', '#ff6384'],
          }]
        }
      });
    }
  }
};

onMounted(() => {
  document.addEventListener("updateDate", () => {
    today = localStorage.getItem('today') || '';
    momentToday = moment(today);
    monday = momentToday.clone().startOf('isoWeek');
    momentEndWeek = moment(monday).add(6, 'day');
    listWorkingTimeWeek = ref<WorkingTime[]>([]);
    updateChartData();
  });
  document.addEventListener("createWorkingTime", () => {
    getWorkingTime()
  })
  getWorkingTime();
});
</script>
<template>
  <div class="card">
    <label>Weekly Hours</label>
    <canvas class="canvaContainer" ref="chartRef"></canvas>
  </div>
</template>
<style>
.card {
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
}

.canvaContainer{
  max-height: 160px;
  padding: 10px
}
</style>