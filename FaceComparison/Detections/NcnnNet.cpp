//
//  NcnnNet.cpp
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#include "NcnnNet.hpp"


#ifdef __cplusplus
extern "C" {
#endif
    static ncnn::Net features;
    
    
    bool NCNNNet::LoadFeaturesModel(const char *param ,const char *bin)
    {
        int ret1 = features.load_param(param);
        int ret2 = features.load_model(bin);
        return ret1 || ret2;
    }
    
    ncnn::Mat NCNNNet::getFaceFeatures(cv::Mat face)
    {
        ncnn::Mat in = ncnn::Mat::from_pixels(face.data, ncnn::Mat::PIXEL_BGR, face.cols, face.rows);
//        const float mean_vals[3] = {127.5f, 127.5f, 127.5f};
//        const float std_vals[3] = {0.0078125f, 0.0078125f, 0.0078125f};
//        in.substract_mean_normalize(mean_vals, std_vals);
        //        std::cout << in.w << " " << in.h << " " << in.c << std::endl;
        
        ncnn::Extractor ex = features.create_extractor();
        ex.set_light_mode(true);
        ex.set_num_threads(4);

        ex.input("data", in);
        ncnn::Mat out;
        ex.extract("fc1", out);
        
        return out;
    }
    

#ifdef __cplusplus
}
#endif
