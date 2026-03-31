#!/bin/bash

# 新项目部署脚本 - personal

set -e

echo "🚀 开始部署到 personal..."

# 1. 构建
npm run build

# 2. 进入构建目录
cd dist

# 3. 创建 .nojekyll 文件
touch .nojekyll

# 4. 初始化 git
git init
git add -A
git commit -m "deploy: $(date +'%Y-%m-%d %H:%M:%S')"

# 5. 推送到 personal 仓库的 gh-pages 分支
git push -f git@github.com:zonghui1006/personal.git main:gh-pages

cd ..

echo "✅ 部署完成！"
echo "🌐 访问地址: https://zonghui1006.github.io/personal"
