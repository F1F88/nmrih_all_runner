# [NMRiH] All Runner


## README.md

- en [English](./readme.en.md)
- zh_CN [简体中文](./readme.md)


## This project is also hosted at

- [GitHub](https://github.com/F1F88/nmrih_all_runner)
- [Gitee](https://gitee.com/f1f88/nmrih_all_runner)


## Description

Turn all normal zombies on the map into runner zombies


## Requires

- Sourcemod https://wiki.alliedmods.net/Installing_SourceMod/zh
- [INC] NMRiH VScript Proxy https://forums.alliedmods.net/showthread.php?t=338049


## Installation

- Download the project and extract it to your own ./addons/sourcemod/ folder
- Restart the server or refresh the plug-in list


## Usage

After the plugin is installed, it will automatically detect the normal zombies and turn them into runner zombie.

If it doesn't, make sure your plugin is installed and that the 'sm_all_runner_enable' value is 1. You can also try starting a new round or restarting the server

The crawler transition is enabled by default, and you can turn off the crawler as a runner zombie by setting the parameter 'sm_all_runner_conversion_crawler 0'


## Cvars

<pre>
sm_all_runner_enable                -   default:  1   -   Whether to enable the plugins
sm_all_runner_transform_crawler     -   default:  1   -   Whether to transform the crawler
sm_all_runner_set_health_runner     -   default:  0   -   Set the runner HP (0=Auto match difficulty)
sm_all_runner_set_health_kid        -   default:  0   -   Set the kid HP (0=Auto match difficulty)
sm_all_runner_set_health_turned     -   default:  0   -   Set the turned HP (0=Auto match difficulty)
sm_all_runner_set_health_crawler    -   default:  0   -   Set the amount of health that crawler zombie converts to runner (0=Auto match difficulty)
sm_all_runner_set_health_normal     -   default:  0   -   Set the amount of health that normal zombie converts to runner (0=Auto match difficulty)
sm_all_runner_runner_dmg_onehand    -   default:  20  -   Damage runner zombie does with one handed attacks
sm_all_runner_runner_dmg_twohand    -   default:  40  -   Damage runner zombie does with two handed attacks
sm_all_runner_kid_dmg_onehand       -   default:  8   -   Damage kid zombie does with one handed attacks
sm_all_runner_kid_dmg_twohand       -   default:  16  -   Damage kid zombie does with two handed attacks
</pre>


## Differences with NMRiH Diffmoder

I don't know much about NMRIH Diffmoder, so far there are differences

NMRiH Diffmoder

- Pattern customization is achieved by first deleting normal zombies and then generating a new zombie.

- The number of zombies generated in this way seems to be less than in the original mode, and there may be cases where they are no longer refreshed.

All Runner

- The total number of zombies is the same as the original: it does not erase the zombies first and then spawn a new zombie, but directly transforms ordinary zombies into runner zombie.

- It's more difficult: If a map constantly refreshes normal zombies, there will be a steady stream of runner zombie

- Support to set whether to transform crawler, health after each zombie transforms into runner zombie, damage caused by runner zombie and kid zombie.

- It only supports being able to transform into a runner zombie, but cannot be transformed into a kid zombie for the time being
