//
//  ZQPhotoCollectionViewCell.m
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/4.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ZQPhotoCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface ZQPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation ZQPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoImageView = ({
            UIImageView *imageView = [UIImageView new];
            
            [self.contentView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.offset(0);
            }];
            
            imageView;
        });
        
        self.closeButton = ({
            UIButton *button = [UIButton new];
            
            [self.contentView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
            }];
            
            button;
        });
    }
    return self;
}

@end
