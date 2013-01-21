example_shorten_url_app
=======================

技术演示使用。shorten url app: redis + sinatra


# 准备工作

1. 用rvm安装ruby 1.9

1. 下载redis源码安装

1. 启动redis

1. 进入程序文件夹安装需要的gems

    bundle install

# 启动程序

    shotgun short_link.app

shortgun会在每次请求页面的时候重新载入rb源码。方便开发中迅速查看效果。

# 其它

没有其它。实际上这个程序非常简单，我觉得可以直接上生产系统的！ ：） 

