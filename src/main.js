import { createApp } from 'vue';
import App from './App.vue';
import { request } from './utils/request';

const app = createApp(App);

// 全局挂载 request 方法
app.config.globalProperties.$request = request;

app.mount('#app');
