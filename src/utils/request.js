import axios from 'axios';

// 创建 axios 实例
const instance = axios.create({
  baseURL: '', // 可以在这里设置基础 URL
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
});

// 请求拦截器
instance.interceptors.request.use(
  (config) => {
    // 在这里可以添加 token 等
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 响应拦截器
instance.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    console.error('请求错误:', error.message);
    return Promise.reject(error);
  }
);

/**
 * 封装请求方法
 * @param {string} url - 请求地址
 * @param {object} options - 配置选项
 * @param {string} options.method - 请求方法: GET, POST, PUT, DELETE 等
 * @param {object} options.params - URL 查询参数
 * @param {object} options.data - 请求体数据 (POST/PUT)
 * @param {object} options.headers - 自定义请求头
 * @returns {Promise} - 返回响应数据
 */
export function request(url, options = {}) {
  const { method = 'GET', params = null, data = null, headers = {} } = options;

  return instance({
    url,
    method,
    params,
    data,
    headers
  });
}

export default instance;
