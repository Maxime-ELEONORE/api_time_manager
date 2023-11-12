<script setup lang="ts">
import axios from "axios";
import {ref} from "vue";

let email = localStorage.getItem('email') || '';
let username = localStorage.getItem('username') || '';
let user_id = localStorage.getItem('user_id') || '';
let token = localStorage.getItem('token_auth') || '';
let updated_email = email;
let updated_username = username;
let emailError = ref(false);
const validateEmail = () => {
  const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

  emailError.value = !emailPattern.test(updated_email);
};
const updateUser = async () => {
  if (emailError.value) {
    console.log("Veuillez saisir une adresse email valide.");
    return;
  }
  try {
    const user = {
      username: updated_username,
      email: updated_email,
    }
    const response = await axios.put(`http://localhost:4000/api/users/${user_id}`,{
      user: user
    },{
      headers: {
        Authorization: "Bearer " + token
      }
    });
    if (response.status === 200) {
      console.log("le user a bien été modifié");
      localStorage.setItem('email', updated_email);
      localStorage.setItem('username', updated_username);
    } else {
      console.log("une erreur est survenue");
    }
  } catch (error) {
    console.error("Une erreur s'est produite");
  }
}
</script>

<template>
  <div class="centered-content">
    <img src="../components/icons/user_icon.png" alt="User Icon">
    <p class="profil">You</p>
    <input id="updated_email" type="email" :placeholder="email" v-model="updated_email" @input="validateEmail">
    <input id="updated_username" type="text" :placeholder="username" v-model="updated_username">
    <button @click="updateUser" class="centered-text btn btn-primary">Update informations</button>
    <p v-if="emailError" class="error">Veuillez saisir une adresse email valide.</p>
  </div>
</template>

<style>
.centered-content {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

img {
  width: 80px;
  height: 80px;
}

input {
  width: 80%;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 5px
}

.profil {
  margin-bottom: 20px;
}

Button {
  margin-top: 10px
}

.error {
  color: red;
  font-size: 14px;
  margin-top: 5px;
}
</style>