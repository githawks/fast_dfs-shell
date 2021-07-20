#!/bin/bash
#----------------基础配置-------------------------------------------------------
tracker_server_ip=106.14.155.43    #tracker主机的ip
port_nginx=8550                          #对外部开放的文件访问端口
echo ===========================开始下载docker 文件=========================================
docker search fastdfs
echo ===========================下载docker镜像=========================================
docker pull season/fastdfs:1.2
echo ===========================创建tracker的data=========================================
mkdir -p /usr/local/server/fastdfs/tracker/data
echo ===========================创建storage的data=========================================
mkdir -p /usr/local/server/fastdfs/storage/data
echo ===========================创建storage的path=========================================
mkdir -p /usr/local/server/fastdfs/storage/path
echo ===========================运行track容器=========================================
docker run -id --name tracker \
-p 22122:22122 \
--restart=always --net host \
-v /usr/local/server/fastdfs/tracker/data:/fastdfs/tracker/data \
season/fastdfs:1.2 tracker
echo ===========================创建storage容器=========================================
docker run -id --name storage \
--restart=always --net host \
-v /usr/local/server/fastdfs/data/storage:/fastdfs/store_path \
-e TRACKER_SERVER="${tracker_server_ip}:22122" \
season/fastdfs:1.2 storage
#非最终执行命令，请修改为自己的ip地址
echo =========================== 拷贝配置到track里面=========================================
docker cp ./client.conf tracker:/etc/fdfs
echo ===========================创建nginx目录=========================================
mkdir -p /usr/local/server/fastdfs/nginx/
echo ===========================copy nginx.config到指定目录=========================================
cp -r ./nginx.conf /usr/local/server/fastdfs/nginx/
echo ===========================运行nginx容器=========================================
docker run -id --name fastdfs_nginx \
--restart=always \
-v /usr/local/server/fastdfs/data/storage:/fastdfs/store_path \
-v /usr/local/server/fastdfs/nginx/nginx.conf:/etc/nginx/conf/nginx.conf \
-p ${port_nginx}:80 \
-e TRACKER_SERVER=${tracker_server_ip}:22122 \
season/fastdfs:1.2 nginx