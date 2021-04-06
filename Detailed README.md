# FlappyLearning-MATLAB
Inspired by [xviniette](https://github.com/xviniette/FlappyLearning). Flappy Bird now learns and flys in MATLAB. With Neuroevolution. [Demo(bilibili.com)](https://www.bilibili.com/video/BV1xy4y1i73s/)  

![alt tag](https://github.com/lincolnqiu/FlappyLearning-MATLAB/blob/main/Screenshot.png)  

This is the final assignment of my freshman year's course ***Introduction to Computers***, whose requirement is ***Using Matlab and Matlab only***. When I first searched for relevant projects, there is only "[Flappy Bird Game in Matlab](https://github.com/mingjingz/flappybird-for-matlab)", "[Neuroevolution in Matlab](https://github.com/matthp/NeuroEvolution)", or "[FlappyLearning in JS](https://github.com/xviniette/FlappyLearning)". What I propose is "[FlappyLearning using Neuroevolution in MATLAB](https://github.com/lincolnqiu/FlappyLearning-MATLAB)". Very well, time to sweat.  

The project features certain improvements, but it generally converges slower than [xviniette](https://github.com/xviniette/FlappyLearning)'s for some unknown reason. Nonetheless, it does the trick.

Runs well on R2020b.  

## Features
* Adds variable `regenerateFlag` together with `shitCount`. The core idea is to prevent underfitting. The training time of neuroevolution depends largely on the initial weights. With a set of poorly-initialized weights you may have a hundred of generations cannot pass the first tunnel. Therefore, `shitCount` counts these aren't-so-smart generations and if it hits a constant, say, 20, it will set `regenerateFlag` to `True` where the next generation will operate on a set of newly-initialized weights.
* Reduced complexity. The structure looks more intuitive. But the network's universality is also reduced, for that certain functions are tailored.
* Prints out each generation's weights matrix and the randomly generated middle position of the pipe.
* MATLAB is a great tool, but its graphics sucks when like 50 birds are hanging around simultaneously, which makes the speed control panel actually useless.


## Deficiency
* `NeuroEvo.elitism`, `NeuroEvo.randomBehaviour` should be dynamic and alter with respect to the derivative of `Game.maxScore`. Probably.
* Input parameters could be improved. Maybe adding the distance between the bird and the next pipe will lead to a faster convergence process.
![alt tag](https://github.com/lincolnqiu/FlappyLearning-MATLAB/blob/main/Illustration.png)
(Image in courtesy of [xviniette - FlappyLearning](https://github.com/xviniette/FlappyLearning))


## Random Thoughts
The essence of all this is that we abstracted a model from reality(Natural Selection), then conversely what enlightenment can this model tell us?
I reckon that how a generation of birds fail to pass the next tunnel insinuate the status quo of human breeding, that every tunnel, in our term, is a big problem human is facing, like illness. To break through these problems we have to evolve for a very long period of time. But what if there is a problem human cannot solve? I think there exist 2 possible outcome. 1. We evolve into higher-dimentional creatures, just like Christopher Nolan's *Interstellar*. 2. `regenerateFlag =  True`. Just like dinosaurs.

Albert Einstein once said that "We cannot solve our problems with the same thinking we used when we created them."


## Reference
Without these my homework wouldn't have been possible. Massive Appreciation.
* [xviniette - FlappyLearning](https://github.com/xviniette/FlappyLearning)
* [mingjingz - flappybird-for-matlab](https://github.com/mingjingz/flappybird-for-matlab)
* [3blue1brown - But what is a Neural Network?](https://youtu.be/aircAruvnKk)
* [MorvanZhou - Evolutionary-Algorithm](https://github.com/MorvanZhou/Evolutionary-Algorithm)  
* [机器学习玩转Flappy Bird全书：六大流派从原理到代码](https://zhuanlan.zhihu.com/p/25719115)  


## Author
Qiu Yining, a freshman majoring in mathematics *@Shanghai University of Finance and Economics*.  
Personal Mailbox: *lincolnqiu@gmail.com*
