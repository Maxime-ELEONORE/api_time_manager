<script setup lang="ts">
import {onMounted, ref} from 'vue';
import axios from 'axios';
import {RouterLink, useRoute, useRouter} from 'vue-router';
axios.defaults.withCredentials = true;

const token = localStorage.getItem('token_auth') || '';
let role = localStorage.getItem('role') || '';

let listOfTeams = ref<Array<{ id: string; members: []; name: string }>>([]);

const getTeams = async () => {
  try {
    const response = await axios.get(`http://localhost:4000/api/teams`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    console.log(response)
    if (response.status === 200) {
      console.log(response.data.data)
      listOfTeams.value = response.data.data;
    }
  }
  catch (error) {
    console.error("error : " + error);
  }
}

onMounted(getTeams)
</script>

<template>
  <div class="col-md-12">
    <h1>Teams</h1>
    <div class="flex justify-content-end">
      <button class="btn btn-primary">
        Create a new Teams
      </button>
    </div>
    <table id="teamsTable" class="table table-striped">
      <thead>
      <tr>
        <th>Name</th>
        <th>Link</th>
        <th v-if="role === 'Super Manager' || role === 'Manager'">Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="item in listOfTeams" :key="item.id">
        <td>{{ item.name }}</td>
        <td>
          <RouterLink :to="`/teams/${item.id}`">
            <button class="btn btn-perso">See the team</button>
          </RouterLink>
        </td>
        <td v-if="role === 'Super Manager' || role === 'Manager'">
          <button class="btn btn-primary">Edit</button>
          <button class="btn btn-danger delete-button ml-3">Delete</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<style>
.btn-perso{
  background-color: #17a2b8;
  color: white;
}
</style>