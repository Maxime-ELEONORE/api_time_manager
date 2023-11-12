<script setup lang="ts">
import {RouterLink, useRoute, useRouter} from 'vue-router';

const route = useRoute();
const router = useRouter();
let role = localStorage.getItem('role') || '';

const shouldShowNavbar = () => {
  return !['/login', '/'].includes(route.path);
};

const logout = () => {
  localStorage.removeItem("email");
  localStorage.removeItem("username");
  localStorage.removeItem("user_id");
  localStorage.removeItem("role");
  localStorage.removeItem("token_auth");
  router.push('/login');
}
</script>

<template>
  <nav  v-if="shouldShowNavbar()" class="navbar navbar-expand-sm navbar-dark bg-dark">
    <RouterLink to="/dashboard">
      <img src="../components/icons/LogoTimeManager.png" alt="Logo Time Manager">
    </RouterLink>
    <div class="collapse navbar-collapse" id="navbarsExample03">
      <ul class="navbar-nav  mr-auto">
        <li class="nav-link">
          <p>Time Manager</p>
        </li>
        <li class="nav-item active">
          <RouterLink to="/dashboard" class="router-link">
            <a class="nav-link">Dashboard</a>
          </RouterLink>
        </li>
<!--        <li class="nav-item active">-->
<!--          <RouterLink v-if="role === 'Super Manager' || role === 'Manager'" to="/user-management" class="router-link">-->
<!--          <a class="nav-link">User Management</a>-->
<!--          </RouterLink>-->
<!--        </li>-->
        <li class="nav-item active">
          <RouterLink to="/working-time" class="router-link">
            <a class="nav-link">Working Times</a>
          </RouterLink>
        </li>
        <li class="nav-item">
          <RouterLink v-if="role === 'Super Manager' || role === 'Manager'" to="/teams" class="router-link">
          <a class="nav-link">Teams</a>
          </RouterLink>
        </li>
      </ul>
      <ul class="navbar-nav  ml-a ms-auto">
        <li class="nav-item mx-3">
          <p class="nav-link" @click="logout">Log out</p>
        </li>
      </ul>
    </div>
  </nav>     
</template>

<style scoped>
.router-link {
  text-decoration: none;
}
p {
  color: white;
}
</style>