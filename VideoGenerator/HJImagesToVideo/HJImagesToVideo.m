//
//  HJImagesToVideo.m
//  HJImagesToVideo
//
//  Created by Harrison Jackson on 8/4/13.
//  Copyright (c) 2013 Harrison Jackson. All rights reserved.
//

#import "HJImagesToVideo.h"
#import <UIKit/UIKit.h>


CGSize const DefaultFrameSize                             = (CGSize){480, 320};

NSInteger const DefaultFrameRate                          = 1;
NSInteger const TransitionFrameCount                      = 50;
//NSInteger const FramesToWaitBeforeTransition              = 40;
NSInteger const FramesToWaitBeforeTransition              = 0;


BOOL const DefaultTransitionShouldAnimate = YES;

@interface HJImagesToVideo()

@property (nonatomic, strong) NSArray<ZQPhotoDurationModel *> *photoModels;

@end

@implementation HJImagesToVideo

//+ (void)videoFromImages:(NSArray<UIImage *> *)images
//                 toPath:(NSString *)path
//      withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo videoFromImages:images
//                              toPath:path
//                            withSize:DefaultFrameSize
//                             withFPS:DefaultFrameRate
//                  animateTransitions:DefaultTransitionShouldAnimate
//                   withCallbackBlock:callbackBlock];
//}
//
//+ (void)videoFromImages:(NSArray<UIImage *> *)images
//                 toPath:(NSString *)path
//     animateTransitions:(BOOL)animate
//      withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo videoFromImages:images
//                              toPath:path
//                            withSize:DefaultFrameSize
//                             withFPS:DefaultFrameRate
//                  animateTransitions:animate
//                   withCallbackBlock:callbackBlock];
//}
//
//+ (void)videoFromImages:(NSArray<UIImage *> *)images
//                 toPath:(NSString *)path
//                withFPS:(int)fps
//     animateTransitions:(BOOL)animate
//      withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo videoFromImages:images
//                              toPath:path
//                            withSize:DefaultFrameSize
//                             withFPS:fps
//                  animateTransitions:animate
//                   withCallbackBlock:callbackBlock];
//}
//
//+ (void)videoFromImages:(NSArray<UIImage *> *)images
//                 toPath:(NSString *)path
//               withSize:(CGSize)size
//     animateTransitions:(BOOL)animate
//      withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo videoFromImages:images
//                              toPath:path
//                            withSize:size
//                             withFPS:DefaultFrameRate
//                  animateTransitions:animate
//                   withCallbackBlock:callbackBlock];
//}
//
- (void)videoFromImages:(NSArray<ZQPhotoDurationModel *> *)images
                 toPath:(NSString *)path
               withSize:(CGSize)size
                withFPS:(int)fps
     animateTransitions:(BOOL)animate
      withCallbackBlock:(SuccessBlock)callbackBlock
{
    [self writeImageAsMovie:images
                     toPath:path
                       size:size
                        fps:fps
         animateTransitions:animate
          withCallbackBlock:callbackBlock];
}
//
//+ (void)saveVideoToPhotosWithImages:(NSArray<UIImage *> *)images
//                  withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo saveVideoToPhotosWithImages:images
//                                        withSize:DefaultFrameSize
//                              animateTransitions:DefaultTransitionShouldAnimate
//                               withCallbackBlock:callbackBlock];
//}
//
//+ (void)saveVideoToPhotosWithImages:(NSArray<UIImage *> *)images
//                 animateTransitions:(BOOL)animate
//                  withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo saveVideoToPhotosWithImages:images
//                                        withSize:DefaultFrameSize
//                              animateTransitions:animate
//                               withCallbackBlock:callbackBlock];
//}
//
//+ (void)saveVideoToPhotosWithImages:(NSArray<UIImage *> *)images
//                           withSize:(CGSize)size
//                 animateTransitions:(BOOL)animate
//                  withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo saveVideoToPhotosWithImages:images
//                                        withSize:size
//                                         withFPS:DefaultFrameRate
//                              animateTransitions:animate
//                               withCallbackBlock:callbackBlock];
//}
//
//+ (void)saveVideoToPhotosWithImages:(NSArray<UIImage *> *)images
//                            withFPS:(int)fps
//                 animateTransitions:(BOOL)animate
//                  withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    [HJImagesToVideo saveVideoToPhotosWithImages:images
//                                        withSize:DefaultFrameSize
//                                         withFPS:fps
//                              animateTransitions:animate
//                               withCallbackBlock:callbackBlock];
//}
//
//+ (void)saveVideoToPhotosWithImages:(NSArray<UIImage *> *)images
//                           withSize:(CGSize)size
//                            withFPS:(int)fps
//                 animateTransitions:(BOOL)animate
//                  withCallbackBlock:(SuccessBlock)callbackBlock
//{
//    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:
//                          [NSString stringWithFormat:@"temp.mp4"]];
//    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:NULL];
//    
//    [HJImagesToVideo videoFromImages:images
//                              toPath:tempPath
//                            withSize:size
//                             withFPS:fps
//                  animateTransitions:animate
//                   withCallbackBlock:^(BOOL success) {
//                       
//                       if (success) {
//                           UISaveVideoAtPathToSavedPhotosAlbum(tempPath, self, nil, nil);
//                       }
//                       
//                       if (callbackBlock) {
//                           callbackBlock(success);
//                       }
//                   }];
//}

- (void)writeImageAsMovie:(NSArray<ZQPhotoDurationModel *> *)array
                   toPath:(NSString*)path
                     size:(CGSize)size
                      fps:(int)fps
       animateTransitions:(BOOL)shouldAnimateTransitions
        withCallbackBlock:(SuccessBlock)callbackBlock
{
    NSLog(@"%@", path);
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    
    if (error) {
        if (callbackBlock) {
            callbackBlock(NO);
        }
        return;
    }
    NSParameterAssert(videoWriter);
    
    self.photoModels = array;
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: [NSNumber numberWithInt:size.width],
                                    AVVideoHeightKey: [NSNumber numberWithInt:size.height]};
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer;
    CVPixelBufferPoolCreatePixelBuffer(NULL, adaptor.pixelBufferPool, &buffer);
    
    CMTime presentTime = CMTimeMake(0, fps);
    
    int i = 0;
    while (1)
    {
		if(writerInput.readyForMoreMediaData){
//            presentTime = CMTimeMake(value, fps);
#warning todo 时间要是CGFloat
            presentTime = CMTimeMake([self videoDurationUntil:i], fps);
            
			if (i >= [array count]) {
				buffer = NULL;
			} else {
                UIImage *arrayIImage = [array[i] image];

				buffer = [HJImagesToVideo pixelBufferFromCGImage:arrayIImage.CGImage size:CGSizeMake(480, 320)];
			}
			
			if (buffer) {
                //append buffer
                
                BOOL appendSuccess = [HJImagesToVideo appendToAdapter:adaptor
                                                          pixelBuffer:buffer
                                                               atTime:presentTime
                                                            withInput:writerInput];
                NSAssert(appendSuccess, @"Failed to append");
                
//                if (shouldAnimateTransitions && i + 1 < array.count) {
//
//                    //Create time each fade frame is displayed
////                    CMTime fadeTime = CMTimeMake(1, fps*TransitionFrameCount);
//            
//                    //Add a delay, causing the base image to have more show time before fade begins.
////                    for (int b = 0; b < FramesToWaitBeforeTransition; b++) {
////                        presentTime = CMTimeAdd(presentTime, fadeTime);
////                    }
//                    
//                    //Adjust fadeFrameCount so that the number and curve of the fade frames and their alpha stay consistant
//                    NSInteger framesToFadeCount = TransitionFrameCount - FramesToWaitBeforeTransition;
//                    
//                    //Apply fade frames
//                    for (double j = 1; j < framesToFadeCount; j++) {
//                        UIImage *arrayIImage = [array[i] image];
//                        buffer = [HJImagesToVideo crossFadeImage:[arrayIImage CGImage]
//                                                         toImage:[[array[i + 1] image] CGImage]
//                                                          atSize:CGSizeMake(480, 320)
//                                                       withAlpha:j/framesToFadeCount];
//                        
//                        BOOL appendSuccess = [HJImagesToVideo appendToAdapter:adaptor
//                                                                  pixelBuffer:buffer
//                                                                       atTime:presentTime
//                                                                    withInput:writerInput];
////                        presentTime = CMTimeAdd(presentTime, fadeTime);
//                        
//                        NSAssert(appendSuccess, @"Failed to append");
//                    }
//                }
//                
                i++;
			} else {
				
				//Finish the session:
				[writerInput markAsFinished];
                
				[videoWriter finishWritingWithCompletionHandler:^{
                    NSLog(@"Successfully closed video writer");
                    
                    
                    if (videoWriter.status == AVAssetWriterStatusCompleted) {
                        if (callbackBlock) {
                            callbackBlock(YES);
                        }
                    } else {
                        if (callbackBlock) {
                            callbackBlock(NO);
                        }
                    }
                }];
				
				CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
				
				NSLog (@"Done");
                break;
            }
        }
    }
}

- (int)videoDurationUntil:(NSInteger)i
{
    int presentTime = 0;
    for (NSInteger j = 0; j <= i - 1; ++j) {
        ZQPhotoDurationModel *model = self.photoModels[j];
        
        presentTime += model.duration;
    }
    return presentTime;
}

+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
                                      size:(CGSize)imageSize
{
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0 + (imageSize.width-CGImageGetWidth(image))/2,
                                           (imageSize.height-CGImageGetHeight(image))/2,
                                           CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (CVPixelBufferRef)crossFadeImage:(CGImageRef)baseImage
                           toImage:(CGImageRef)fadeInImage
                            atSize:(CGSize)imageSize
                         withAlpha:(CGFloat)alpha
{
    NSDictionary *options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageSize.width,
                                          imageSize.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageSize.width,
                                                 imageSize.height, 8, 4*imageSize.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGRect drawRect = CGRectMake(0 + (imageSize.width-CGImageGetWidth(baseImage))/2,
                                 (imageSize.height-CGImageGetHeight(baseImage))/2,
                                 CGImageGetWidth(baseImage),
                                 CGImageGetHeight(baseImage));
    
    CGContextDrawImage(context, drawRect, baseImage);
    
    CGContextBeginTransparencyLayer(context, nil);
    CGContextSetAlpha( context, alpha );
    CGContextDrawImage(context, drawRect, fadeInImage);
    CGContextEndTransparencyLayer(context);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (BOOL)appendToAdapter:(AVAssetWriterInputPixelBufferAdaptor*)adaptor
            pixelBuffer:(CVPixelBufferRef)buffer
                 atTime:(CMTime)presentTime
              withInput:(AVAssetWriterInput*)writerInput
{
    while (!writerInput.readyForMoreMediaData) {
        usleep(1);
    }
    
    return [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
}




@end
