//
//  UINavigationController+Base.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/20.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "UINavigationController+Base.h"
#import <objc/runtime.h>
@implementation UINavigationController (Base)
+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [self methodSwizzlingWithOriginalSelector:@selector(pushViewController:animated:) bySwizzledSelector:@selector(replacePushViewController:animated:)];
        
    });
}
- (void)replacePushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(0, 0, 44, 44);
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        viewController.navigationItem.leftBarButtonItem = backItem;
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [self replacePushViewController:viewController animated:animated]; self.interactivePopGestureRecognizer.delegate = nil;
    
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
    
}

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        
        class_replaceMethod(class,swizzledSelector,method_getImplementation(originalMethod),                             method_getTypeEncoding(originalMethod));
        
    } else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
}


@end
