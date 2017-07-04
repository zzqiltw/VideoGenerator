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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    actionSheet.sender = self;
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [self generateVideoWithImages:images];
    }];
    
    [actionSheet showPhotoLibrary];
}

- (void)generateVideoWithImages:(NSArray<UIImage *> *)images
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/temp.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    [HJImagesToVideo videoFromImages:images toPath:path withCallbackBlock:^(BOOL success) {
        
    }];
}




@end
