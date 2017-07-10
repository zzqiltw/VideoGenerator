//
//  ZQPhotoDurationModel.h
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/4.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPhotoDurationModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat duration; // 持续时间

@property (nonatomic, assign) BOOL selected;

+ (instancetype)photoDurationModelWithImage:(UIImage *)image duration:(CGFloat)duration;

@end
