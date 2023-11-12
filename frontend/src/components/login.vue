<script setup lang="ts">
import { ref } from 'vue';
import Button from 'primevue/button';
import { RouterLink, RouterView } from 'vue-router';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router';
import moment from "moment";

let email = '';
let password = '';
const route = useRoute();
const router = useRouter();
const showErrorModal = ref(false);

const login = async () => {
  try {
    const response = await axios.post(`http://localhost:4000/api/sign_in`,{
      email: email,
      hash_password: password
    },
    {withCredentials: true}
);
    if (response.status === 200 || response.status === 204) {
      const cookies = response.statusText;
      console.log('Cookies:', cookies);
      showErrorModal.value = false;
      localStorage.setItem('email', response.data.email);
      localStorage.setItem('username', response.data.username);
      localStorage.setItem('user_id', response.data.user_id);
      localStorage.setItem('role', response.data.role);
      localStorage.setItem('token_auth', response.data.token);
      localStorage.setItem('today', moment().format("yyyy-MM-DD"))
      await router.push('/dashboard');
    }
  } catch (error) {
    console.error("Aucun utilisateur n'a été trouvé");
    showErrorModal.value = true;
  }
}
</script>
<template>
  <div class="centered-content mt-5">
    <h3>Time Manager</h3>
    <div class="card-custom">
      <p class="mb-3">Login</p>
      <div v-if="showErrorModal" class="modal">
        <div class="error">
          <p>Aucun utilisateur n'a été trouvé.</p>
        </div>
      </div>
      <div class="mb-3">
        <input type="email" class="form-control" placeholder="Email" v-model="email">
      </div>
      <div class="mb-3">
        <input type="password" class="form-control" placeholder="Password" v-model="password">
      </div>
      <Button class="btn btn-primary" @click="login">
        <span class="centered-text">Log in</span>
      </Button>
    </div>
    <RouterView />
  </div>
</template>

<style scoped>
.centered-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.card-custom {
  width: 300px;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
}

.mb-3 {
  margin-bottom: 20px;
}

input {
  width: 100%;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 5px;
}

.centered-text {
  text-align: center;
}

.error {
  color: red;
}
</style>

