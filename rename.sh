#!/bin/bash

# ================= 配置区 =================
OLD_PKG="com.xosapp.maintenance_tools"
NEW_PKG="com.xosapp.maintenance_tools"      # <-- 在这里填入你的新包名
OLD_NAME="RustDesk"
NEW_NAME="网络维护"                  # <-- 在这里填入你的新软件名
# ==========================================

echo ">>> 开始处理包名和应用名替换..."

# 1. 批量替换所有文件中的包名文本 (跳过 .git 和隐藏文件以防报错)
grep -rl "$OLD_PKG" . | grep -v "/\.git/" | xargs sed -i "s/$OLD_PKG/$NEW_PKG/g"

# 2. 批量替换 AndroidManifest 中的应用名称
grep -rl "android:label=\"$OLD_NAME\"" . | grep -v "/\.git/" | xargs sed -i "s/android:label=\"$OLD_NAME\"/android:label=\"$NEW_NAME\"/g"

# 3. 处理目录的移动和重命名
OLD_DIR="com.xosapp.maintenance_tools"
NEW_DIR=$(echo $NEW_PKG | tr '.' '/')

echo ">>> 开始重命名源文件夹..."
find . -type d -path "*/src/*/kotlin/$OLD_DIR" -o -path "*/src/*/java/$OLD_DIR" | while read -r dir; do
    # 获取 src 之前的根目录路径
    base_dir=$(echo "$dir" | sed "s|/$OLD_DIR||")
    
    # 创建新包名的多级目录
    mkdir -p "$base_dir/$NEW_DIR"
    
    # 将旧目录下的所有文件移动到新目录
    mv "$dir"/* "$base_dir/$NEW_DIR/" 2>/dev/null
    
    # 删除旧的空文件夹 (carriez)
    rm -rf "$base_dir/com/carriez" 2>/dev/null
    
    echo "已移动: $dir -> $base_dir/$NEW_DIR"
done

echo ">>> 替换全部完成！"