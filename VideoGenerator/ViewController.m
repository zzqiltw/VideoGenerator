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
#import "ZQPhotoModelEditorViewController.h"

#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
@interface ViewController ()<ZQPhotoModelEditorViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray<ZQPhotoDurationModel *> *photoModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pick" style:UIBarButtonItemStylePlain target:self action:@selector(onPickPhoto:)];
}

- (void)onPickPhoto:(id)sender
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
        
        ZQPhotoModelEditorViewController *controller = [ZQPhotoModelEditorViewController new];
        controller.delegate = self;
        controller.photoModels = self.photoModels;
        [self.navigationController pushViewController:controller animated:YES];
//        [self generateVideoWithImages:self.photoModels];
    }];
    
    [actionSheet showPhotoLibrary];
}



- (void)generateVideoWithImages:(NSArray<ZQPhotoDurationModel *> *)imageModels
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/temp.mp4"]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    [[HJImagesToVideo new] videoFromImages:imageModels toPath:path withSize:CGSizeMake(200, 200) withFPS:1 animateTransitions:NO withCallbackBlock:^(BOOL success) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:path]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
            }];
        });
    }];
}

- (NSMutableArray<ZQPhotoDurationModel *> *)photoModels
{
    if (!_photoModels) {
        _photoModels = [NSMutableArray array];
    }
    return _photoModels;
}

- (void)photoEditorDidFinishPick:(ZQPhotoModelEditorViewController *)controller photoModels:(NSArray<ZQPhotoDurationModel *> *)photoModels
{
    [self generateVideoWithImages:photoModels];
}


@end
