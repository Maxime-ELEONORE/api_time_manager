<script setup lang="ts">
import type {WorkingTimeInterface} from '@/models/WorkingTimeInterface';
import type {UserInterface} from '@/models/UserInterface';
import WorkingTime from '@/components/working-time.vue';
import User from '@/components/user.vue';

let user: UserInterface = { id: 1, username: 'user', email: 'email' } as UserInterface;
let workingTime: WorkingTimeInterface = { start: new Date().toString(), end: new Date().toString(), user: user, id: 14 } as WorkingTimeInterface;
</script>

<template>
  <div class="about">
    <h1>This is an about page</h1>
    <p>Hello</p>
    <User />
    <WorkingTime :user="user" :workingTime="workingTime" />
  </div>
</template>

<style>
@media (min-width: 1024px) {
  .about {
    display: flex;
    align-items: center;
  }
}
</style>