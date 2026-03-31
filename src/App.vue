<template>
  <div class="portfolio">
    <!-- 粒子背景 -->
    <canvas ref="particleCanvas" class="particle-bg"></canvas>

    <!-- 导航 -->
    <nav class="navbar" :class="{ 'navbar-scrolled': scrolled }">
      <div class="nav-brand">ZH</div>
      <div class="nav-links" :class="{ 'nav-open': navOpen }">
        <a v-for="item in navItems" :key="item.id" @click="scrollTo(item.id); navOpen = false">
          {{ item.name }}
        </a>
      </div>
      <div class="nav-toggle" @click="navOpen = !navOpen">
        <span></span>
        <span></span>
        <span></span>
      </div>
    </nav>

    <!-- 英雄区域 -->
    <section id="hero" class="hero">
      <div class="hero-content">
        <div class="glitch-wrapper">
          <h1 class="glitch" data-text="宗辉">宗辉</h1>
        </div>
        <div class="typing-text">
          <span ref="typeText"></span>
          <span class="cursor">|</span>
        </div>
        <p class="hero-desc">
          十年磨一剑，专注前端工程化与用户体验设计
        </p>
        <div class="hero-stats">
          <div class="stat-item" v-for="(stat, index) in stats" :key="index">
            <div class="stat-number" :data-target="stat.number">{{ stat.display }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </div>
        <div class="hero-buttons">
          <button class="btn btn-primary" @click="scrollTo('skills')">
            <span>查看技能</span>
            <div class="btn-glow"></div>
          </button>
          <button class="btn btn-secondary" @click="scrollTo('contact')">
            联系我
          </button>
        </div>
      </div>
      <div class="scroll-indicator">
        <div class="mouse"></div>
        <span>向下滚动</span>
      </div>
    </section>

    <!-- 关于我 -->
    <section id="about" class="about">
      <div class="container">
        <h2 class="section-title">
          <span class="title-line"></span>
          关于我
          <span class="title-line"></span>
        </h2>
        <div class="about-content">
          <div class="about-card">
            <div class="card-shine"></div>
            <div class="about-icon">💻</div>
            <h3>前端专家</h3>
            <p>深耕前端领域十年，见证并参与了前端技术的整个发展历程。从 jQuery 到 React、Vue，从 ES5 到 ES2024，始终保持技术敏感度。</p>
          </div>
          <div class="about-card">
            <div class="card-shine"></div>
            <div class="about-icon">🚀</div>
            <h3>技术驱动</h3>
            <p>热爱技术创新，擅长前端工程化建设。在多个项目中主导技术选型、架构设计，带领团队完成从 0 到 1 的构建。</p>
          </div>
          <div class="about-card">
            <div class="card-shine"></div>
            <div class="about-icon">🎨</div>
            <h3>设计敏感</h3>
            <p>对 UI/UX 有独到见解，能将设计稿完美还原。注重用户体验细节，追求代码与视觉的完美统一。</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 技能展示 -->
    <section id="skills" class="skills">
      <div class="container">
        <h2 class="section-title light">
          <span class="title-line"></span>
          技术栈
          <span class="title-line"></span>
        </h2>
        <div class="skills-grid">
          <div class="skill-category" v-for="(category, idx) in skillCategories" :key="idx">
            <h3 class="category-title">{{ category.name }}</h3>
            <div class="skill-items">
              <div class="skill-item" v-for="(skill, sIdx) in category.skills" :key="sIdx"
                   :style="{ '--delay': sIdx * 0.1 + 's' }">
                <div class="skill-info">
                  <span class="skill-name">{{ skill.name }}</span>
                  <span class="skill-level">{{ skill.level }}%</span>
                </div>
                <div class="skill-bar">
                  <div class="skill-progress" :style="{ width: skill.level + '%' }"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 时间轴 -->
    <section id="experience" class="experience">
      <div class="container">
        <h2 class="section-title">
          <span class="title-line"></span>
          十年历程
          <span class="title-line"></span>
        </h2>
        <div class="timeline">
          <div class="timeline-item" v-for="(item, index) in timeline" :key="index"
               :class="{ 'timeline-right': index % 2 === 1 }">
            <div class="timeline-dot"></div>
            <div class="timeline-content">
              <div class="timeline-year">{{ item.year }}</div>
              <h3>{{ item.title }}</h3>
              <p>{{ item.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 联系方式 -->
    <section id="contact" class="contact">
      <div class="container">
        <h2 class="section-title light">
          <span class="title-line"></span>
          联系我
          <span class="title-line"></span>
        </h2>
        <div class="contact-content">
          <div class="contact-info">
            <div class="contact-item" v-for="(contact, idx) in contacts" :key="idx">
              <div class="contact-icon">{{ contact.icon }}</div>
              <div class="contact-detail">
                <h4>{{ contact.title }}</h4>
                <p>{{ contact.value }}</p>
              </div>
            </div>
          </div>
          <div class="contact-cta">
            <h3>有项目想法？</h3>
            <p>无论是技术交流还是项目合作，都欢迎随时联系我</p>
            <button class="btn btn-large btn-glow" @click="showEmail">
              发送邮件
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <p>&copy; 2024 宗辉. All Rights Reserved. | 用 ❤️ 和代码构建</p>
    </footer>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue';

export default {
  name: 'App',
  setup() {
    const particleCanvas = ref(null);
    const typeText = ref(null);
    const scrolled = ref(false);
    const navOpen = ref(false);

    const navItems = [
      { name: '首页', id: 'hero' },
      { name: '关于', id: 'about' },
      { name: '技能', id: 'skills' },
      { name: '经历', id: 'experience' },
      { name: '联系', id: 'contact' }
    ];

    const stats = ref([
      { number: 10, label: '年前端经验', display: 0 },
      { number: 50, label: '完成项目', display: 0 },
      { number: 1000, label: '代码提交(K)', display: 0 },
      { number: 99, label: '客户满意度%', display: 0 }
    ]);

    const skillCategories = [
      {
        name: '核心技术',
        skills: [
          { name: 'JavaScript / TypeScript / Object-C', level: 95 },
          { name: 'React / Vue.js / ReactNative', level: 92 },
          { name: 'HTML5 / CSS3', level: 95 },
          { name: 'Node.js', level: 80 }
        ]
      },
      {
        name: '工程化',
        skills: [
          { name: 'Webpack / Vite', level: 90 },
          { name: 'Git / CI/CD', level: 85 },
          { name: 'Docker / K8s', level: 70 },
          { name: 'Jest / Testing', level: 75 }
        ]
      },
      {
        name: 'UI/设计',
        skills: [
          { name: '响应式设计', level: 90 },
          { name: '动画交互', level: 85 },
          { name: 'Figma / Sketch', level: 75 },
          { name: 'Three.js / WebGL', level: 65 }
        ]
      }
    ];

    const timeline = [
      { year: '2016', title: 'iOS起步', desc: '开始移动端开发之旅，深入掌握 Object-C、WebKit' },
      { year: '2018', title: '移动端进阶', desc: '转向 ReactNative，构建大型移动端应用' },
      { year: '2020', title: '前端进阶', desc: '专注 React、Vue 前端开发，构建大型单页面应用' },
      { year: '2024', title: '全栈拓展', desc: '深入 Taro、UniApp，成为前端全栈工程师' },
      { year: '2026', title: '持续进化', desc: '探索 AI 与前端结合，追求极致用户体验' }
    ];

    const contacts = [
      { icon: '📧', title: '邮箱', value: 'zonghui1006@163.com' },
      { icon: '📱', title: '微信', value: 'zonghui1006' },
      // { icon: '💼', title: 'GitHub', value: 'github.com/zonghui' },
      { icon: '📍', title: '坐标', value: '中国 · 北京' }
    ];

    // 粒子背景
    const initParticles = () => {
      const canvas = particleCanvas.value;
      if (!canvas) return;

      const ctx = canvas.getContext('2d');
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;

      const particles = [];
      const particleCount = 50;

      for (let i = 0; i < particleCount; i++) {
        particles.push({
          x: Math.random() * canvas.width,
          y: Math.random() * canvas.height,
          vx: (Math.random() - 0.5) * 0.5,
          vy: (Math.random() - 0.5) * 0.5,
          radius: Math.random() * 2 + 1
        });
      }

      let animationId;
      const animate = () => {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        particles.forEach((p, i) => {
          p.x += p.vx;
          p.y += p.vy;

          if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
          if (p.y < 0 || p.y > canvas.height) p.vy *= -1;

          ctx.beginPath();
          ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
          ctx.fillStyle = 'rgba(102, 126, 234, 0.5)';
          ctx.fill();

          // 连线
          for (let j = i + 1; j < particles.length; j++) {
            const dx = particles[j].x - p.x;
            const dy = particles[j].y - p.y;
            const dist = Math.sqrt(dx * dx + dy * dy);

            if (dist < 150) {
              ctx.beginPath();
              ctx.moveTo(p.x, p.y);
              ctx.lineTo(particles[j].x, particles[j].y);
              ctx.strokeStyle = `rgba(102, 126, 234, ${0.2 * (1 - dist / 150)})`;
              ctx.stroke();
            }
          }
        });

        animationId = requestAnimationFrame(animate);
      };

      animate();

      const handleResize = () => {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
      };
      window.addEventListener('resize', handleResize);

      return () => {
        cancelAnimationFrame(animationId);
        window.removeEventListener('resize', handleResize);
      };
    };

    // 打字机效果
    const initTypewriter = () => {
      const text = 'Frontend Engineer | 前端工程师';
      let index = 0;
      const element = typeText.value;
      if (!element) return;

      const type = () => {
        if (index < text.length) {
          element.textContent += text.charAt(index);
          index++;
          setTimeout(type, 100);
        }
      };

      setTimeout(type, 1000);
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
      scrolled.value = window.scrollY > 50;
    };

    const scrollTo = (id) => {
      const element = document.getElementById(id);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth' });
      }
    };

    const showEmail = () => {
      alert('邮箱: zonghui@example.com\n(请替换为真实邮箱)');
    };

    onMounted(() => {
      initParticles();
      initTypewriter();
      animateNumbers();
      window.addEventListener('scroll', handleScroll);
    });

    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll);
    });

    return {
      particleCanvas,
      typeText,
      scrolled,
      navOpen,
      navItems,
      stats,
      skillCategories,
      timeline,
      contacts,
      scrollTo,
      showEmail
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
  --dark: #1a1a2e;
  --light: #fff;
  --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.portfolio {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: var(--dark);
  overflow-x: hidden;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 粒子背景 */
.particle-bg {
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
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
}

.nav-brand {
  font-size: 2rem;
  font-weight: bold;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.nav-links {
  display: flex;
  gap: 30px;
}

.nav-links a {
  cursor: pointer;
  color: var(--dark);
  font-weight: 500;
  transition: color 0.3s;
  position: relative;
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

.nav-links a:hover::after {
  width: 100%;
}

/* 英雄区域 */
.hero {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 100px 20px;
  position: relative;
}

.hero-content {
  z-index: 1;
}

/* Glitch 效果 */
.glitch-wrapper {
  margin-bottom: 20px;
}

.glitch {
  font-size: 6rem;
  font-weight: bold;
  position: relative;
  color: var(--dark);
  text-shadow: 2px 2px 0px rgba(102, 126, 234, 0.5);
  animation: glitch 3s infinite;
}

.glitch::before,
.glitch::after {
  content: attr(data-text);
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.glitch::before {
  color: #667eea;
  animation: glitch-1 2s infinite linear alternate-reverse;
  clip-path: polygon(0 0, 100% 0, 100% 35%, 0 35%);
}

.glitch::after {
  color: #764ba2;
  animation: glitch-2 3s infinite linear alternate-reverse;
  clip-path: polygon(0 65%, 100% 65%, 100% 100%, 0 100%);
}

@keyframes glitch {
  0%, 90%, 100% { transform: translate(0); }
  92% { transform: translate(-2px, 2px); }
  94% { transform: translate(2px, -2px); }
  96% { transform: translate(-2px, -2px); }
  98% { transform: translate(2px, 2px); }
}

@keyframes glitch-1 {
  0%, 100% { transform: translate(0); }
  20% { transform: translate(-3px, 3px); }
  40% { transform: translate(-3px, -3px); }
  60% { transform: translate(3px, 3px); }
  80% { transform: translate(3px, -3px); }
}

@keyframes glitch-2 {
  0%, 100% { transform: translate(0); }
  20% { transform: translate(3px, -3px); }
  40% { transform: translate(3px, 3px); }
  60% { transform: translate(-3px, -3px); }
  80% { transform: translate(-3px, 3px); }
}

/* 打字机 */
.typing-text {
  font-size: 1.5rem;
  color: var(--primary);
  margin-bottom: 20px;
  font-family: 'Courier New', monospace;
}

.cursor {
  animation: blink 1s infinite;
}

@keyframes blink {
  0%, 50% { opacity: 1; }
  51%, 100% { opacity: 0; }
}

.hero-desc {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 40px;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

/* 统计数据 */
.hero-stats {
  display: flex;
  justify-content: center;
  gap: 60px;
  margin-bottom: 50px;
  flex-wrap: wrap;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 3rem;
  font-weight: bold;
  background: var(--gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.stat-label {
  color: #888;
  font-size: 0.9rem;
  margin-top: 5px;
}

/* 按钮 */
.hero-buttons {
  display: flex;
  gap: 20px;
  justify-content: center;
  flex-wrap: wrap;
}

.btn {
  padding: 15px 40px;
  font-size: 1rem;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  font-weight: 600;
}

.btn-primary {
  background: var(--gradient);
  color: white;
}

.btn-glow::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.btn-glow:hover::before {
  width: 300px;
  height: 300px;
}

.btn-secondary {
  background: transparent;
  color: var(--dark);
  border: 2px solid var(--primary);
}

.btn-secondary:hover {
  background: var(--primary);
  color: white;
}

.btn:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
}

.btn-large {
  padding: 18px 50px;
  font-size: 1.1rem;
}

/* 滚动指示器 */
.scroll-indicator {
  position: absolute;
  bottom: 40px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  color: #888;
  font-size: 0.9rem;
}

.mouse {
  width: 26px;
  height: 40px;
  border: 2px solid #888;
  border-radius: 13px;
  position: relative;
}

.mouse::after {
  content: '';
  position: absolute;
  top: 8px;
  left: 50%;
  transform: translateX(-50%);
  width: 4px;
  height: 8px;
  background: var(--primary);
  border-radius: 2px;
  animation: scroll-wheel 2s infinite;
}

@keyframes scroll-wheel {
  0% { top: 8px; opacity: 1; }
  100% { top: 20px; opacity: 0; }
}

/* 区域标题 */
.section-title {
  font-size: 2.5rem;
  text-align: center;
  margin-bottom: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
}

.section-title.light {
  color: white;
}

.title-line {
  width: 60px;
  height: 3px;
  background: var(--gradient);
  border-radius: 2px;
}

.section-title.light .title-line {
  background: rgba(255, 255, 255, 0.5);
}

/* 关于区域 */
.about {
  padding: 100px 0;
  background: #f8f9fa;
}

.about-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
}

.about-card {
  background: white;
  padding: 40px;
  border-radius: 20px;
  text-align: center;
  position: relative;
  overflow: hidden;
  transition: transform 0.3s, box-shadow 0.3s;
}

.about-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.card-shine {
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(
    90deg,
    transparent,
    rgba(255, 255, 255, 0.4),
    transparent
  );
  transition: left 0.5s;
}

.about-card:hover .card-shine {
  left: 100%;
}

.about-icon {
  font-size: 3rem;
  margin-bottom: 20px;
}

.about-card h3 {
  font-size: 1.5rem;
  margin-bottom: 15px;
  color: var(--dark);
}

.about-card p {
  color: #666;
  line-height: 1.8;
}

/* 技能区域 */
.skills {
  padding: 100px 0;
  background: var(--dark);
}

.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 40px;
}

.skill-category {
  background: rgba(255, 255, 255, 0.05);
  padding: 30px;
  border-radius: 15px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.category-title {
  color: white;
  font-size: 1.3rem;
  margin-bottom: 25px;
  padding-bottom: 10px;
  border-bottom: 2px solid var(--primary);
}

.skill-item {
  margin-bottom: 20px;
  animation: slideIn 0.6s ease forwards;
  animation-delay: var(--delay);
  opacity: 0;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.skill-info {
  display: flex;
  justify-content: space-between;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 8px;
  font-size: 0.95rem;
}

.skill-bar {
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
}

.skill-progress {
  height: 100%;
  background: var(--gradient);
  border-radius: 4px;
  transition: width 1.5s ease;
  position: relative;
}

.skill-progress::after {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  width: 30px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3));
  animation: shimmer 2s infinite;
}

@keyframes shimmer {
  0% { transform: translateX(-30px); }
  100% { transform: translateX(30px); }
}

/* 时间轴 */
.experience {
  padding: 100px 0;
  background: #f8f9fa;
}

.timeline {
  position: relative;
  max-width: 800px;
  margin: 0 auto;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 2px;
  height: 100%;
  background: var(--gradient);
}

.timeline-item {
  position: relative;
  padding: 20px 0;
  width: 50%;
  padding-right: 50px;
}

.timeline-item.timeline-right {
  margin-left: 50%;
  padding-right: 0;
  padding-left: 50px;
}

.timeline-dot {
  position: absolute;
  right: -8px;
  top: 30px;
  width: 16px;
  height: 16px;
  background: var(--gradient);
  border-radius: 50%;
  border: 3px solid white;
  box-shadow: 0 0 0 3px var(--primary);
}

.timeline-right .timeline-dot {
  right: auto;
  left: -8px;
}

.timeline-content {
  background: white;
  padding: 25px;
  border-radius: 15px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.timeline-content:hover {
  transform: scale(1.05);
}

.timeline-year {
  display: inline-block;
  background: var(--gradient);
  color: white;
  padding: 5px 15px;
  border-radius: 20px;
  font-size: 0.9rem;
  margin-bottom: 10px;
}

.timeline-content h3 {
  color: var(--dark);
  margin-bottom: 10px;
}

.timeline-content p {
  color: #666;
  font-size: 0.95rem;
  line-height: 1.6;
}

/* 联系区域 */
.contact {
  padding: 100px 0;
  background: var(--dark);
}

.contact-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 60px;
  align-items: center;
}

.contact-info {
  display: grid;
  gap: 25px;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 20px;
  background: rgba(255, 255, 255, 0.05);
  padding: 20px;
  border-radius: 12px;
  transition: transform 0.3s, background 0.3s;
}

.contact-item:hover {
  transform: translateX(10px);
  background: rgba(255, 255, 255, 0.1);
}

.contact-icon {
  font-size: 1.5rem;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--gradient);
  border-radius: 12px;
}

.contact-detail h4 {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.9rem;
  margin-bottom: 5px;
}

.contact-detail p {
  color: white;
  font-size: 1.1rem;
}

.contact-cta {
  text-align: center;
  padding: 40px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.contact-cta h3 {
  color: white;
  font-size: 1.8rem;
  margin-bottom: 15px;
}

.contact-cta p {
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 30px;
}

/* 页脚 */
.footer {
  background: #0f0f1a;
  color: rgba(255, 255, 255, 0.5);
  text-align: center;
  padding: 30px;
  font-size: 0.9rem;
}

/* 导航汉堡菜单 */
.nav-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  cursor: pointer;
  padding: 10px;
  z-index: 1001;
}

.nav-toggle span {
  width: 25px;
  height: 2px;
  background: var(--dark);
  transition: all 0.3s;
}

.navbar-scrolled .nav-toggle span {
  background: var(--dark);
}

/* 触摸优化 */
.btn, .nav-links a, .timeline-content, .about-card, .contact-item {
  -webkit-tap-highlight-color: transparent;
}

/* 响应式 - 平板和手机 */
@media (max-width: 768px) {
  .glitch {
    font-size: 3.5rem;
  }

  .hero-stats {
    gap: 30px;
  }

  .stat-number {
    font-size: 2rem;
  }

  .nav-links {
    display: none;
  }

  .timeline::before {
    left: 20px;
  }

  .timeline-item,
  .timeline-item.timeline-right {
    width: 100%;
    margin-left: 0;
    padding-left: 60px;
    padding-right: 0;
  }

  .timeline-dot,
  .timeline-right .timeline-dot {
    left: 12px;
    right: auto;
  }

  .contact-content {
    grid-template-columns: 1fr;
  }

  /* 导航 */
  .navbar {
    padding: 15px 20px;
  }

  .nav-toggle {
    display: flex;
  }

  .nav-links {
    position: fixed;
    top: 0;
    right: -100%;
    width: 70%;
    max-width: 300px;
    height: 100vh;
    background: white;
    flex-direction: column;
    padding: 80px 30px 30px;
    transition: right 0.3s ease;
    box-shadow: -5px 0 30px rgba(0, 0, 0, 0.1);
    gap: 0;
    margin: 0;
    display: flex;
  }

  .nav-links.nav-open {
    right: 0;
  }

  .nav-links a {
    padding: 15px 0;
    border-bottom: 1px solid #eee;
    font-size: 1.1rem;
  }

  /* Hero 区域 */
  .hero {
    padding: 80px 15px 60px;
    min-height: auto;
  }

  .glitch {
    font-size: 3rem;
  }

  .typing-text {
    font-size: 1rem;
    padding: 0 10px;
  }

  .hero-desc {
    font-size: 1rem;
    padding: 0 15px;
  }

  .hero-stats {
    gap: 20px;
    flex-wrap: wrap;
    padding: 0 10px;
  }

  .stat-item {
    flex: 0 0 45%;
  }

  .stat-number {
    font-size: 2rem;
  }

  .stat-label {
    font-size: 0.8rem;
  }

  .hero-buttons {
    flex-direction: column;
    gap: 15px;
    padding: 0 30px;
    width: 100%;
  }

  .btn {
    width: 100%;
    padding: 14px 30px;
  }

  /* 区域标题 */
  .section-title {
    font-size: 1.8rem;
    margin-bottom: 40px;
    flex-direction: column;
    gap: 10px;
  }

  .title-line {
    width: 40px;
  }

  /* 关于区域 */
  .about {
    padding: 60px 0;
  }

  .about-content {
    grid-template-columns: 1fr;
    gap: 20px;
    padding: 0 15px;
  }

  .about-card {
    padding: 30px 20px;
  }

  .about-icon {
    font-size: 2.5rem;
  }

  .about-card h3 {
    font-size: 1.3rem;
  }

  .about-card p {
    font-size: 0.9rem;
  }

  /* 技能区域 */
  .skills {
    padding: 60px 0;
  }

  .skills-grid {
    grid-template-columns: 1fr;
    gap: 25px;
    padding: 0 15px;
  }

  .skill-category {
    padding: 25px 20px;
  }

  .category-title {
    font-size: 1.1rem;
    margin-bottom: 20px;
  }

  .skill-info {
    font-size: 0.85rem;
  }

  /* 时间轴 */
  .experience {
    padding: 60px 0;
  }

  .timeline {
    padding: 0 15px;
  }

  .timeline::before {
    left: 15px;
  }

  .timeline-item,
  .timeline-item.timeline-right {
    width: 100%;
    margin-left: 0;
    padding-left: 50px;
    padding-right: 0;
  }

  .timeline-dot,
  .timeline-right .timeline-dot {
    left: 7px;
    right: auto;
    width: 14px;
    height: 14px;
  }

  .timeline-content {
    padding: 20px;
  }

  .timeline-year {
    font-size: 0.8rem;
  }

  .timeline-content h3 {
    font-size: 1.1rem;
  }

  .timeline-content p {
    font-size: 0.85rem;
  }

  /* 联系区域 */
  .contact {
    padding: 60px 0;
  }

  .contact-content {
    grid-template-columns: 1fr;
    gap: 40px;
    padding: 0 15px;
  }

  .contact-item {
    padding: 15px;
  }

  .contact-icon {
    width: 45px;
    height: 45px;
    font-size: 1.3rem;
  }

  .contact-detail h4 {
    font-size: 0.85rem;
  }

  .contact-detail p {
    font-size: 0.95rem;
  }

  .contact-cta {
    padding: 30px 20px;
  }

  .contact-cta h3 {
    font-size: 1.4rem;
  }

  .contact-cta p {
    font-size: 0.9rem;
  }

  /* 滚动指示器隐藏 */
  .scroll-indicator {
    display: none;
  }

  /* 触摸设备优化 */
  .about-card:active,
  .timeline-content:active {
    transform: scale(0.98);
  }
}

/* 超小屏幕适配 */
@media (max-width: 375px) {
  .glitch {
    font-size: 2.5rem;
  }

  .stat-number {
    font-size: 1.8rem;
  }

  .section-title {
    font-size: 1.5rem;
  }

  .btn {
    font-size: 0.9rem;
  }
}

/* 横屏手机适配 */
@media (max-height: 500px) and (orientation: landscape) {
  .hero {
    min-height: auto;
    padding-top: 60px;
  }

  .glitch {
    font-size: 2.5rem;
  }

  .hero-stats {
    margin-bottom: 30px;
  }

  .scroll-indicator {
    display: none;
  }
}
</style>
