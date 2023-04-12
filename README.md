# Canny Edge Detection Base on Xilinx FPGA

![monkey](pic/monkey.bmp)

![canny](pic/canny.bmp)

### Introduction:

​	这个工程是基于FPGA的Canny边缘检测系统的实现，并未使用一些IP，其中应用了cordic算法求梯度强度与角度，可通过选择流水等级实现高精准度，卷积窗利用FIFO实现，所有代码由Verilog编写，将很便利的移植到各种开发平台上，如Altera与Xilinx的各类型号fpga，其中**主要**的工程文件如下:

- ***pic***

- ***QuestaSim***

- ***canny_edge_detection***

​	其中**pic**文件夹存放着用来仿真及结果存储的仿真图像，**QuestaSim**文件夹中存放着Modelsim仿真的工程（仅仅是Modelsim的工程文件），**CannyEdgeDetection**文件夹为整个vivado工程。

​	考虑到Vivado的工程太大，所以用了如下的**.gitignore**，仅仅上传了保存着有源码的src文件夹

```
.gitignore

CannyEdgeDetection/*
!CannyEdgeDetection/ov5640_img_process.srcs
```

​	可按照***CannyEdgeDetection***的名字创建一个工程，并将源码加入新创建的工程。



### Tips：

​	本工程中的仿真文件中读取bmp与保存bmp用的读取函数都是使用***相对路径***，如果不想自己重新切换下路径的话，上述三个文件夹及Vivado工程创建路径需与此教程一致。

​	本工程中modelsim与vivado可以使用***Modelsim Simulator***或者***Vivado Simulator***自带的仿真器进行仿真，在创建vivado工程时记得加入***canny_header***，modelsim工程中不要添加该头文件，即可实现两个仿真器随意运行。工程需仿真***14ms***才能出现结果，Vivado仿真比较慢，推荐使用Modelsim仿真。

​	要进行Canny检测的图片需经过win10自带的3D绘图保存为640*480大小的bmp，可以查看大小是否为9k来验证图片是否可以应用仿真。

​	有完整C++实现代码，PPT里面有算法具体实现的思路，matlab跟visio没写怎么完整，之前仿真验证的时候用过一下，代码忘记放哪里了，欢迎提交补充。

**走过路过，不要忘记点赞关注订阅哟！**



