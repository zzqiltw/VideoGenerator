//
//  ZQPhotoModelEditorViewController.h
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/7.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQPhotoDurationModel.h"

@class ZQPhotoModelEditorViewController;
@protocol ZQPhotoModelEditorViewControllerDelegate <NSObject>

@optional
- (void)photoEditorDidFinishPick:(ZQPhotoModelEditorViewController *)controller photoModels:(NSArray<ZQPhotoDurationModel *> *)photoModels;

@end

@interface ZQPhotoModelEditorViewController : UIViewController

@property (nonatomic, weak) id<ZQPhotoModelEditorViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<ZQPhotoDurationModel *> *photoModels;

@end
