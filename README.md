# Canny Edge Detection Base on Xilinx FPGA



如下图所示，Testbench对本地bmp图片进行canny边缘检测，可用于主流摄像头的实时边缘检测

有完整C++实现代码，PPT里面有算法具体实现的思路。

matlab跟visio没写怎么完整，之前仿真验证的时候用过一下，代码忘记放哪里了，欢迎提交补充。

没有用IP核，市面上3*3的卷积窗使用FIFO实现的，并应用了cordic算法求梯度强度与角度，可以通过选择流水等级实现高精准度，不过在canny算法中没什么大意义。

走过路过，不要忘记点赞关注订阅哟！

## RTL代码测试：

1. 创建VIVADO工程，添加src里边的文件

3. 开始仿真

4. 选择仿真13ms波形（要等好一会）

   tips：要进行Canny检测的图片可以经过win10自带的3D绘图保存至bmp，大小一般为9k。

![monkey](pic/monkey.bmp)

![canny_demo](pic/canny_demo.bmp)
