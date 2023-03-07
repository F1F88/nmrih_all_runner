# [NMRiH] All Runner


## README.md

- en [English](./readme.en.md)
- zh_CN [简体中文](./readme.md)


## 本项目同时托管在

- GitHub
- Gitee


## 描述：

将地图上所有的普通 zombie 转变成 runner


## 需要 :

- Sourcemod（版本不要太低）https://wiki.alliedmods.net/Installing_SourceMod/zh
- [INC] NMRiH VScript Proxy https://forums.alliedmods.net/showthread.php?t=338049


## 安装

- 下载此项目并解压到你自己的 ./addons/sourcemod/ 文件夹里
- 重启服务器 或 刷新插件列表


## 使用

插件安装后会自动检测丧尸的生成，并将其转变成跑尸。

如果没有生效，确保你的插件已安装，以及 `sm_all_runner_enable` 值为 1。也可以试试开启新的回合或重启服务器

默认启用了爬行者的转变，你可以通过设置参数 `sm_all_runner_conversion_crawler 0`  来关闭转变爬行者为跑尸


## 可配置参数

<pre>
sm_all_runner_enable                -   default:  1   -   是否启用插件
sm_all_runner_conversion_crawler    -   default:  1   -   是否转变爬行者
sm_all_runner_set_health_runner     -   default:  0   -   设置原始生成的跑尸生命值（0=与当前模式跑尸默认生命值相同）
sm_all_runner_set_health_kid        -   default:  0   -   设置原始生成的丧尸小孩生命值（0=与当前模式丧尸小孩默认生命值相同）
sm_all_runner_set_health_turned     -   default:  0   -   设置原始生成的丧尸队友生命值（0=与当前模式跑尸默认生命值相同）
sm_all_runner_set_health_crawler    -   default:  0   -   设置原始生成的爬行者生命值（0=与当前模式跑尸默认生命值相同）
sm_all_runner_set_health_normal     -   default:  0   -   设置原始生成的普通丧尸生命值（0=与当前模式跑尸默认生命值相同）
sm_all_runner_runner_dmg_onehand    -   default:  20  -   设置跑尸单手伤害
sm_all_runner_runner_dmg_twohand    -   default:  40  -   设置跑尸双手伤害
sm_all_runner_kid_dmg_onehand       -   default:  8   -   设置丧尸小孩单手伤害
sm_all_runner_kid_dmg_twohand       -   default:  16  -   设置丧尸小孩双手伤害
</pre>


## 与 NMRiH Diffmoder 不同之处

我对 NMRIH Diffmoder 不是很了解，目前知道的不同有

NMRiH Diffmoder

- NMRiH Diffmoder 通过先删除普通丧尸，然后生成一个新丧尸来实现模式定制。

- 这样生成的丧尸数量似乎比原始模式少一些，可能出现不再刷新的情况。

All Runner

- 总丧尸数量与原始数量相同：它不会先抹除丧尸再去生成一个新的丧尸，而是直接将普通丧尸转变成跑尸。

- 难度更大：如果某张地图会不断的刷新普通丧尸，就会有源源不断的跑尸

- 支持设置是否转变爬行者、每种丧尸转变成跑尸后的生命值、跑尸和丧尸小孩攻击造成的伤害

- 仅支持能转变成跑尸，暂不能转变成 丧尸小孩
