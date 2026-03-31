#!/bin/bash

# Vue 项目 GitHub Pages 部署脚本

set -e

echo "🚀 开始部署..."

# 1. 构建
npm run build

# 2. 进入构建目录
cd dist

# 3. 创建 .nojekyll 文件（防止 GitHub Pages 忽略以 _ 开头的文件）
touch .nojekyll

# 4. 初始化 git
git init
git add -A
git commit -m "deploy: $(date +'%Y-%m-%d %H:%M:%S')"

# 5. 推送到 gh-pages 分支
# 注意：把下面的仓库地址改成你的
# 如果使用 SSH：git@github.com:zonghui1006/vue-webpack-project.git
# 如果使用 HTTPS：https://github.com/zonghui1006/vue-webpack-project.git
git push -f git@github.com:zonghui1006/vue-webpack-project.git main:gh-pages

cd ..

echo "✅ 部署完成！"
echo "🌐 访问地址: https://zonghui1006.github.io/vue-webpack-project"
