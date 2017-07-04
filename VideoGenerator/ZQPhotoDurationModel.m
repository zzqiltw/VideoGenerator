//
//  ZQPhotoDurationModel.m
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/4.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ZQPhotoDurationModel.h"

@implementation ZQPhotoDurationModel

+ (instancetype)photoDurationModelWithImage:(UIImage *)image duration:(CGFloat)duration
{
    ZQPhotoDurationModel *model = [ZQPhotoDurationModel new];
    
    model.image = image;
    model.duration = duration;
    
    return model;
}

@end
