#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

install_XrayR() {
    # 设置面板key
    read -p "请输入面板Key:" api_key
    [ -z "${api_key}" ]
    echo -e "${yellow}您设定的面板key为${plain} ${api_key}"

     # 设置节点序号
    read -p "请输入面板中的节点序号:" node_id
    [ -z "${node_id}" ]
    echo -e "${green}您设定的节点序号为${plain} ${node_id}"


    # 写入配置文件
    echo "正在尝试写入配置文件..."
    wget https://raw.githubusercontent.com/chuwanfeng/XrayR-release/master/config/config.yml -O /etc/XrayR/config.yml
    sed -i "s/ApiKey:.*/ApiKey: \"${api_key}\"/g" /etc/XrayR/config.yml

    sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml

    echo ""
    echo "写入完成，正在尝试重启XrayR服务..."
    echo

    systemctl daemon-reload
    XrayR restart
    echo "正在配置防火墙！放行6443、443、80端口"
    echo

    ufw allow 6443/tcp

    echo "XrayR服务已经完成重启，请愉快地享用！"
    echo

    cd $cur_dir
    rm -f install.sh
    echo -e ""
    echo "XrayR 管理脚本使用方法 (兼容使用xrayr执行，大小写不敏感): "
    echo "------------------------------------------"
    echo "XrayR                    - 显示管理菜单 (功能更多)"
    echo "XrayR start              - 启动 XrayR"
    echo "XrayR stop               - 停止 XrayR"
    echo "XrayR restart            - 重启 XrayR"
    echo "XrayR status             - 查看 XrayR 状态"
    echo "XrayR enable             - 设置 XrayR 开机自启"
    echo "XrayR disable            - 取消 XrayR 开机自启"
    echo "XrayR log                - 查看 XrayR 日志"
    echo "XrayR update             - 更新 XrayR"
    echo "XrayR update x.x.x       - 更新 XrayR 指定版本"
    echo "XrayR config             - 显示配置文件内容"
    echo "XrayR install            - 安装 XrayR"
    echo "XrayR uninstall          - 卸载 XrayR"
    echo "XrayR version            - 查看 XrayR 版本"
    echo "------------------------------------------"
}

install_nginx(){
     if ! command -v nginx &> /dev/null; then
         echo "Nginx 未安装，正在执行安装..."
         apt-get update
         apt-get install -y nginx
         echo "Nginx 安装成功。"
     else
         echo "Nginx 已经安装。"
     fi
}

echo -e "${green}开始安装${plain}"
install_nginx
install_XrayR $1