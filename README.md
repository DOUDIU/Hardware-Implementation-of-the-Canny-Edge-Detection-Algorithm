# Canny Edge Detection Based on FPGA

![result](pic/readme_pic/result.png)

**走过路过，不要忘记点赞关注订阅哟！**

### Introduction:

​	这个工程是基于FPGA的Canny边缘检测系统的实现，并未使用一些IP，其中应用了cordic算法求梯度强度与角度，可通过选择流水等级实现高精准度，卷积窗利用FIFO实现，所有代码由Verilog编写，将很便利的移植到各种开发平台上，如Altera与Xilinx的各类型号fpga。

​	有完整C++实现代码，PPT里面有算法具体实现的思路，如有疑惑欢迎提交补充。

### Folder Structure:

​	其中***RTL工程***文件如下:

> | <font color=#004F4F>Folder</font> |             <font color=#004F4F>Function</font>              |
> | :-------------------------------: | :----------------------------------------------------------: |
> |             ***pic***             |                    #存放着用来仿真的图像                     |
> |          ***QuestaSim***          | #存放Modelsim/QuestaSim的工程（为空，需自己创建工程至此目录） |
> |             ***RTL***             |                 #存放着所有源代码及仿真代码                  |

**注**：请把modelsim工程创建到Questasim文件夹，添加RTL文件下所有源文件，选择顶层***haze_removal_tb.sv***进行仿真，工程需仿真***14ms***才能出现结果。

​	其中***验证工程***如下:

> | <font color=#004F4F>Folder</font> |     <font color=#004F4F>Function</font>      |
> | :-------------------------------: | :------------------------------------------: |
> |             ***C++***             | #基于opencv验证的canny边缘检测算法的验证方案 |

​	***PPT演示文档***如下：

https://docs.google.com/presentation/d/1ywzYQMz7mvWQlFPfZwrzZkoY8leG42afM7pXLFJ5wuY/edit?usp=sharing

如果有问题欢迎提交，如果有帮助的话，不要忘记点赞关注哦！

### Tips：

​	本工程中的仿真文件中读取bmp与保存bmp用的读取函数都是使用***相对路径***，如果不想自己重新切换下路径的话，上述三个文件夹及Vivado工程创建路径需与此教程一致。

​	本工程可以使用***Modelsim Simulator***或者***Vivado Simulator***进行仿真，仅需在仿真顶层**canny_tb.sv**的4-5两行注释另一仿真器代码，即可实现两个仿真器任意运行。但Vivado仿真比较慢，推荐使用Modelsim仿真。

​	要进行处理的图片需经过win10自带的3D绘图保存为640x480大小的bmp，可以查看大小是否为900KB来验证图片是否可以应用仿真。(可以自己算一下，每个真彩色像素是3个字节，bmp的帧头是54个字节，按照640x480算应为640x480x3+54=900KB)

**走过路过，不要忘记点赞关注订阅哟！**



