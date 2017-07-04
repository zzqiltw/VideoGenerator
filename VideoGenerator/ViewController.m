//
//  ViewController.m
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/3.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"
#import "HJImagesToVideo.h"
#import "ZQPhotoDurationModel.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<ZQPhotoDurationModel *> *photoModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    actionSheet.sender = self;
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZQPhotoDurationModel *model = [ZQPhotoDurationModel photoDurationModelWithImage:obj duration:idx+1 ];
            if (model) {
                [self.photoModels addObject:model];
            }
        }];

        [self generateVideoWithImages:self.photoModels];
    }];
    
    [actionSheet showPhotoLibrary];
}

- (void)generateVideoWithImages:(NSArray<ZQPhotoDurationModel *> *)imageModels
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/temp.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    [[HJImagesToVideo new] videoFromImages:imageModels toPath:path withSize:CGSizeMake(200, 200) withFPS:1 animateTransitions:NO withCallbackBlock:^(BOOL success) {
        
    }];
}

- (NSMutableArray<ZQPhotoDurationModel *> *)photoModels
{
    if (!_photoModels) {
        _photoModels = [NSMutableArray array];
    }
    return _photoModels;
}




@end
