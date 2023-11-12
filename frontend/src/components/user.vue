<template>
  <Toast/>
  <ConfirmDialog/>
  <DynamicDialog/>
  <div class="flex justify-content-center align-items-center mb-5 max-w-full">
    <InputText type="text" placeholder="Search" class="mr-5" v-model="value" v-on:input="filter"/>
  </div>
  <div class="max-w-full">
    <DataTable :value="usersDisplay"
               paginator
               :rows="5"
               :rowsPerPageOptions="[5, 10, 20, 50]">
      <template #header>
        <div class="flex flex-wrap align-items-center justify-content-between gap-2">
          <span class="text-xl text-900 font-bold">Users management</span>
          <Button class="border-circle" icon="pi pi-user-plus" raised @click="showAddUserComponent"/>
        </div>
      </template>
      <Column v-for="col of columns" sortable :key="col.field" :field="col.field" :header="col.header"></Column>
      <Column header="Actions">
        <template #body="slotProps">
          <div class="flex gap-4">
            <Button icon="pi pi-pencil" class="p-button-rounded p-button-plain p-mr-2"
                    @click="showEditUserComponent(slotProps.data)"/>
            <Button icon="pi pi-trash" class="p-button-rounded p-button-danger" @click="openDeleteDialog(slotProps.data)"/>
          </div>
        </template>
      </Column>
    </DataTable>
  </div>
</template>

<script lang="ts">
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import DataTable from "primevue/datatable";
import Column from "primevue/column";
import UserRepository from "@/repositories/user.repository";
import type {UserInterface} from "@/models/UserInterface";
import Toast from "primevue/toast";
import ConfirmDialog from "primevue/confirmdialog";
import {useConfirm} from "primevue/useconfirm";
import {useToast} from "primevue/usetoast";
import {useDialog} from "primevue/usedialog";
import CreateUser from "@/components/CreateUser.vue";
import DynamicDialog from "primevue/dynamicdialog";

export default {
  components: {
    Button,
    InputText,
    DataTable,
    Column,
    Toast,
    ConfirmDialog,
    DynamicDialog
  },
  data() {
    return {
      value: '',
      users: [],
      usersDisplay: [],
      columns: [
        {field: 'username', header: 'Username'},
        {field: 'email', header: 'Email'},
        {field: 'role', header: 'Role'}
      ],
      confirm: useConfirm(),
      toast: useToast(),
      dialog: useDialog(),
      openDeleteDialog: (user) => {
        this.confirm.require({
          message: 'Are you sure you want to delete this user?',
          header: 'Confirmation',
          icon: 'pi pi-exclamation-triangle',
          accept: () => {
            UserRepository.deleteUser(user.id).then(() => {
              this.toast.add({
                severity: 'success',
                summary: 'Success',
                detail: 'User deleted successfully',
              });
              this.fetchUsers();
            }).catch(() => {
              this.toast.add({
                severity: 'error',
                summary: 'Error',
                detail: 'An error occurred while deleting the user',
              });
            });
          },
          reject: () => {
            this.toast.add({
              severity: 'info',
              summary: 'Rejected',
              detail: 'You have rejected',
            });
          }
        });
      },
    };
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    filter() {
      this.usersDisplay = this.users.filter((user: UserInterface) => {
        if (this.value.trim() === '' || !this.value) {
          return true;
        }
        return user.username.includes(this.value) || user.email.includes(this.value);
      });
    },
    showAddUserComponent(): void {
      const dialogRef = this.dialog.open(CreateUser,
          {
            props: {
              header: 'Create user',
              modal: true
            },
            onClose: (user) => {
              if (user.data) {
                this.createUser(user as UserInterface);
              }
            }
          });
    },
    showEditUserComponent(user: UserInterface): void {
      const dialogRef = this.dialog.open(CreateUser,
          {
            props: {
              header: 'Modify user',
              modal: true
            },
            data: user,
            onClose: (user) => {
              if (user.data) {
                this.updateUser(user as UserInterface);
              }
            }
          });
    },
    fetchUsers() {
      UserRepository.fetchUsers().then((response: any) => {
        this.users = response.data.data as UserInterface[];
        this.filter();
      });
    },
    createUser(user) {
      UserRepository.createUser(user).then((user) => {
        if (user) {
          this.toast.add({
            severity: 'success',
            summary: 'Success',
            detail: 'User created'
          })
        }
        this.fetchUsers();
      }).catch(() => {
        this.toast.add({
          severity: 'error',
          summary: 'Error',
          detail: 'An error occurred while creating the user',
        });
      });
    },
    updateUser(user) {
      UserRepository.updateUser(user).then((user) => {
        if (user) {
          this.toast.add({
            severity: 'success',
            summary: 'Success',
            detail: 'User updated'
          })
        }
        this.fetchUsers();
      }).catch(() => {
        this.toast.add({
          severity: 'error',
          summary: 'Error',
          detail: 'An error occurred while updating the user',
        });
      });
    }
  }
};
</script>