<template>
  <div class="hello-world">
    <h2>{{ msg }}</h2>
    <div class="counter-section">
      <p>当前计数: <span class="count">{{ count }}</span></p>
      <div class="buttons">
        <button @click="decrement" class="btn btn-secondary">-</button>
        <button @click="increment" class="btn btn-primary">+</button>
      </div>
    </div>
    <div class="api-section">
      <h3>API 请求示例</h3>
      <div class="api-buttons">
        <button @click="testGet" class="btn btn-api">GET 请求</button>
        <button @click="testPost" class="btn btn-api">POST 请求</button>
      </div>
      <div v-if="loading" class="loading">加载中...</div>
      <div v-if="apiResult" class="api-result">
        <pre>{{ apiResult }}</pre>
      </div>
    </div>
    <div class="features">
      <h3>项目特性</h3>
      <ul>
        <li>Vue 3 组合式 API</li>
        <li>Webpack 5 打包工具</li>
        <li>Babel 转译</li>
        <li>热更新 (HMR)</li>
        <li>Axios 网络请求封装</li>
      </ul>
    </div>
  </div>
</template>

<script>
import { ref, getCurrentInstance } from 'vue';

export default {
  name: 'HelloWorld',
  setup() {
    const msg = '欢迎使用 Vue 3 + Webpack';
    const count = ref(0);
    const loading = ref(false);
    const apiResult = ref(null);

    // 获取全局属性
    const { proxy } = getCurrentInstance();

    const increment = () => {
      count.value++;
    };

    const decrement = () => {
      count.value--;
    };

    // GET 请求示例
    const testGet = async () => {
      loading.value = true;
      apiResult.value = null;
      try {
        // 使用 this.$request 调用
        const res = await proxy.$request('https://jsonplaceholder.typicode.com/posts/1', {
          method: 'GET'
        });
        apiResult.value = JSON.stringify(res, null, 2);
      } catch (error) {
        apiResult.value = '请求失败: ' + error.message;
      } finally {
        loading.value = false;
      }
    };

    // POST 请求示例
    const testPost = async () => {
      loading.value = true;
      apiResult.value = null;
      try {
        // 使用 this.$request 调用
        const res = await proxy.$request('https://jsonplaceholder.typicode.com/posts', {
          method: 'POST',
          data: {
            title: '测试标题',
            body: '测试内容',
            userId: 1
          }
        });
        apiResult.value = JSON.stringify(res, null, 2);
      } catch (error) {
        apiResult.value = '请求失败: ' + error.message;
      } finally {
        loading.value = false;
      }
    };

    return {
      msg,
      count,
      loading,
      apiResult,
      increment,
      decrement,
      testGet,
      testPost
    };
  }
};
</script>

<style scoped>
.hello-world {
  text-align: center;
}

h2 {
  color: #333;
  margin-bottom: 30px;
  font-size: 1.5rem;
}

.counter-section {
  background: #f8f9fa;
  padding: 30px;
  border-radius: 12px;
  margin-bottom: 30px;
}

.count {
  font-size: 2.5rem;
  font-weight: bold;
  color: #667eea;
}

.buttons {
  margin-top: 20px;
  display: flex;
  gap: 15px;
  justify-content: center;
}

.btn {
  padding: 12px 30px;
  font-size: 1.2rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary {
  background: #667eea;
  color: white;
}

.btn-primary:hover {
  background: #5568d3;
  transform: translateY(-2px);
}

.btn-secondary {
  background: #764ba2;
  color: white;
}

.btn-secondary:hover {
  background: #653a91;
  transform: translateY(-2px);
}

.api-section {
  background: #f0f7ff;
  padding: 20px;
  border-radius: 12px;
  margin-bottom: 30px;
}

.api-section h3 {
  color: #333;
  margin-bottom: 15px;
}

.api-buttons {
  display: flex;
  gap: 15px;
  justify-content: center;
  margin-bottom: 15px;
}

.btn-api {
  background: #28a745;
  color: white;
  padding: 10px 20px;
  font-size: 1rem;
}

.btn-api:hover {
  background: #218838;
  transform: translateY(-2px);
}

.loading {
  color: #667eea;
  font-size: 1rem;
}

.api-result {
  background: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 15px;
  text-align: left;
  max-height: 200px;
  overflow: auto;
}

.api-result pre {
  margin: 0;
  font-size: 0.85rem;
  color: #333;
}

.features {
  text-align: left;
}

.features h3 {
  color: #333;
  margin-bottom: 15px;
  font-size: 1.1rem;
}

.features ul {
  list-style: none;
  padding: 0;
}

.features li {
  padding: 8px 0;
  color: #666;
  position: relative;
  padding-left: 25px;
}

.features li::before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #667eea;
  font-weight: bold;
}
</style>
