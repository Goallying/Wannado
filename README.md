# Wannado

2023.08 ~ unknown
开发基于openCV的视频去水印

2023.08  
#Sample code API

//- (void)handleInpaint{
//
//    Mat img0 = [self cvMatRepresentationColor];//
//    IplImage img = cvIplImage(img0);
//    IplImage *img3chan = cvCreateImage(cvGetSize(&img),img.depth, 3);
//    cvCvtColor(&img,img3chan,CV_RGBA2RGB);
//    CvMat *cvMat = cvCreateMat(img.height, img.width, CV_8UC3);
//    cvConvert(img3chan, cvMat);
//    Mat img2 = cv::cvarrToMat(cvMat);
//    Mat inpaintMask = Mat::zeros(img2.size(), CV_8U);
//
//    Vector<Mat> res = inpaintImage(img0,inpaintMask);
//    if(res.size() >= 2){
//        self.imgV.image = [UIImage imageFromCVMat:res[0]];
//        self.imgV0.image = [UIImage imageFromCVMat:res[1]];
//    }
//}
//
//Vector<Mat> inpaintImage(Mat&img0,Mat&inpaintMask){
//    Vector<Mat>res_imgs;
//    if(img0.empty()){
//        return res_imgs;
//    }
//    Mat img = img0.clone();
//    Mat inpainted;
//    inpaint(img, inpaintMask, inpainted, 3, INPAINT_TELEA);
//    res_imgs.push_back(inpainted);
//    res_imgs.push_back(inpaintMask);
////    imshow("修复后", inpainted);
////    imshow("图像掩码",inpaintMask);
//    return res_imgs;
//}
<!--const cv::String thisPath = (const cv::String)filePathC;-->
<!--const char*  c_input_path = [inputPath cStringUsingEncoding:NSMacOSRomanStringEncoding];-->
<!--cv::Mat img = cv::imread(c_input_path, cv::IMREAD_COLOR);-->
<!--cv::imwrite(thisPath, imageMat3chan);-->
<!--cv::threshold(mask, mask, 230, 255, cv::THRESH_BINARY);-->
