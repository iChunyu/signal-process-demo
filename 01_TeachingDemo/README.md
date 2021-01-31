# 功率谱估计及其应用

为了辅助数字信号处理部分的教学，写了一些MATLAB脚本希望能给刚入门的小伙伴们一点指引。既然代码都有了，不妨挂到 [GitHub](https://github.com/iChunyu/signal-process-demo) 上，说不定就有哪位可爱的小朋友点个 :star: 呢。

仓库建立的初衷是为了辅助教学，但是考虑到信号处理具有一定的通用性，以后有时间可能会增加一些其他的东西（我的意思是...如果有时间的话:sweat_smile:)。可能到文件比较多的时候我才会认真考虑用文件夹进行归类，所以现在就先乱着吧。

本仓库内所有你能看到的代码尽管取用，也欢迎在 [Discussions](https://github.com/iChunyu/signal-process-demo/discussions) 页面讨论或给出宝贵建议，更欢迎大家能够分享自己的代码 :yum: 。

***

## 仓库文件说明

`signal-demo-ppt/` 文件夹下分享了功率谱估计的PPT，该PPT由 LaTeX 生成，有兴趣的同学可以帮忙在 LaTeX 源码中添加注释为PPT做解释；

`iLPSD.m` 是随仓库赠送的一个功率谱估计函数，其介绍可以参考文献[Improved spectrum estimation from digitized time series on a logarithmic frequency axis](https://www.sciencedirect.com/science/article/abs/pii/S026322410500117X)，也可在 [Discussions](https://github.com/iChunyu/signal-process-demo/discussions) 页面进行讨论。

其他的 `*.m` 文件都是示例脚本，虽然没有写太多注释，但我相信代码还是足够简洁不至于混乱。不太明白函数功能的小伙伴可以用 MATLAB 的 `doc` 命令查看帮助文档。

`*.mat` 文件是示例脚本用到的数据，都是自己造的啦，测试算法就好，不要太当真了。

## 其他闲话

祝大家学习顺利，生活开心！~
