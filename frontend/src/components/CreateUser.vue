<script setup lang="ts">
import Button from "primevue/button";
import {inject, onMounted, ref, watch} from "vue";
import {isBlank, isSameObject} from "@/functions/functions";

const dialogRef = inject("dialogRef");
const isDisabled = ref(true);
const expression: RegExp = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;

const initialUser = ref(null);
const create_email = ref('');
const create_username = ref('');
const create_password = ref('');
const create_role = ref('');
const role = ref('');

const closeDialog = () => {
  dialogRef.value.close({
    username: create_username,
    email: create_email,
    hash_password: create_password,
    role: create_role
  });
};

onMounted(() => {
  initialUser.value = dialogRef.value.data;
  create_email.value = initialUser.value ? initialUser.value.email : '';
  create_username.value = initialUser.value ? initialUser.value.username : '';
  create_password.value = initialUser.value ? initialUser.value.password : '';
  create_role.value = initialUser.value ? initialUser.value.role : 'User';
  role.value = localStorage.getItem('role') || '';
  watch([create_email, create_username, create_password, create_role], () => {
    isDisabled.value = isBlank(create_email.value)
        || !expression.test(create_email.value)
        || isBlank(create_username.value)
        || isBlank(create_password.value)
        || isBlank(create_role.value)
        || isSameObject(initialUser.value, {
          email: create_email.value,
          username: create_username.value,
          password: create_password.value,
          role: create_role.value
        });
  });
});
</script>


<template>
  <div class="card mr-8 ml-8 mt-3 mb-4">
    <p class="profil">{{ initialUser ? "Modify " + initialUser.username : "Create a new User" }}</p>
    <input id="create_email" placeholder="Email" type="email" v-model="create_email">
    <input id="create_username" placeholder="Username" type="text" v-model="create_username">
    <input id="create_password" placeholder="Password" type="password" v-model="create_password">
    <select v-model="create_role">
      <option value="user" selected>User</option>
      <option value="manager" v-if="role === 'Super Manager'">Manager</option>
      <option value="manager" v-if="role === 'Super Manager'">Super Manager</option>
    </select>
    <Button @click="closeDialog" :disabled="isDisabled">
      <span class="centered-text">Create User</span>
    </Button>
  </div>
</template>

<style scoped>
.centered-content {
  display: flex;
  justify-content: center;
  align-items: center;
}

.card {
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
}

.content {
  text-align: center;
}

input {
  width: 80%;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 5px;
}

select {
  width: 80%;
  padding: 10px;
  margin-bottom: 10px;
}

.profil {
  margin-bottom: 20px;
}

Button {
  margin-top: 10px;
}
</style>

