#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui_c.h>
#include <iostream>
#include <math.h>

#define M_PI 3.14159265358979323846

using namespace cv;
void gaussianConvolution(Mat& img, Mat& dst);
void gaussianFilter(Mat& img, Mat& dst);
void getGrandient(Mat& img, Mat& gradXY, Mat& theta);
void nonLocalMaxValue(Mat& gradXY, Mat& theta, Mat& dst);
void doubleThresholdLink(Mat& img);
void doubleThreshold(double low, double high, Mat& img, Mat& dst);
int main(int argc, char** argv) {
	Mat src;
	src = imread("../5.Pic/monkey.bmp");
	if (!src.data) {
		printf("could not load image...\n");
		return -1;
	}
	namedWindow("input image", CV_WINDOW_AUTOSIZE);
	imshow("input image", src);

	Mat gray_src;
	cvtColor(src, gray_src, CV_BGR2GRAY);
	imshow("gray image", gray_src);

	Mat gray_binary;
	threshold(gray_src, gray_binary, 125, 255, cv::THRESH_BINARY_INV);
	imshow("binary image", gray_binary);

	Mat gaussian_gray_src;
	gaussianFilter(gray_src, gaussian_gray_src);
	imshow("gaussian_gray_src image", gaussian_gray_src);

	Mat gradXY_src;
	Mat	theta_src;
	getGrandient(gaussian_gray_src, gradXY_src, theta_src);
	imshow("gradXY_src image", gradXY_src);

	Mat	nonLocalMaxValue_src;
	nonLocalMaxValue(gradXY_src, theta_src, nonLocalMaxValue_src);
	imshow("nonLocalMaxValue_src image", nonLocalMaxValue_src);

	Mat	doubleThreshold_src;
	doubleThreshold(30, 60, nonLocalMaxValue_src, doubleThreshold_src);
	imshow("doubleThreshold_src image", doubleThreshold_src);

	waitKey(0);
	return 0;
}

void doubleThreshold(double low, double high, Mat& img, Mat& dst) {
	dst = img.clone();

	// 区分出弱边缘点和强边缘点
	for (int j = 0; j < img.rows - 1; j++) {
		for (int i = 0; i < img.cols - 1; i++) {
			double x = double(dst.ptr<uchar>(j)[i]);
			// 像素点为强边缘点，置255
			if (x > high) {
				dst.ptr<uchar>(j)[i] = 255;
			}
			// 像素点置0，被抑制掉
			else if (x < low) {
				dst.ptr<uchar>(j)[i] = 0;
			}
		}
	}

	// 弱边缘点补充连接强边缘点
	doubleThresholdLink(dst);
}

void doubleThresholdLink(Mat& img) {
	// 循环找到强边缘点，把其领域内的弱边缘点变为强边缘点
	for (int j = 1; j < img.rows - 2; j++) {
		for (int i = 1; i < img.cols - 2; i++) {
			// 如果该点是强边缘点
			if (img.ptr<uchar>(j)[i] == 255) {
				// 遍历该强边缘点领域
				for (int m = -1; m < 1; m++) {
					for (int n = -1; n < 1; n++) {
						// 该点为弱边缘点（不是强边缘点，也不是被抑制的0点）
						if (img.ptr<uchar>(j + m)[i + n] != 0 && img.ptr<uchar>(j + m)[i + n] != 255) {
							img.ptr<uchar>(j + m)[i + n] = 255; //该弱边缘点补充为强边缘点
						}
					}
				}
			}
		}
	}

	for (int j = 0; j < img.rows - 1; j++) {
		for (int i = 0; i < img.cols - 1; i++) {
			// 如果该点依旧是弱边缘点，及此点是孤立边缘点
			if (img.ptr<uchar>(j)[i] != 255 && img.ptr<uchar>(j)[i] != 0) {
				img.ptr<uchar>(j)[i] = 0; //该孤立弱边缘点抑制
			}
		}
	}
}

void nonLocalMaxValue(Mat& gradXY, Mat& theta, Mat& dst) {
	dst = gradXY.clone();
	for (int j = 1; j < gradXY.rows - 1; j++) {
		for (int i = 1; i < gradXY.cols - 1; i++) {
			double t = double(theta.ptr<uchar>(j)[i]);
			double g = double(dst.ptr<uchar>(j)[i]);
			if (g == 0.0) {
				continue;
			}
			double g0, g1;
			if ((t >= -(3 * M_PI / 8)) && (t < -(M_PI / 8))) {
				g0 = double(dst.ptr<uchar>(j - 1)[i - 1]);
				g1 = double(dst.ptr<uchar>(j + 1)[i + 1]);
			}
			else if ((t >= -(M_PI / 8)) && (t < M_PI / 8)) {
				g0 = double(dst.ptr<uchar>(j)[i - 1]);
				g1 = double(dst.ptr<uchar>(j)[i + 1]);
			}
			else if ((t >= M_PI / 8) && (t < 3 * M_PI / 8)) {
				g0 = double(dst.ptr<uchar>(j - 1)[i + 1]);
				g1 = double(dst.ptr<uchar>(j + 1)[i - 1]);
			}
			else {
				g0 = double(dst.ptr<uchar>(j - 1)[i]);
				g1 = double(dst.ptr<uchar>(j + 1)[i]);
			}

			if (g <= g0 || g <= g1) {
				dst.ptr<uchar>(j)[i] = 0.0;
			}
		}
	}
}

void getGrandient(Mat& img, Mat& gradXY, Mat& theta) {
	gradXY = Mat::zeros(img.size(), CV_8U);
	theta = Mat::zeros(img.size(), CV_8U);

	for (int j = 1; j < img.rows - 1; j++) {
		for (int i = 1; i < img.cols - 1; i++) {
			double gradY = double(img.ptr<uchar>(j - 1)[i - 1] + 2 * img.ptr<uchar>(j - 1)[i] + img.ptr<uchar>(j - 1)[i + 1] \
				- img.ptr<uchar>(j + 1)[i - 1] - 2 * img.ptr<uchar>(j + 1)[i] - img.ptr<uchar>(j + 1)[i + 1]);
			double gradX = double(img.ptr<uchar>(j - 1)[i + 1] + 2 * img.ptr<uchar>(j)[i + 1] + img.ptr<uchar>(j + 1)[i + 1] \
				- img.ptr<uchar>(j - 1)[i - 1] - 2 * img.ptr<uchar>(j)[i - 1] - img.ptr<uchar>(j + 1)[i - 1]);

			gradXY.ptr<uchar>(j)[i] = sqrt(gradX * gradX + gradY * gradY); //计算梯度
			theta.ptr<uchar>(j)[i] = atan(gradY / gradX); //计算梯度方向
		}
	}
}


//void getGrandient(Mat& img, Mat& gradXY, Mat& theta) {
//	gradXY = Mat::zeros(img.size(), CV_8U);
//	theta = Mat::zeros(img.size(), CV_8U);
//
//	for (int i = 0; i < img.rows - 1; i++) {
//		for (int j = 0; j < img.cols - 1; j++) {
//			double p = (img.ptr<uchar>(j)[i + 1] - img.ptr<uchar>(j)[i] + img.ptr<uchar>(j + 1)[i + 1] - img.ptr<uchar>(j + 1)[i]) / 2;
//			double q = (img.ptr<uchar>(j + 1)[i] - img.ptr<uchar>(j)[i] + img.ptr<uchar>(j + 1)[i + 1] - img.ptr<uchar>(j)[i + 1]) / 2;
//			gradXY.ptr<uchar>(j)[i] = sqrt(p * p + q * q); //计算梯度
//			theta.ptr<uchar>(j)[i] = atan(q / p);
//		}
//	}
//}

void gaussianFilter(Mat& img, Mat& dst) {
	// 对水平方向进行滤波
	Mat dst1 = img.clone();
	gaussianConvolution(img, dst1);
	//图像矩阵转置
	Mat dst2;
	transpose(dst1, dst2);
	// 对垂直方向进行滤波
	Mat dst3 = dst2.clone();
	gaussianConvolution(dst2, dst3);
	// 再次转置
	transpose(dst3, dst);
}

void gaussianConvolution(Mat& img, Mat& dst) 
{
	int nr = img.rows;
	int nc = img.cols;
	int templates[3] = { 1, 2, 1 };

	// 按行遍历除每行边缘点的所有点
	for (int j = 0; j < nr; j++) 
	{
		uchar* data = img.ptr<uchar>(j); //提取该行地址
		for (int i = 1; i < nc - 1; i++) 
		{
			int sum = 0;
			for (int n = 0; n < 3; n++) 
			{
				sum += data[i - 1 + n] * templates[n]; //相称累加
			}
			sum /= 4;
			dst.ptr<uchar>(j)[i] = sum;
		}
	}
}
