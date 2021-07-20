# fast_dfs-shell
快速 docker 部署fastdfs 
#首先如上所示有三个文件 
copy到自己的linux 目录下 
#运行sh xxx.sh,如果提示commod not 之类的  运行  linux 格式化sed -i 's/\r$//' xxx.sh即可
#运行步骤1、修改client.conf 
tracker_server=106.14.155.43:22122   ip修改成你自己的服务器即可
2、修改fastdfs_install.sh
修改其中的ip 和对外开放的端口
3、运行脚本即可
4、运行完成后 使用docker 命令 进行容器查看是否有 fastdfs_nginx  storage tracker三个容器正常运行
5、测试
a、
运行docker exec -it tracker bash 进入容器
b、
随便创建一个 txt 文件：
echo "niceyoo" > niceyoo.txt
c、
然后通过 fdfs_upload_file 命令将 niceyoo.txt 文件上传至服务器
fdfs_upload_file /etc/fdfs/client.conf niceyoo.txt
d、
把返回的group1/M00/00/00/CtM3BF84iz2AWE_JAAAACBfWGpM793.txt这个保存下来
e、
在浏览器中输入 http://ip:8550/group1/M00/00/00/CtM3BF84iz2AWE_JAAAACBfWGpM793.txt    访问即成功
