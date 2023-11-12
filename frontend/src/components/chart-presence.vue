<script setup lang="ts">
import { ref, onMounted } from 'vue';
import Chart from 'chart.js/auto';
import axios from 'axios';
import moment from "moment";
axios.defaults.withCredentials = true;

let chartRef = ref<HTMLCanvasElement | null>(null);
const data = ref<{ hour: string; value: number }[]>([]);

for (let hour = 0; hour <= 23; hour++) {
  for (let minute = 0; minute < 60; minute += 1) {
    const formattedHour = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
    data.value.push({ hour: formattedHour, value: 0 });
  }
}
const user_id = localStorage.getItem('user_id') || '';
const token = localStorage.getItem('token_auth') || '';
let today = localStorage.getItem('today') || '';

type WorkingTime = {
  start: string;
  end: string;
};

const listWorkingTime = ref<WorkingTime[]>([]);

let chartInstance = null;

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
  data.value.forEach(item => (item.value = 0));

  listWorkingTime.value.forEach(workingTime => {
    const startTime = moment(workingTime.start).format('HH:mm');
    const endTime = moment(workingTime.end).format('HH:mm');
    for (const item of data.value) {
      if (moment(workingTime.start).format('yyyy-MM-DD') == today){
        if (item.hour >= startTime && item.hour <= endTime) {
          item.value = 0.5;
        }
      }
    }
  });

  if (chartInstance) {
    chartInstance.destroy();
  }

  if (chartRef.value) {
    const ctx = chartRef.value.getContext('2d');
    if (ctx) {
      chartRef.value.innerHTML = '';
      chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
          labels: data.value.map(item => item.hour),
          datasets: [
            {
              label: "Presence of: " + today,
              data: data.value.map(item => item.value),
              fill: true,
              borderColor: 'rgba(75, 192, 192, 1)',
              tension: 0,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              display: false,
              max: 1,
            },
          },
        },
      });
    }
  }
};

onMounted(() => {
  document.addEventListener("updateDate", () => {
    today = localStorage.getItem('today') || '';
    updateChartData();
  })

  document.addEventListener("createWorkingTime", () => {
    getWorkingTime()
  })
  getWorkingTime();
});
</script>
<template>
  <div class="mt-3 card">
    <canvas ref="chartRef" width="400" height="100"></canvas>
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
</style>