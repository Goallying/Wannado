//
//  UIImage+opencv.m
//  Wannado
//
//  Created by admin on 2023/8/25.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/photo/legacy/constants_c.h>
#import <opencv2/imgcodecs/ios.h>

#import "UIImage+OpenCV.h"

using namespace cv;

@implementation UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (cv::Mat)cvMatRepresentationColor
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat color(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(color.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    color.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return color;
}


- (cv::Mat)cvMatRepresentationGray
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    int cols = self.size.width;
    int rows = self.size.height;
    
    Mat gray(rows, cols, CV_8UC1);
    
    NSLog(@"cols %d rows %d step %zu", cols, rows, gray.step[0]);
    CGContextRef contextRef = CGBitmapContextCreate(gray.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    gray.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return gray;
}



- (UIImage *)inpaint:(CGRect)rect {
    
    CGFloat screenScale = [UIScreen mainScreen].scale ;
    CGFloat scale = 1 ;
//    NSLog(@"image size = %@ \n scale = %.f", NSStringFromCGSize(self.size), scale);
    CGRect newRect = CGRectMake(rect.origin.x * scale,rect.origin.y * scale,rect.size.width * scale,rect.size.height * scale) ;

    Mat imageMat = self.cvMatRepresentationColor;
    cv::Rect roiRect = cv::Rect(cv::Rect(newRect.origin.x,newRect.origin.y,newRect.size.width,newRect.size.height));

//    0 <= roi.x && 0 <= roi.width && roi.x + roi.width <= m.cols && 0 <= roi.y && 0 <= roi.height && roi.y + roi.height <= m.rows
    //    //制作掩膜
    cv::Mat imageMask = cv::Mat(imageMat.size(),CV_8UC1,cv::Scalar::all(0));
    cv::Mat roiImage = cv::Mat(roiRect.size(),CV_8UC1,cv::Scalar::all(255));
    roiImage.copyTo(imageMask(roiRect));
    //通道转换
    IplImage imageIpl = cvIplImage(imageMat);
    IplImage *img3chan = cvCreateImage(cvGetSize(&imageIpl),imageIpl.depth,3);
    cvCvtColor(&imageIpl,img3chan,CV_RGBA2RGB);//CV_RGBA2RGB表示4通道转成3通道
    CvMat *cvMat = cvCreateMat(imageIpl.height, imageIpl.width, CV_8UC3);//创建容器区域
    cvConvert(img3chan, cvMat);
    cv::Mat imageMat3chan = cv::cvarrToMat(cvMat);
    //图像修复
    cv::Mat dst;
    cv::inpaint(imageMat3chan, imageMask, dst, 9, cv::INPAINT_TELEA);

    UIImage *imageResult = MatToUIImage(dst);
    return imageResult;
}
@end
