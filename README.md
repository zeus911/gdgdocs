# GDGDocs


简介
--------------

GDGDocs 是一个无障碍访问 Google Docs 解决方案之一（针对用户）免费、无广告恶意程序、开源

  - 用户无障碍访问 **公开的** Google 表单
  
  - <s>用户无障碍访问 **[已发布到网络][1]** 的 Google 文档</s> [主站不再支持]
  - <s>用户无障碍访问 **[已发布到网络][2]** 的 Google 电子表格</s>[主站不再支持]
  - <s>用户无障碍访问 **[已发布到网络][3]** 的 Google 演示文稿</s> [主站不再支持]


使用方法
-------

替换 docs.google.com 部分为 www.gdgdocs.org

举个栗子：
(无法打开) 
https://docs.google.com/forms/d/1Ycw5cIkCzhB1ivycGYT2Z99YlaV0cvhIu52z_9Jpp1o/viewform 

(可以打开)
https://www.gdgdocs.org/forms/d/1Ycw5cIkCzhB1ivycGYT2Z99YlaV0cvhIu52z_9Jpp1o/viewform 

也可以参考使用珠海 GDG 提供的转换工具一次性生成短链接和二维码链接，[使用说明][8]

**Updates:  短链接、二维码使用方法 20140808**

 - 到 goo.gl 缩短 *已经替换域名为 gdgdocs.org 的网址* ，我们假定缩短后的网址是：http://goo.gl/jc77Y4 （部分地区无法访问）

 - 替换域名： https://gdgdocs.org/r/jc77Y4  （可以访问）

 - 二维码链接是： https://gdgdocs.org/qr/jc77Y4 （可以访问）


**Updates:  短链接、二维码使用方法 20140811**

 - 已经升级最新版本 nginx1.6.1，支持 spdy3
 
 - 一键安装包已经更新到最新版，支持二维码、短链接，SPDY（需要自行开启） 

GDGDocs 服务器环境
--------------

 - 云服务商：Google Cloud Coumpute
 
 - 区域：us-central1-a

 - 机器类型：n1-standard-1 (1 个 vCPU，3.8GB 内存)

 - GCE 网络负载均衡
 
 - DnsPod.cn 免费版解析 

使用条款
---------
- 本服务是为 GDG 社区免费提供的，我们授权所有非盈利组织、开源社区、技术社区使用。

- 无论是任何人使用，都请注意：**珍惜网络资源是每个网民应该做的**，请勿使用本服务传播有害内容，至于什么是有害内容：

 - **不适合在公众场合展览的**
 - **不能给你家小孩儿看的**
 - **政治倾向灰常偏离主流的（国情，请海涵）**


- 最后，使用先进的服务提升用户体验，是一个高明的选择！


自行部署
--------------

在 Google Cloud Compute、DigitalOcean、阿里云，CentOS 6.x 64位环境下均测试成功，下面是 CentOS 的一键安装包。内容大部分取自 [LNMP 一键安装包][6]：

一键安装包地址:  http://gdgny.qiniudn.com/project/gdgdocs/gdgdocs.tar.gz 

安装方法：

```sh
wget http://gdgny.qiniudn.com/project/gdgdocs/gdgdocs.tar.gz
tar zxvf gdgdocs.tar.gz
cd gdgdocs
chmod +x centos.sh
./centos.sh
```

隐私权说明
----
 - 我们珍视你给予我们的信任，我们一定不会辜负这份信任
 
 - 我们理解使用在线表单一定是为了收集一些什么对你有用的信息，但是我们不感兴趣
 
 - 服务器只负责代理转发请求，不记录任何其他信息
 
 - 该服务器仅运行纯 Nginx 反代程序，没有其他“邻居”，请大可放心
 
 - 我们希望复杂的网络环境下，能有一些最基本的信任，如若还要 BB，那就自行搭建服务器吧，You can you up.

开源协议
----
[MIT][7]


  [1]: https://support.google.com/docs/answer/183965?hl=zh-Hans
  [2]: https://support.google.com/docs/answer/183965?hl=zh-Hans
  [3]: https://support.google.com/docs/answer/183965?hl=zh-Hans
  [6]: http://lnmp.org/
  [7]: http://opensource.org/licenses/mit-license.php
  [8]: https://github.com/GDGNanyang/gdgdocs/blob/master/WechatToolByZHGDG.md

