//
//  DTVideoConverter.m
//  StreamBeam
//
//  Created by Jeevan Sivagnanasuntharam on 03/12/16.
//  Copyright © 2016 gressquel. All rights reserved.
//

//
//  DTVideoConverter.m
//
//  Created by Darktt on 2016/3/11.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "DTVideoConverter.h"

@interface DTVideoConverter ()

@property (retain, nonatomic) NSURL *sourceURL;

@end

@implementation DTVideoConverter

+ (instancetype)videoConverterWithSourcePath:(NSString *)sourcePath
{
    DTVideoConverter *videoConverter = [[DTVideoConverter alloc] initWithSourcePath:sourcePath];
    
    return [videoConverter autorelease];
}

+ (instancetype)videoConverterWithSourceURL:(NSURL *)sourceURL
{
    DTVideoConverter *videoConverter = [[DTVideoConverter alloc] initWithSourceURL:sourceURL];
    
    return [videoConverter autorelease];
}

- (instancetype)initWithSourcePath:(NSString *)sourcePath
{
    self = [super init];
    if (self == nil) return nil;
    
    NSAssert(sourcePath != nil, @"The source path can not be nil.");
    
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    [self setSourceURL:sourceURL];
    [self setExportQuality:AVAssetExportPresetMediumQuality];
    [self setOutputFileType:AVFileTypeQuickTimeMovie];
    
    return self;
}

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    self = [super init];
    if (self == nil) return nil;
    
    NSAssert(sourceURL != nil, @"The source URL can not be nil.");
    
    [self setSourceURL:sourceURL];
    [self setExportQuality:AVAssetExportPresetMediumQuality];
    [self setOutputFileType:AVFileTypeQuickTimeMovie];
    
    return self;
}

- (void)dealloc
{
    [_sourceURL release];
    [_exportQuality release];
    [_outputFileType release];
    [_destinationPath release];
    
    Block_release(self.progressHandler);
    
    [super dealloc];
}

#pragma mark - Public Method

- (void)startConvertWithCompletionHandler:(DTVideoConverterCompletionHandler)completionHandler
{
    NSAssert(self.destinationPath != nil, @"The destination path can not be nil.");
    
    AVURLAsset *sourceAsset = [AVURLAsset assetWithURL:self.sourceURL];
    NSURL *destinationURL = [NSURL fileURLWithPath:self.destinationPath];
    
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, sourceAsset.duration);
    
    AVAssetExportSession *__block exportSession = nil;
    
    void (^finishHandler) (void) = ^{
        if (exportSession.error != nil) {
            if (completionHandler != nil) completionHandler(exportSession.error);
            
            return;
        }
        
        if (completionHandler != nil) completionHandler(nil);
    };
    
    exportSession = [AVAssetExportSession exportSessionWithAsset:sourceAsset presetName:self.exportQuality];
    [exportSession setShouldOptimizeForNetworkUse:YES];
    [exportSession setOutputFileType:self.outputFileType];
    [exportSession setOutputURL:destinationURL];
    [exportSession setTimeRange:range];
    [exportSession exportAsynchronouslyWithCompletionHandler:finishHandler];
    
    [self detectProgressWithExportSession:exportSession];
}

#pragma mark - Private Method

- (void)detectProgressWithExportSession:(AVAssetExportSession *)exportSession
{
    float progress = exportSession.progress;
    
    if (self.progressHandler != nil) {
        self.progressHandler(progress);
    }
    
    if (progress >= 1.0f) {
        return;
    }
    
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self detectProgressWithExportSession:exportSession];
    });
}

- (BOOL)fileExistAtURL:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileURL.path];
}

@end
