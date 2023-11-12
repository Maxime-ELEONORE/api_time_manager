import {createApp} from 'vue'
import {createPinia} from 'pinia'
import PrimeVue from 'primevue/config';
import 'primevue/resources/primevue.min.css';
import 'primevue/resources/themes/fluent-light/theme.css';
import 'primeflex/primeflex.css';
import 'primeicons/primeicons.css';
import 'bootstrap/dist/css/bootstrap.css'
import App from './App.vue';
import router from './router';
import 'bootstrap/dist/js/bootstrap.js'
import ConfirmationService from 'primevue/confirmationservice';
import ToastService from 'primevue/toastservice';
import DialogService from 'primevue/dialogservice';

const app = createApp(App);
app.use(PrimeVue);
app.use(createPinia());
app.use(router);
app.use(ConfirmationService);
app.use(ToastService);
app.use(DialogService);
app.mount('#app');

import 'bootstrap/dist/js/bootstrap.js'