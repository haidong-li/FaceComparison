# FaceComparison
This project include face-deteciton face-landmarks  face-align  and face-recgnition; It is a  relatively complete project！

# ~~framework 先不公开了~~  目前限制framewok使用24 小时，大佬们简单的玩玩就好
# Step 1. Star please 🌟🌟🌟🌟🌟

### ！！！I deleted opencv ,it is huge ，please download [openCV](https://opencv.org/releases.html)
### the project for iPad

![image](https://github.com/HuiFeiDeDaMaHou/FaceComparison/blob/master/Images/2.png)
![image](https://github.com/HuiFeiDeDaMaHou/FaceComparison/blob/master/Images/3.png)



# 人脸识别流程
- 1.发现人脸
- 2.关键点检测
- 3.确定人脸姿态
- 4.特征抽取
- 5.根据姿态对比相应的特征

> 这里就展示过多的代码了，没有太多的意义，关键的部分我封装起了一个HDFaceDetection.framework，里面暴露了很多功能，接口注释也写的比较清楚，真机debug版本。

# 用到的库
- 1.ncnn 鹅场大佬写的对移动端适配很好的深度学习框架。ps:别问我关于深度学习的，我不懂，只会用
- 2.opencv 视觉处理框架 带ios转换的那个版本哦
- 3.一颗执著的❤️


# Enjot it & Star 🌟🌟🌟🌟🌟

## 2019年4月9日 更新
> 1.增加多角度信息采集信息，多角度人脸比对

> 2.增加多人脸同时识别

> 3.人员信息框的UI

#### 存在问题 
> 1.脸部姿态计算很粗糙，由于关键点个数不够，没法计算

> 2.由于多角度，姿态不准等原因，有误识概率
