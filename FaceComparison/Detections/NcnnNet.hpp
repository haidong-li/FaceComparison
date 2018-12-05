//
//  NcnnNet.hpp
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#ifndef NcnnNet_hpp
#define NcnnNet_hpp

#include <stdio.h>
#import <ncnn/net.h>
#import <opencv2/opencv.hpp>
//#include "mobilefacenet.mem.h"
//#include "mobilefacenet.id.h"

class NCNNNet {
public:
    bool LoadFeaturesModel(const char *param ,const char *bin);
    ncnn::Mat getFaceFeatures(cv::Mat face);
};

#endif /* NcnnNet_hpp */
