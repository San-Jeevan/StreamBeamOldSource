//
//  DTVideoConverter.h
//
//  Created by Darktt on 2016/3/11.
//  Copyright © 2016年 Darktt. All rights reserved.
//

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN
typedef void (^DTVideoConverterProgressHandler) (float progress);
typedef void (^DTVideoConverterCompletionHandler) (NSError * _Nullable error);

/**
 *  Convert video to other media format (MOV or MP4).
 */
@interface DTVideoConverter : NSObject

/**
 *  The UTI-identified format of the file to be written.
 *
 * For example, <i>AVFileTypeQuickTimeMovie</i> for a QuickTime movie file, <i>AVFileTypeMPEG4</i> for an MPEG-4 file, and <i>AVFileTypeAMR</i> for an adaptive multi-rate audio format file.
 * Default is AVFileTypeQuickTimeMovie.
 */
@property (copy, nonatomic) NSString *outputFileType;

/**
 *  The quality of export video.
 *  Default is AVAssetExportPresetMediumQuality.
 */
@property (copy, nonatomic) NSString *exportQuality;

/**
 *  The destination path for save output file.
 */
@property (copy, nonatomic) NSString *destinationPath;

/**
 *  The progress of the export on a scale from 0 to 1.
 */
@property (copy, nullable) DTVideoConverterProgressHandler progressHandler;

/**
 *  Create instance with given source path.
 *
 *  @param sourcePath The source video path.
 *
 *  @return Instance of DTVideoConverter.
 */
+ (instancetype)videoConverterWithSourcePath:(NSString *)sourcePath;

/**
 *  Create instance with given file URL.
 *
 *  @param sourcePath The source video URL.
 *
 *  @return Instance of DTVideoConverter.
 */
+ (instancetype)videoConverterWithSourceURL:(NSURL *)sourceURL;

/**
 *  Create instance with given source path.
 *
 *  @param sourcePath The source video path.
 *
 *  @return Instance of DTVideoConverter.
 */
- (instancetype)initWithSourcePath:(NSString *)sourcePath;

/**
 *  Create instance with given file URL.
 *
 *  @param sourcePath The source video URL.
 *
 *  @return Instance of DTVideoConverter.
 */
- (instancetype)initWithSourceURL:(NSURL *)sourceURL;

/**
 *  Start convert video via asynchronously.
 *
 *  @param completionHandler The block for notify convert is completion.
 */
- (void)startConvertWithCompletionHandler:(nullable DTVideoConverterCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END