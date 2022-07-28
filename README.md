# Canny Edge Detection Base on Xilinx FPGA



如下图所示，Testbench对本地bmp图片进行canny边缘检测，可用于主流摄像头的实时边缘检测（可适用正点原子的相关VIP图像处理模块）

## RTL代码测试：

1. 创建Modelsim工程文件

2. 将RTL代码加入工程、编译

3. 开始仿真，在命令行输入：run 13000000

4. 等待仿真13s（要等一会）

   tips：要进行Canny检测的图片可以经过win10自带的3D绘图保存至bmp，大小一般为9k。

![monkey](modelsim_tb/pic/monkey.bmp)

![canny_demo](modelsim_tb/pic/canny_demo.bmp)

tips:代码基于市面上开源方案修改而成,
