//
//  FacePostTool.m
//  FaceComparison
//
//  Created by 李海冬 on 2018/12/19.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "FacePostTool.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "Quaterniond.h"

@implementation FacePostTool

+ (UIImage *)facePostion:(NSArray <NSValue *>*)landmarks image:(UIImage *)image faceRect:(CGRect)faceRect
{
    std::vector<cv::Point2d>image_points;
    
    image_points.push_back(cv::Point2d((int)[landmarks[2] CGPointValue].x,(int)[landmarks[2] CGPointValue].y));    // Nose tip
    image_points.push_back(cv::Point2d((int)[landmarks[0] CGPointValue].x,(int)[landmarks[0] CGPointValue].y));
    image_points.push_back(cv::Point2d((int)[landmarks[1] CGPointValue].x,(int)[landmarks[1] CGPointValue].y));
    image_points.push_back(cv::Point2d((int)[landmarks[3] CGPointValue].x,(int)[landmarks[3] CGPointValue].y));
    image_points.push_back(cv::Point2d((int)[landmarks[4] CGPointValue].x,(int)[landmarks[4] CGPointValue].y));
    
    // 3D model points.
    std::vector<cv::Point3d>model_points;
    
    model_points.push_back(cv::Point3d(0.0f,0.0f,0.0f));              // Nose tip
    
    model_points.push_back(cv::Point3d(0.0f,-330.0f, -65.0f));          //Chin
    
    model_points.push_back(cv::Point3d(-215.0f,170.0f, -135.0f));       // Left eye left corner
    
    model_points.push_back(cv::Point3d(215.0f,170.0f, -135.0f));        // Right eye rightcorner
    
    model_points.push_back(cv::Point3d(-150.0f,-150.0f, -125.0f));      // Left Mouth corner
    
    model_points.push_back(cv::Point3d(150.0f,-150.0f, -125.0f));       // Right mouth corner
    
    
    std::vector<cv::Point2d> landmarks_c;
    
    //
    //    //mouth left
    //    float mouth_left_x = [landmarks[3] CGPointValue].x;
    //    float mouth_left_y = [landmarks[3] CGPointValue].y;
    //    //mouth right
    //    float mouth_right_x = [landmarks[4] CGPointValue].x;
    //    float mouth_right_y = [landmarks[4] CGPointValue].y;
    //    //mouth center
    //    float mouth_center_x = (mouth_left_x + mouth_right_x) / 2;
//    
//    landmarks_c.push_back(cv::Point2d((int)[landmarks[2] CGPointValue].x,(int)[landmarks[2] CGPointValue].y));    // Nose tip
//    landmarks_c.push_back(cv::Point2d((int)[landmarks[0] CGPointValue].x,(int)[landmarks[0] CGPointValue].y));
//    landmarks_c.push_back(cv::Point2d((int)[landmarks[1] CGPointValue].x,(int)[landmarks[1] CGPointValue].y));
//    landmarks_c.push_back(cv::Point2d((int)[landmarks[3] CGPointValue].x,(int)[landmarks[3] CGPointValue].y));
//    landmarks_c.push_back(cv::Point2d((int)[landmarks[4] CGPointValue].x,(int)[landmarks[4] CGPointValue].y));
    
    
    cv::Mat im;
    UIImageToMat(image, im);
    
    double focal_length = im.cols; // Approximate focal length.
    cv::Point2d center = cv::Point2d(im.cols / 2, im.rows / 2);
    cv::Mat camera_matrix = (cv::Mat_<double>(3, 3) << focal_length, 0, center.x, 0, focal_length, center.y, 0, 0, 1);
    cv::Mat dist_coeffs = cv::Mat::zeros(4, 1, cv::DataType<double>::type); // Assuming no lens distortion
    
    cv::Mat rotation_vector; // Rotation in axis-angle form
    cv::Mat translation_vector;
    
    // Solve for pose
    cv::solvePnP(model_points,image_points, camera_matrix, dist_coeffs, rotation_vector, translation_vector);
    

    //calculate rotation angles
    double theta = cv::norm(rotation_vector, CV_L2);
    
    
    
    std::vector<cv::Point3d>nose_end_point3D;
    
    std::vector<cv::Point2d>nose_end_point2D;
    
    nose_end_point3D.push_back(cv::Point3d(0,0,1000.0));
    
    
    
    projectPoints(nose_end_point3D,rotation_vector, translation_vector, camera_matrix, dist_coeffs,nose_end_point2D);
    
    
    for(int i=0; i< image_points.size(); i++)
        
    {
        
        circle(im,image_points[i], 3, cv::Scalar(0,0,255), -1);
        
    }
    
    
    
    cv::line(im,image_points[0],nose_end_point2D[0], cv::Scalar(255,0,0), 2);
    
    
    
    
    for(int i=0; i< image_points.size(); i++)
        
    {
        
        circle(im,image_points[i], 3, cv::Scalar(0,0,255), -1);
        
    }
    
    
    
//    cv::line(im,image_points[0],nose_end_point2D[0], cv::Scalar(255,0,0), 2);
    

    
    //transformed to quaterniond
    Quaterniond *q = [[Quaterniond alloc] init];
    q.w = cos(theta / 2);
    q.x = sin(theta / 2)*rotation_vector.at<double>(0, 0) / theta;
    q.y = sin(theta / 2)*rotation_vector.at<double>(0, 1) / theta;
    q.z = sin(theta / 2)*rotation_vector.at<double>(0, 2) / theta;
    
    
    double roll,yaw,pitch;
    
    [self quaterniondToEulerAngle:q roll:roll yaw:yaw pitch:pitch];
    NSLog(@"roll is %.2f   yaw is %.2f   pitch is %.2f",roll / M_PI * 180,yaw/ M_PI * 180,pitch/ M_PI * 180);
    
    return MatToUIImage(im);
}

- (void)facePostion:(NSArray <NSValue *>*)landmarks image:(UIImage *)image
{
    // 3D model points.
    std::vector<cv::Point3d> model_points;
    cv::Point2f left_eye(38, 52);
    cv::Point2f right_eye(74, 52);
    model_points.push_back(cv::Point3d(0.0f, 0.0f, 0.0f));               // Nose tip
//    model_points.push_back(cv::Point3d(0.0f, -330.0f, -65.0f));          // Chin
    model_points.push_back(cv::Point3d(-215.0f, 170.0f, -135.0f));       // Left eye left corner
    model_points.push_back(cv::Point3d(215.0f, 170.0f, -135.0f));        // Right eye right corner
    model_points.push_back(cv::Point3d(-150.0f, -150.0f, -125.0f));      // Left Mouth corner
    model_points.push_back(cv::Point3d(150.0f, -150.0f, -125.0f));       // Right mouth corner
    
    
    std::vector<cv::Point2d> landmarks_c;
   
//
//    //mouth left
//    float mouth_left_x = [landmarks[3] CGPointValue].x;
//    float mouth_left_y = [landmarks[3] CGPointValue].y;
//    //mouth right
//    float mouth_right_x = [landmarks[4] CGPointValue].x;
//    float mouth_right_y = [landmarks[4] CGPointValue].y;
//    //mouth center
//    float mouth_center_x = (mouth_left_x + mouth_right_x) / 2;
    
    landmarks_c.push_back(cv::Point2d((int)[landmarks[2] CGPointValue].x,(int)[landmarks[2] CGPointValue].y));    // Nose tip
    landmarks_c.push_back(cv::Point2d((int)[landmarks[0] CGPointValue].x,(int)[landmarks[0] CGPointValue].y));
    landmarks_c.push_back(cv::Point2d((int)[landmarks[1] CGPointValue].x,(int)[landmarks[1] CGPointValue].y));
    landmarks_c.push_back(cv::Point2d((int)[landmarks[3] CGPointValue].x,(int)[landmarks[3] CGPointValue].y));
    landmarks_c.push_back(cv::Point2d((int)[landmarks[4] CGPointValue].x,(int)[landmarks[4] CGPointValue].y));
    
    
    cv::Mat im;
    UIImageToMat(image, im);
    
    double focal_length = im.cols; // Approximate focal length.
    cv::Point2d center = cv::Point2d(im.cols / 2, im.rows / 2);
    cv::Mat camera_matrix = (cv::Mat_<double>(3, 3) << focal_length, 0, center.x, 0, focal_length, center.y, 0, 0, 1);
    cv::Mat dist_coeffs = cv::Mat::zeros(4, 1, cv::DataType<double>::type); // Assuming no lens distortion
    
    cv::Mat rotation_vector; // Rotation in axis-angle form
    cv::Mat translation_vector;
    
    // Solve for pose
    cv::solvePnP(model_points, landmarks_c, camera_matrix, dist_coeffs, rotation_vector, translation_vector);
   
    //calculate rotation angles
    double theta = cv::norm(rotation_vector, CV_L2);
    
    //transformed to quaterniond
    Quaterniond *q = [[Quaterniond alloc] init];
    q.w = cos(theta / 2);
    q.x = sin(theta / 2)*rotation_vector.at<double>(0, 0) / theta;
    q.y = sin(theta / 2)*rotation_vector.at<double>(0, 1) / theta;
    q.z = sin(theta / 2)*rotation_vector.at<double>(0, 2) / theta;
    
    
    double roll,yaw,pitch;
    
//    [self quaterniondToEulerAngle:q roll:roll yaw:yaw pitch:pitch];
    NSLog(@"roll is %.2f   yaw is %.2f   pitch is %.2f",roll / M_PI * 180,yaw/ M_PI * 180,pitch/ M_PI * 180);
    
}

+ (void)quaterniondToEulerAngle:(Quaterniond *)q roll:(double &)roll yaw:(double &)yaw pitch:(double &)pitch
{

    double ysqr = q.y * q.y;
    
    // pitch (x-axis rotation)
    double t0 = +2.0 * (q.w * q.x + q.y * q.z);
    double t1 = +1.0 - 2.0 * (q.x * q.x + ysqr);
    pitch = std::atan2(t0, t1);
    
    // yaw (y-axis rotation)
    double t2 = +2.0 * (q.w * q.y - q.z * q.x);
    t2 = t2 > 1.0 ? 1.0 : t2;
    t2 = t2 < -1.0 ? -1.0 : t2;
    yaw = std::asin(t2);
    
    // roll (z-axis rotation)
    double t3 = +2.0 * (q.w * q.z + q.x * q.y);
    double t4 = +1.0 - 2.0 * (ysqr + q.z * q.z);
    roll = std::atan2(t3, t4);
}

@end
