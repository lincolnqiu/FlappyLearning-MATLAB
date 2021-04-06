# FlappyLearning-MATLAB
Inspired by [xviniette](https://github.com/xviniette/FlappyLearning). Flappy Birds now learn and fly in MATLAB. [Demo(bilibili.com)](https://www.bilibili.com/video/BV1xy4y1i73s/)  

![alt tag](https://github.com/lincolnqiu/FlappyLearning-MATLAB/blob/main/Screenshot.png)  
This is the final assignment of my freshman year's course ***Introduction to Computers***, whose requirement is ***Using Matlab and Matlab only***. When I first searched for relevant projects, there is only "[Flappy Bird Game in Matlab](https://github.com/mingjingz/flappybird-for-matlab)", "[Neuroevolution in Matlab](https://github.com/matthp/NeuroEvolution)", or "[FlappyLearning in JS](https://github.com/xviniette/FlappyLearning)". What I propose is "[FlappyLearning using Neuroevolution in MATLAB](https://github.com/lincolnqiu/FlappyLearning-MATLAB)". Very well, time to sweat.  
The project features certain improvements, but it generally converges slower than [xviniette](https://github.com/xviniette/FlappyLearning)'s for some unknown reason. Nonetheless, it does the trick.  

## Features
* Adds variable `regenerateFlag` together with `shitCount`. The core idea is to prevent underfitting. The training time of neuroevolution depends largely on the initial weights. With a poorly-initialized weights you may have a hundred of generations cannot pass the first tunnel. Therefore, `shitCount` counts these aren't-so-smart generations and if it hits a constant, say, 20, it will set `regenerateFlag` to `True` where the next generation will operate on a set of newly-initialized weights.
* Reduced complexity. The structure looks more intuitive. But the network's universality is also reduced, for that certain functions are tailored.
* MatLab is a great tool, but its graphics sucks when like 50 birds are hanging around simultaneously, which makes the speed control panel actually useless.

## Reference
Without these my homework wouldn't have been possible. Massive Appreciation.
* [xviniette - FlappyLearning](https://github.com/xviniette/FlappyLearning)
* [mingjingz - flappybird-for-matlab](https://github.com/mingjingz/flappybird-for-matlab)
* [3blue1brown - But what is a Neural Network?](https://youtu.be/aircAruvnKk)
* [MorvanZhou - Evolutionary-Algorithm](https://github.com/MorvanZhou/Evolutionary-Algorithm)  
* [机器学习玩转Flappy Bird全书：六大流派从原理到代码](https://zhuanlan.zhihu.com/p/25719115)  

## Author
Qiu Yining, a freshman majoring in mathematics *@Shanghai University of Finance and Economics*.  
Personal Mailbox: *linconqiu@qq.com*
