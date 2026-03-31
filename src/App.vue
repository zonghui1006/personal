<template>
  <div class="portfolio">
    <!-- WebGL 星空背景 -->
    <canvas ref="starCanvas" class="star-bg"></canvas>

    <!-- 加载动画 -->
    <div class="loader" v-if="loading">
      <div class="loader-ring"></div>
      <span>Loading...</span>
    </div>

    <!-- 导航 -->
    <nav class="navbar" :class="{ 'navbar-scrolled': scrolled, 'navbar-hidden': hiddenNav }">
      <div class="nav-brand">
        <span class="brand-text">宗辉</span>
        <span class="brand-dot"></span>
      </div>
      <div class="nav-links" :class="{ 'nav-open': navOpen }">
        <a v-for="item in navItems" :key="item.id"
           @click="scrollTo(item.id); navOpen = false"
           :class="{ active: activeSection === item.id }">
          {{ item.name }}
        </a>
      </div>
      <div class="nav-toggle" @click="navOpen = !navOpen" :class="{ active: navOpen }">
        <span></span>
        <span></span>
        <span></span>
      </div>
    </nav>

    <!-- Hero 区域 - 3D 视差效果 -->
    <section id="hero" class="hero">
      <div class="hero-3d-container">
        <div class="floating-shapes">
          <div class="shape shape-1"></div>
          <div class="shape shape-2"></div>
          <div class="shape shape-3"></div>
          <div class="shape shape-4"></div>
        </div>
      </div>
      <div class="hero-content">
        <div class="hero-badge">
          <span class="badge-pulse"></span>
          <span>Available for hire</span>
        </div>
        <h1 class="hero-title">
          <span class="title-line" v-for="(line, i) in titleLines" :key="i" :style="{ '--delay': i * 0.1 + 's' }">
            {{ line }}
          </span>
        </h1>
        <div class="hero-role">
          <span class="role-prefix">I'm a</span>
          <span class="role-text">{{ currentRole }}</span>
          <span class="role-cursor">|</span>
        </div>
        <p class="hero-desc">
          十年前端开发经验，专注于创造极致用户体验。
          从 iOS 原生到跨平台，从 Web 到移动端，全栈技术视野。
        </p>
        <div class="hero-actions">
          <button class="btn btn-primary btn-glow" @click="scrollTo('projects')">
            <span>查看作品</span>
            <svg class="btn-icon" viewBox="0 0 24 24"><path d="M7 17L17 7M17 7H7M17 7V17"/></svg>
          </button>
          <button class="btn btn-secondary" @click="scrollTo('contact')">
            <span>联系我</span>
          </button>
        </div>
        <div class="hero-stats">
          <div class="stat-item" v-for="(stat, i) in stats" :key="i" :style="{ '--delay': i * 0.1 + 's' }">
            <div class="stat-value">
              <span class="stat-number" :data-target="stat.number">{{ stat.display }}</span>
              <span class="stat-suffix">{{ stat.suffix }}</span>
            </div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
      </div>
      <div class="scroll-hint">
        <div class="mouse">
          <div class="wheel"></div>
        </div>
        <span>Scroll</span>
      </div>
    </section>

    <!-- 关于我 - 时间线卡片 -->
    <section id="about" class="about">
      <div class="container">
        <div class="section-header">
          <span class="section-tag">About Me</span>
          <h2 class="section-title">关于我</h2>
          <p class="section-desc">技术为艺术服务，代码为体验而生</p>
        </div>
        <div class="about-grid">
          <div class="about-card main-card" ref="aboutCard">
            <div class="card-glow"></div>
            <div class="card-content">
              <div class="avatar-wrapper">
                <div class="avatar">
                  <span>ZH</span>
                </div>
                <div class="avatar-ring"></div>
              </div>
              <h3>宗辉</h3>
              <p class="title">高级前端工程师</p>
              <p class="bio">
                热爱技术的创造者，专注于前端工程化与用户体验设计。
                擅长 React、Vue、React Native 等技术栈，
                有丰富的大型项目架构经验。
              </p>
              <div class="location">
                <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/></svg>
                <span>北京，中国</span>
              </div>
            </div>
          </div>
          <div class="about-cards">
            <div class="about-item" v-for="(item, i) in aboutItems" :key="i">
              <div class="item-icon">{{ item.icon }}</div>
              <h4>{{ item.title }}</h4>
              <p>{{ item.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 技能展示 - 3D 卡片云 -->
    <section id="skills" class="skills">
      <div class="container">
        <div class="section-header light">
          <span class="section-tag">Skills</span>
          <h2 class="section-title">技术栈</h2>
          <p class="section-desc">全栈技术视野，持续学习进化</p>
        </div>
        <div class="skills-visual">
          <div class="skill-orbit">
            <div class="skill-core">
              <span>Frontend</span>
            </div>
            <div class="skill-satellites">
              <div class="satellite" v-for="(skill, i) in orbitSkills" :key="i" :style="{ '--orbit': i, '--total': orbitSkills.length }">
                <span>{{ skill }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="skills-detailed">
          <div class="skill-category" v-for="(cat, i) in skillCategories" :key="i">
            <h3 class="category-title">
              <span class="cat-icon">{{ cat.icon }}</span>
              {{ cat.name }}
            </h3>
            <div class="skill-list">
              <div class="skill-bar-item" v-for="(skill, j) in cat.skills" :key="j">
                <div class="skill-info">
                  <span class="skill-name">{{ skill.name }}</span>
                  <span class="skill-percent">{{ skill.level }}%</span>
                </div>
                <div class="skill-progress-bar">
                  <div class="skill-fill" :style="{ width: skill.level + '%', '--level': skill.level }">
                    <div class="skill-shine"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 项目展示 - 瀑布流画廊 -->
    <section id="projects" class="projects">
      <div class="container">
        <div class="section-header">
          <span class="section-tag">Portfolio</span>
          <h2 class="section-title">项目作品</h2>
          <p class="section-desc">精选项目，展现技术实力</p>
        </div>
        <div class="project-filters">
          <button v-for="filter in projectFilters" :key="filter"
                  :class="{ active: activeFilter === filter }"
                  @click="activeFilter = filter">
            {{ filter }}
          </button>
        </div>
        <div class="projects-grid">
          <div class="project-card" v-for="(project, i) in filteredProjects" :key="i"
               :class="{ 'featured': project.featured }"
               @mouseenter="project.hover = true"
               @mouseleave="project.hover = false">
            <div class="project-image">
              <div class="project-placeholder" :style="{ background: project.gradient }">
                <span class="project-icon">{{ project.icon }}</span>
              </div>
              <div class="project-overlay">
                <div class="project-links">
                  <a :href="project.demo" target="_blank" class="link-btn" v-if="project.demo">
                    <svg viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                    预览
                  </a>
                  <a :href="project.code" target="_blank" class="link-btn" v-if="project.code">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.09-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.65-.33 2.5-.33.85 0 1.71.11 2.5.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0012 2z"/></svg>
                    代码
                  </a>
                </div>
              </div>
            </div>
            <div class="project-info">
              <h3>{{ project.name }}</h3>
              <p>{{ project.desc }}</p>
              <div class="project-tags">
                <span v-for="tag in project.tags" :key="tag">{{ tag }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 工作经历 - 时间轴 -->
    <section id="experience" class="experience">
      <div class="container">
        <div class="section-header">
          <span class="section-tag">Experience</span>
          <h2 class="section-title">工作经历</h2>
          <p class="section-desc">十年技术沉淀，持续成长</p>
        </div>
        <div class="timeline-container">
          <div class="timeline-line"></div>
          <div class="timeline-items">
            <div class="timeline-item" v-for="(item, i) in experiences" :key="i"
                 :class="{ 'item-left': i % 2 === 0, 'item-right': i % 2 === 1 }">
              <div class="timeline-dot">
                <div class="dot-pulse"></div>
              </div>
              <div class="timeline-card">
                <div class="card-period">{{ item.period }}</div>
                <h3 class="card-title">{{ item.title }}</h3>
                <p class="card-company">{{ item.company }}</p>
                <p class="card-desc">{{ item.desc }}</p>
                <div class="card-tags">
                  <span v-for="tag in item.tags" :key="tag">{{ tag }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 联系区域 - 增强版 -->
    <section id="contact" class="contact">
      <div class="container">
        <div class="section-header light">
          <span class="section-tag">Contact</span>
          <h2 class="section-title">联系我</h2>
          <p class="section-desc">有项目想法？ let's talk</p>
        </div>
        <div class="contact-wrapper">
          <div class="contact-info-cards">
            <div class="info-card" v-for="(contact, i) in contactInfo" :key="i" @click="handleContact(contact)">
              <div class="info-icon">{{ contact.icon }}</div>
              <h4>{{ contact.title }}</h4>
              <p>{{ contact.value }}</p>
              <div class="info-arrow">→</div>
            </div>
          </div>
          <div class="contact-form-wrapper">
            <form class="contact-form" @submit.prevent="submitForm">
              <div class="form-row">
                <div class="form-group">
                  <input type="text" v-model="form.name" required placeholder=" " />
                  <label>您的姓名</label>
                </div>
                <div class="form-group">
                  <input type="email" v-model="form.email" required placeholder=" " />
                  <label>您的邮箱</label>
                </div>
              </div>
              <div class="form-group">
                <input type="text" v-model="form.subject" required placeholder=" " />
                <label>主题</label>
              </div>
              <div class="form-group">
                <textarea v-model="form.message" rows="5" required placeholder=" "></textarea>
                <label>内容</label>
              </div>
              <button type="submit" class="btn btn-submit" :disabled="form.submitting">
                <span>{{ form.submitting ? '发送中...' : '发送消息' }}</span>
                <svg viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
              </button>
            </form>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-brand">
            <span>宗辉</span>
            <p>用代码创造价值</p>
          </div>
          <div class="footer-links">
            <a v-for="link in footerLinks" :key="link.name" @click="scrollTo(link.id)">{{ link.name }}</a>
          </div>
          <div class="footer-social">
            <a v-for="social in socials" :key="social.name" :href="social.url" target="_blank">
              {{ social.icon }}
            </a>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; {{ currentYear }} 宗辉. All Rights Reserved.</p>
          <p>Made with ❤️ and Vue.js</p>
        </div>
      </div>
    </footer>

    <!-- Toast 提示 -->
    <div class="toast" :class="{ show: toast.show, success: toast.type === 'success', error: toast.type === 'error' }">
      {{ toast.message }}
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted, computed, reactive } from 'vue';

export default {
  name: 'App',
  setup() {
    // 状态
    const loading = ref(true);
    const scrolled = ref(false);
    const hiddenNav = ref(false);
    const navOpen = ref(false);
    const activeSection = ref('hero');
    const starCanvas = ref(null);
    let lastScrollY = 0;

    // 导航
    const navItems = [
      { name: '首页', id: 'hero' },
      { name: '关于', id: 'about' },
      { name: '技能', id: 'skills' },
      { name: '项目', id: 'projects' },
      { name: '经历', id: 'experience' },
      { name: '联系', id: 'contact' }
    ];

    // Hero 标题
    const titleLines = ['Creative', 'Frontend', 'Developer'];
    const currentRole = ref('');
    const roles = ['Frontend Engineer', 'React Native Expert', 'UI/UX Designer', 'Full Stack Developer'];
    let roleIndex = 0;

    // 统计数据
    const stats = ref([
      { number: 10, suffix: '+', label: '年经验', display: 0 },
      { number: 50, suffix: '+', label: '完成项目', display: 0 },
      { number: 100, suffix: 'K+', label: '代码行数', display: 0 },
      { number: 30, suffix: '+', label: '技术栈', display: 0 }
    ]);

    // 关于我
    const aboutItems = [
      { icon: '🎯', title: '专注前端', desc: '10年深耕前端领域，精通React、Vue、React Native' },
      { icon: '🚀', title: '技术驱动', desc: '主导多个大型项目架构设计，推动团队工程化建设' },
      { icon: '💡', title: '创新思维', desc: '善于解决复杂技术难题，持续探索前沿技术' },
      { icon: '🤝', title: '团队协作', desc: '优秀的沟通协调能力，带领团队高效交付' }
    ];

    // 轨道技能
    const orbitSkills = ['React', 'Vue', 'RN', 'TS', 'Node', 'Webpack', 'Git', 'Docker'];

    // 详细技能
    const skillCategories = [
      {
        name: '前端核心',
        icon: '⚛️',
        skills: [
          { name: 'JavaScript / TypeScript', level: 95 },
          { name: 'React / Next.js', level: 92 },
          { name: 'Vue.js / Nuxt.js', level: 90 },
          { name: 'React Native', level: 88 },
          { name: 'HTML5 / CSS3', level: 95 }
        ]
      },
      {
        name: '工程化',
        icon: '🛠️',
        skills: [
          { name: 'Webpack / Vite / Rollup', level: 90 },
          { name: 'Git / CI/CD / DevOps', level: 85 },
          { name: 'Jest / Testing Library', level: 80 },
          { name: 'Docker / K8s', level: 70 }
        ]
      },
      {
        name: 'UI/设计',
        icon: '🎨',
        skills: [
          { name: 'Tailwind / Sass / Less', level: 92 },
          { name: 'Framer Motion / GSAP', level: 85 },
          { name: 'Three.js / WebGL', level: 70 },
          { name: 'Figma / Sketch', level: 80 }
        ]
      }
    ];

    // 项目筛选
    const projectFilters = ['全部', 'Web应用', '移动端', '开源项目'];
    const activeFilter = ref('全部');

    const projects = ref([
      {
        name: '企业级管理后台',
        desc: '大型电商后台管理系统，支持多租户、权限管理、数据可视化',
        tags: ['React', 'Ant Design', 'TypeScript'],
        gradient: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        icon: '📊',
        category: 'Web应用',
        featured: true,
        demo: '#',
        code: '#'
      },
      {
        name: '社交App',
        desc: '基于 React Native 的社交平台，支持即时通讯、动态发布',
        tags: ['React Native', 'Redux', 'Socket.io'],
        gradient: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
        icon: '💬',
        category: '移动端',
        demo: '#',
        code: '#'
      },
      {
        name: '个人组件库',
        desc: '开源 UI 组件库，提供 50+ 高质量 React 组件',
        tags: ['React', 'Rollup', 'Storybook'],
        gradient: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
        icon: '📦',
        category: '开源项目',
        demo: '#',
        code: '#'
      },
      {
        name: '在线教育平台',
        desc: '支持直播、录播、互动答题的综合教育平台',
        tags: ['Vue 3', 'WebRTC', 'Node.js'],
        gradient: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
        icon: '🎓',
        category: 'Web应用',
        demo: '#',
        code: '#'
      },
      {
        name: '跨境电商小程序',
        desc: 'Taro 开发的跨境电商小程序，支持多语言、多币种',
        tags: ['Taro', 'TypeScript', 'GraphQL'],
        gradient: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
        icon: '🛒',
        category: '移动端',
        demo: '#',
        code: '#'
      },
      {
        name: '可视化大屏',
        desc: '基于 Three.js 的 3D 数据可视化大屏，实时数据展示',
        tags: ['Three.js', 'D3.js', 'WebSocket'],
        gradient: 'linear-gradient(135deg, #30cfd0 0%, #330867 100%)',
        icon: '📈',
        category: 'Web应用',
        demo: '#',
        code: '#'
      }
    ]);

    const filteredProjects = computed(() => {
      if (activeFilter.value === '全部') return projects.value;
      return projects.value.filter(p => p.category === activeFilter.value);
    });

    // 工作经历
    const experiences = [
      {
        period: '2024 - 至今',
        title: '高级前端工程师',
        company: '某互联网大厂',
        desc: '负责核心产品前端架构设计，带领10人团队完成微前端改造',
        tags: ['React', 'Micro-Frontend', '性能优化']
      },
      {
        period: '2020 - 2024',
        title: '前端技术负责人',
        company: '某科技公司',
        desc: '从0到1搭建前端团队，制定开发规范，推动工程化建设',
        tags: ['Vue', 'React Native', 'CI/CD']
      },
      {
        period: '2018 - 2020',
        title: '移动端开发工程师',
        company: '某创业公司',
        desc: '负责多个App的开发和维护，完成React Native技术转型',
        tags: ['iOS', 'React Native', 'Swift']
      },
      {
        period: '2016 - 2018',
        title: 'iOS开发工程师',
        company: '某软件公司',
        desc: '开发多个上线App，累计用户超过100万',
        tags: ['Objective-C', 'Swift', 'UIKit']
      }
    ];

    // 联系信息
    const contactInfo = [
      { icon: '📧', title: '邮箱', value: 'zonghui1006@163.com', type: 'email' },
      { icon: '📱', title: '微信', value: 'zonghui1006', type: 'wechat' },
      { icon: '💼', title: 'GitHub', value: 'github.com/zonghui1006', type: 'link' },
      { icon: '📍', title: '位置', value: '北京，中国', type: 'location' }
    ];

    // 表单
    const form = reactive({
      name: '',
      email: '',
      subject: '',
      message: '',
      submitting: false
    });

    // Toast
    const toast = reactive({
      show: false,
      message: '',
      type: 'success'
    });

    // Footer
    const footerLinks = [
      { name: '首页', id: 'hero' },
      { name: '关于', id: 'about' },
      { name: '项目', id: 'projects' },
      { name: '联系', id: 'contact' }
    ];

    const socials = [
      { name: 'GitHub', icon: 'gh', url: '#' },
      { name: 'LinkedIn', icon: 'in', url: '#' },
      { name: 'Twitter', icon: 'tw', url: '#' }
    ];

    const currentYear = new Date().getFullYear();

    // 方法
    const showToast = (message, type = 'success') => {
      toast.message = message;
      toast.type = type;
      toast.show = true;
      setTimeout(() => toast.show = false, 3000);
    };

    const scrollTo = (id) => {
      const element = document.getElementById(id);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth' });
      }
    };

    const handleContact = (contact) => {
      if (contact.type === 'email') {
        window.location.href = `mailto:${contact.value}`;
      } else if (contact.type === 'wechat') {
        navigator.clipboard?.writeText(contact.value);
        showToast('微信号已复制！');
      } else if (contact.type === 'link') {
        window.open(`https://${contact.value}`, '_blank');
      }
    };

    const submitForm = async () => {
      form.submitting = true;
      // 模拟发送
      await new Promise(r => setTimeout(r, 1500));
      showToast('消息已发送！');
      form.name = form.email = form.subject = form.message = '';
      form.submitting = false;
    };

    // 星空背景
    const initStarField = () => {
      const canvas = starCanvas.value;
      if (!canvas) return;

      const ctx = canvas.getContext('2d');
      const resize = () => {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
      };
      resize();

      const stars = [];
      for (let i = 0; i < 150; i++) {
        stars.push({
          x: Math.random() * canvas.width,
          y: Math.random() * canvas.height,
          size: Math.random() * 2,
          speed: Math.random() * 0.5 + 0.1,
          opacity: Math.random()
        });
      }

      let animationId;
      const animate = () => {
        ctx.fillStyle = 'rgba(26, 26, 46, 0.1)';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        stars.forEach(star => {
          star.y -= star.speed;
          if (star.y < 0) star.y = canvas.height;

          ctx.beginPath();
          ctx.arc(star.x, star.y, star.size, 0, Math.PI * 2);
          ctx.fillStyle = `rgba(255, 255, 255, ${star.opacity})`;
          ctx.fill();
        });

        animationId = requestAnimationFrame(animate);
      };
      animate();

      window.addEventListener('resize', resize);
      return () => {
        cancelAnimationFrame(animationId);
        window.removeEventListener('resize', resize);
      };
    };

    // 角色打字机效果
    const typeRole = () => {
      const role = roles[roleIndex];
      let i = 0;
      currentRole.value = '';

      const type = () => {
        if (i < role.length) {
          currentRole.value += role[i];
          i++;
          setTimeout(type, 100);
        } else {
          setTimeout(() => {
            roleIndex = (roleIndex + 1) % roles.length;
            typeRole();
          }, 3000);
        }
      };
      type();
    };

    // 数字动画
    const animateNumbers = () => {
      stats.value.forEach(stat => {
        let current = 0;
        const increment = stat.number / 50;
        const timer = setInterval(() => {
          current += increment;
          if (current >= stat.number) {
            stat.display = stat.number;
            clearInterval(timer);
          } else {
            stat.display = Math.floor(current);
          }
        }, 30);
      });
    };

    // 滚动监听
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      scrolled.value = currentScrollY > 50;
      hiddenNav.value = currentScrollY > lastScrollY && currentScrollY > 200;
      lastScrollY = currentScrollY;

      // 更新活跃区域
      navItems.forEach(item => {
        const element = document.getElementById(item.id);
        if (element) {
          const rect = element.getBoundingClientRect();
          if (rect.top <= 100 && rect.bottom >= 100) {
            activeSection.value = item.id;
          }
        }
      });
    };

    onMounted(() => {
      setTimeout(() => loading.value = false, 1500);
      initStarField();
      typeRole();
      setTimeout(animateNumbers, 2000);
      window.addEventListener('scroll', handleScroll, { passive: true });
    });

    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll);
    });

    return {
      loading, scrolled, hiddenNav, navOpen, activeSection,
      starCanvas, navItems, titleLines, currentRole, stats,
      aboutItems, orbitSkills, skillCategories,
      projectFilters, activeFilter, filteredProjects,
      experiences, contactInfo, form, toast,
      footerLinks, socials, currentYear,
      scrollTo, handleContact, submitForm
    };
  }
};
</script>

<style>
/* 基础样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  --primary: #667eea;
  --secondary: #764ba2;
  --accent: #f093fb;
  --dark: #1a1a2e;
  --light: #ffffff;
  --gray: #8892b0;
  --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --gradient-2: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

html {
  scroll-behavior: smooth;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
  background: var(--dark);
  color: var(--light);
  line-height: 1.6;
  overflow-x: hidden;
}

/* 加载动画 */
.loader {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--dark);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  gap: 20px;
}

.loader-ring {
  width: 60px;
  height: 60px;
  border: 3px solid rgba(102, 126, 234, 0.3);
  border-top-color: var(--primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* 星空背景 */
.star-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
  pointer-events: none;
}

/* 导航 */
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 50px;
  z-index: 1000;
  transition: all 0.3s ease;
}

.navbar-scrolled {
  background: rgba(26, 26, 46, 0.9);
  backdrop-filter: blur(10px);
  padding: 15px 50px;
}

.navbar-hidden {
  transform: translateY(-100%);
}

.nav-brand {
  display: flex;
  align-items: center;
  gap: 8px;
}

.brand-text {
  font-size: 1.8rem;
  font-weight: bold;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.brand-dot {
  width: 8px;
  height: 8px;
  background: var(--primary);
  border-radius: 50%;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(1.5); }
}

.nav-links {
  display: flex;
  gap: 40px;
}

.nav-links a {
  color: var(--light);
  text-decoration: none;
  font-size: 0.95rem;
  font-weight: 500;
  position: relative;
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 0.3s;
}

.nav-links a:hover,
.nav-links a.active {
  opacity: 1;
}

.nav-links a::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--gradient);
  transition: width 0.3s;
}

.nav-links a:hover::after,
.nav-links a.active::after {
  width: 100%;
}

.nav-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  cursor: pointer;
  z-index: 1001;
}

.nav-toggle span {
  width: 25px;
  height: 2px;
  background: var(--light);
  transition: all 0.3s;
}

.nav-toggle.active span:nth-child(1) {
  transform: rotate(45deg) translate(5px, 5px);
}

.nav-toggle.active span:nth-child(2) {
  opacity: 0;
}

.nav-toggle.active span:nth-child(3) {
  transform: rotate(-45deg) translate(5px, -5px);
}

/* Hero */
.hero {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 100px 50px;
  position: relative;
  overflow: hidden;
}

.hero-3d-container {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  perspective: 1000px;
}

.floating-shapes {
  position: relative;
  width: 100%;
  height: 100%;
}

.shape {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.3;
  animation: float 20s ease-in-out infinite;
}

.shape-1 {
  width: 400px;
  height: 400px;
  background: var(--primary);
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.shape-2 {
  width: 300px;
  height: 300px;
  background: var(--secondary);
  top: 60%;
  right: 10%;
  animation-delay: -5s;
}

.shape-3 {
  width: 250px;
  height: 250px;
  background: var(--accent);
  bottom: 10%;
  left: 30%;
  animation-delay: -10s;
}

.shape-4 {
  width: 350px;
  height: 350px;
  background: #43e97b;
  top: 30%;
  right: 30%;
  animation-delay: -15s;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25% { transform: translate(50px, -50px) scale(1.1); }
  50% { transform: translate(0, 50px) scale(0.9); }
  75% { transform: translate(-50px, -25px) scale(1.05); }
}

.hero-content {
  text-align: center;
  z-index: 1;
  max-width: 900px;
}

.hero-badge {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: rgba(102, 126, 234, 0.1);
  border: 1px solid rgba(102, 126, 234, 0.3);
  padding: 10px 20px;
  border-radius: 50px;
  font-size: 0.9rem;
  margin-bottom: 30px;
}

.badge-pulse {
  width: 8px;
  height: 8px;
  background: #43e97b;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.hero-title {
  font-size: 5rem;
  font-weight: 800;
  line-height: 1.1;
  margin-bottom: 20px;
}

.title-line {
  display: block;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: slideUp 0.8s ease forwards;
  animation-delay: var(--delay);
  opacity: 0;
  transform: translateY(30px);
}

@keyframes slideUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.hero-role {
  font-size: 1.5rem;
  margin-bottom: 20px;
  color: var(--gray);
}

.role-prefix {
  margin-right: 10px;
}

.role-text {
  color: var(--primary);
  font-weight: 600;
}

.role-cursor {
  animation: blink 1s infinite;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

.hero-desc {
  font-size: 1.2rem;
  color: var(--gray);
  max-width: 600px;
  margin: 0 auto 40px;
  line-height: 1.8;
}

.hero-actions {
  display: flex;
  gap: 20px;
  justify-content: center;
  margin-bottom: 60px;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 15px 35px;
  border-radius: 50px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  position: relative;
  overflow: hidden;
}

.btn-primary {
  background: var(--gradient);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 40px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: transparent;
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.btn-secondary:hover {
  border-color: var(--primary);
  background: rgba(102, 126, 234, 0.1);
}

.btn-icon {
  width: 20px;
  height: 20px;
  stroke: currentColor;
  stroke-width: 2;
  fill: none;
}

.hero-stats {
  display: flex;
  justify-content: center;
  gap: 60px;
  flex-wrap: wrap;
}

.stat-item {
  text-align: center;
  animation: fadeIn 0.6s ease forwards;
  animation-delay: var(--delay);
  opacity: 0;
}

@keyframes fadeIn {
  to { opacity: 1; }
}

.stat-value {
  font-size: 3rem;
  font-weight: 800;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.stat-suffix {
  font-size: 1.5rem;
}

.stat-label {
  color: var(--gray);
  font-size: 0.9rem;
  margin-top: 5px;
}

.scroll-hint {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  color: var(--gray);
  font-size: 0.85rem;
}

.mouse {
  width: 26px;
  height: 40px;
  border: 2px solid var(--gray);
  border-radius: 13px;
  position: relative;
}

.wheel {
  width: 4px;
  height: 8px;
  background: var(--primary);
  border-radius: 2px;
  position: absolute;
  top: 8px;
  left: 50%;
  transform: translateX(-50%);
  animation: scroll 2s infinite;
}

@keyframes scroll {
  0% { top: 8px; opacity: 1; }
  100% { top: 20px; opacity: 0; }
}

/* 通用区域 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 30px;
}

section {
  padding: 120px 0;
}

.section-header {
  text-align: center;
  margin-bottom: 80px;
}

.section-header.light {
  color: white;
}

.section-tag {
  display: inline-block;
  background: rgba(102, 126, 234, 0.1);
  color: var(--primary);
  padding: 8px 20px;
  border-radius: 50px;
  font-size: 0.85rem;
  font-weight: 600;
  margin-bottom: 20px;
}

.section-title {
  font-size: 3rem;
  font-weight: 800;
  margin-bottom: 20px;
}

.section-desc {
  color: var(--gray);
  font-size: 1.1rem;
  max-width: 500px;
  margin: 0 auto;
}

/* 关于我 */
.about {
  background: rgba(255, 255, 255, 0.02);
}

.about-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
}

.about-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 40px;
  position: relative;
  overflow: hidden;
}

.main-card {
  text-align: center;
}

.card-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
  pointer-events: none;
}

.avatar-wrapper {
  position: relative;
  display: inline-block;
  margin-bottom: 20px;
}

.avatar {
  width: 120px;
  height: 120px;
  background: var(--gradient);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 3rem;
  font-weight: bold;
}

.avatar-ring {
  position: absolute;
  top: -10px;
  left: -10px;
  right: -10px;
  bottom: -10px;
  border: 2px solid var(--primary);
  border-radius: 50%;
  animation: rotate 10s linear infinite;
}

@keyframes rotate {
  to { transform: rotate(360deg); }
}

.about-card h3 {
  font-size: 1.8rem;
  margin-bottom: 10px;
}

.about-card .title {
  color: var(--primary);
  font-weight: 600;
  margin-bottom: 20px;
}

.about-card .bio {
  color: var(--gray);
  line-height: 1.8;
  margin-bottom: 20px;
}

.location {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: var(--gray);
}

.location svg {
  width: 20px;
  height: 20px;
  fill: var(--primary);
}

.about-cards {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.about-item {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 30px;
  transition: all 0.3s;
}

.about-item:hover {
  transform: translateY(-5px);
  border-color: var(--primary);
}

.item-icon {
  font-size: 2.5rem;
  margin-bottom: 15px;
}

.about-item h4 {
  font-size: 1.2rem;
  margin-bottom: 10px;
}

.about-item p {
  color: var(--gray);
  font-size: 0.9rem;
  line-height: 1.6;
}

/* 技能 */
.skills-visual {
  display: flex;
  justify-content: center;
  margin-bottom: 80px;
}

.skill-orbit {
  position: relative;
  width: 400px;
  height: 400px;
}

.skill-core {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 120px;
  height: 120px;
  background: var(--gradient);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.9rem;
  z-index: 2;
}

.skill-satellites {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  animation: orbit 20s linear infinite;
}

.satellite {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(calc(var(--orbit) * 360deg / var(--total))) translateX(150px);
  background: rgba(255, 255, 255, 0.1);
  padding: 10px 20px;
  border-radius: 50px;
  font-size: 0.85rem;
  animation: counter-orbit 20s linear infinite;
}

@keyframes orbit {
  to { transform: rotate(360deg); }
}

@keyframes counter-orbit {
  to { transform: translate(-50%, -50%) rotate(calc(var(--orbit) * 360deg / var(--total) - 360deg)) translateX(150px); }
}

.skills-detailed {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
}

.skill-category {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 30px;
}

.category-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.3rem;
  margin-bottom: 30px;
}

.cat-icon {
  font-size: 1.5rem;
}

.skill-bar-item {
  margin-bottom: 25px;
}

.skill-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 0.9rem;
}

.skill-name {
  color: var(--gray);
}

.skill-percent {
  color: var(--primary);
  font-weight: 600;
}

.skill-progress-bar {
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
}

.skill-fill {
  height: 100%;
  background: var(--gradient);
  border-radius: 4px;
  position: relative;
  animation: fillBar 1.5s ease forwards;
}

@keyframes fillBar {
  from { width: 0; }
}

.skill-shine {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  animation: shine 2s infinite;
}

@keyframes shine {
  to { left: 100%; }
}

/* 项目 */
.projects {
  background: rgba(255, 255, 255, 0.02);
}

.project-filters {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-bottom: 50px;
  flex-wrap: wrap;
}

.project-filters button {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: var(--gray);
  padding: 10px 25px;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 0.9rem;
}

.project-filters button:hover,
.project-filters button.active {
  background: var(--gradient);
  border-color: transparent;
  color: white;
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
}

.project-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.3s;
}

.project-card:hover {
  transform: translateY(-10px);
  border-color: var(--primary);
}

.project-card.featured {
  grid-column: span 2;
}

.project-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.project-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 4rem;
}

.project-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(26, 26, 46, 0.9);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.project-card:hover .project-overlay {
  opacity: 1;
}

.project-links {
  display: flex;
  gap: 15px;
}

.link-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--gradient);
  color: white;
  padding: 10px 20px;
  border-radius: 50px;
  text-decoration: none;
  font-size: 0.9rem;
  transition: transform 0.3s;
}

.link-btn:hover {
  transform: scale(1.05);
}

.link-btn svg {
  width: 18px;
  height: 18px;
  fill: currentColor;
}

.project-info {
  padding: 25px;
}

.project-info h3 {
  font-size: 1.3rem;
  margin-bottom: 10px;
}

.project-info p {
  color: var(--gray);
  font-size: 0.9rem;
  line-height: 1.6;
  margin-bottom: 15px;
}

.project-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.project-tags span {
  background: rgba(102, 126, 234, 0.1);
  color: var(--primary);
  padding: 5px 12px;
  border-radius: 50px;
  font-size: 0.8rem;
}

/* 经历 */
.timeline-container {
  position: relative;
  max-width: 1000px;
  margin: 0 auto;
}

.timeline-line {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 2px;
  height: 100%;
  background: linear-gradient(to bottom, var(--primary), var(--secondary));
}

.timeline-items {
  position: relative;
}

.timeline-item {
  position: relative;
  width: 50%;
  padding: 20px 40px;
}

.timeline-item.item-right {
  margin-left: 50%;
}

.timeline-dot {
  position: absolute;
  width: 20px;
  height: 20px;
  background: var(--gradient);
  border-radius: 50%;
  top: 30px;
}

.item-left .timeline-dot {
  right: -10px;
}

.item-right .timeline-dot {
  left: -10px;
}

.dot-pulse {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  background: var(--primary);
  border-radius: 50%;
  animation: dotPulse 2s infinite;
}

@keyframes dotPulse {
  0% { transform: translate(-50%, -50%) scale(1); opacity: 1; }
  100% { transform: translate(-50%, -50%) scale(2); opacity: 0; }
}

.timeline-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 30px;
  transition: all 0.3s;
}

.timeline-card:hover {
  transform: scale(1.02);
  border-color: var(--primary);
}

.card-period {
  display: inline-block;
  background: var(--gradient);
  color: white;
  padding: 5px 15px;
  border-radius: 50px;
  font-size: 0.85rem;
  margin-bottom: 15px;
}

.card-title {
  font-size: 1.4rem;
  margin-bottom: 5px;
}

.card-company {
  color: var(--primary);
  font-weight: 600;
  margin-bottom: 10px;
}

.card-desc {
  color: var(--gray);
  font-size: 0.95rem;
  line-height: 1.6;
  margin-bottom: 15px;
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.card-tags span {
  background: rgba(255, 255, 255, 0.05);
  padding: 5px 12px;
  border-radius: 50px;
  font-size: 0.8rem;
}

/* 联系 */
.contact-wrapper {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
}

.contact-info-cards {
  display: grid;
  gap: 20px;
}

.info-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 15px;
  padding: 25px;
  display: flex;
  align-items: center;
  gap: 20px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.info-card:hover {
  transform: translateX(10px);
  border-color: var(--primary);
}

.info-icon {
  font-size: 2rem;
}

.info-card h4 {
  color: var(--gray);
  font-size: 0.9rem;
  margin-bottom: 5px;
}

.info-card p {
  font-size: 1.1rem;
}

.info-arrow {
  margin-left: auto;
  opacity: 0;
  transition: opacity 0.3s;
}

.info-card:hover .info-arrow {
  opacity: 1;
}

.contact-form-wrapper {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 40px;
}

.contact-form {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-group {
  position: relative;
}

.form-group input,
.form-group textarea {
  width: 100%;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  padding: 15px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: var(--primary);
  background: rgba(255, 255, 255, 0.08);
}

.form-group label {
  position: absolute;
  left: 15px;
  top: 15px;
  color: var(--gray);
  pointer-events: none;
  transition: all 0.3s;
}

.form-group input:focus + label,
.form-group input:not(:placeholder-shown) + label,
.form-group textarea:focus + label,
.form-group textarea:not(:placeholder-shown) + label {
  top: -10px;
  left: 10px;
  font-size: 0.8rem;
  background: var(--dark);
  padding: 0 5px;
  color: var(--primary);
}

.btn-submit {
  width: 100%;
  justify-content: center;
  background: var(--gradient);
  color: white;
}

.btn-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Toast */
.toast {
  position: fixed;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%) translateY(100px);
  background: var(--gradient);
  color: white;
  padding: 15px 30px;
  border-radius: 50px;
  z-index: 9999;
  opacity: 0;
  transition: all 0.3s;
}

.toast.show {
  transform: translateX(-50%) translateY(0);
  opacity: 1;
}

/* 页脚 */
.footer {
  background: rgba(0, 0, 0, 0.3);
  padding: 60px 0 30px;
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40px;
  flex-wrap: wrap;
  gap: 30px;
}

.footer-brand span {
  font-size: 2rem;
  font-weight: bold;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.footer-brand p {
  color: var(--gray);
  margin-top: 5px;
}

.footer-links {
  display: flex;
  gap: 30px;
}

.footer-links a {
  color: var(--gray);
  text-decoration: none;
  cursor: pointer;
  transition: color 0.3s;
}

.footer-links a:hover {
  color: var(--primary);
}

.footer-social {
  display: flex;
  gap: 15px;
}

.footer-social a {
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--gray);
  text-decoration: none;
  transition: all 0.3s;
}

.footer-social a:hover {
  background: var(--primary);
  border-color: var(--primary);
  color: white;
}

.footer-bottom {
  text-align: center;
  padding-top: 30px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  color: var(--gray);
  font-size: 0.9rem;
}

/* 响应式 */
@media (max-width: 1024px) {
  .projects-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .project-card.featured {
    grid-column: span 2;
  }

  .skills-detailed {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .navbar {
    padding: 15px 20px;
  }

  .nav-links {
    position: fixed;
    top: 0;
    right: -100%;
    width: 70%;
    max-width: 300px;
    height: 100vh;
    background: var(--dark);
    flex-direction: column;
    padding: 80px 30px;
    transition: right 0.3s;
  }

  .nav-links.nav-open {
    right: 0;
  }

  .nav-toggle {
    display: flex;
  }

  .hero {
    padding: 100px 20px;
  }

  .hero-title {
    font-size: 2.8rem;
  }

  .hero-actions {
    flex-direction: column;
    padding: 0 40px;
  }

  .hero-stats {
    gap: 30px;
  }

  .stat-value {
    font-size: 2rem;
  }

  section {
    padding: 80px 0;
  }

  .section-title {
    font-size: 2rem;
  }

  .about-grid {
    grid-template-columns: 1fr;
  }

  .about-cards {
    grid-template-columns: 1fr;
  }

  .skill-orbit {
    width: 300px;
    height: 300px;
  }

  .satellite {
    transform: translate(-50%, -50%) rotate(calc(var(--orbit) * 360deg / var(--total))) translateX(100px) !important;
  }

  .skills-detailed {
    grid-template-columns: 1fr;
  }

  .projects-grid {
    grid-template-columns: 1fr;
  }

  .project-card.featured {
    grid-column: span 1;
  }

  .timeline-line {
    left: 20px;
  }

  .timeline-item,
  .timeline-item.item-right {
    width: 100%;
    margin-left: 0;
    padding-left: 60px;
    padding-right: 0;
  }

  .timeline-dot,
  .item-right .timeline-dot {
    left: 10px !important;
    right: auto !important;
  }

  .contact-wrapper {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .footer-content {
    flex-direction: column;
    text-align: center;
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 2.2rem;
  }

  .skill-orbit {
    display: none;
  }
}
</style>
