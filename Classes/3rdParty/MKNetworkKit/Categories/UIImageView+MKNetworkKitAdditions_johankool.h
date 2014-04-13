//
//  UIImageView+MKNetworkKitAdditions_johankool.h
//  MKNetworkKit
//
//  Created by Johan Kool on 2/4/2012.
//  Copyright (c) 2012 Johan Kool. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@class MKNetworkEngine;

//#import "MKNetworkKit.h"

typedef void (^MKNKImageLoadCompletionBlock) (BOOL success, BOOL fromCache);

@interface UIImageView (MKNetworkKitAdditions_Johankool)

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param onCompletion Block executed when the image is loaded
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method uses a default engine. Any previous outstanding downloads for the image view are cancelled. This convenience method does not force a reload, shows a grey activity indicator, no loading or not available images and does a fade in of the resulting image.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL onCompletion:(MKNKImageLoadCompletionBlock)onCompletion;

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param size The size of the image
 *  @param onCompletion Block executed when the image is loaded
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method uses a default engine. Any previous outstanding downloads for the image view are cancelled. This convenience method does not force a reload, shows a grey activity indicator, no loading or not available images and does a fade in of the resulting image. The image is decompressed in the background to a UIImage of the provided size.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion;

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param forceReload Wether a reload of the image should be forced
 *  @param showActivityIndicator Wether a spinning indicator should be shown during loading
 *  @param indicatorStyle The style of the spinning indicator
 *  @param loadingImage The image to show while loading
 *  @param fadeIn Wether the loaded image should be faded in
 *  @param notAvailableImage The image to show if no image could be retrieved
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method uses a default engine. Any previous outstanding downloads for the image view are cancelled. If forceReload is YES, the cache will get skipped. Optionally an activity indicator can be shown while the network operation is performed. The loadingImage is displayed during loading, notAvailableImage is shown when a network error occurs or no image was found at the URL. The fade in of the result is optional.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage;

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param forceReload Wether a reload of the image should be forced
 *  @param showActivityIndicator Wether a spinning indicator should be shown during loading
 *  @param indicatorStyle The style of the spinning indicator
 *  @param loadingImage The image to show while loading
 *  @param fadeIn Wether the loaded image should be faded in
 *  @param notAvailableImage The image to show if no image could be retrieved
 *  @param size The size of the image, pass CGSizeZero if unknown or background decompressing is not desired
 *  @param onCompletion Block executed when the image is loaded
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method uses a default engine. Any previous outstanding downloads for the image view are cancelled. If forceReload is YES, the cache will get skipped. Optionally an activity indicator can be shown while the network operation is performed. The loadingImage is displayed during loading, notAvailableImage is shown when a network error occurs or no image was found at the URL. The fade in of the result is optional.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion;

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param engine The MKNetworkEngine to use
 *  @param forceReload Wether a reload of the image should be forced
 *  @param showActivityIndicator Wether a spinning indicator should be shown during loading
 *  @param indicatorStyle The style of the spinning indicator
 *  @param loadingImage The image to show while loading
 *  @param fadeIn Wether the loaded image should be faded in
 *  @param notAvailableImage The image to show if no image could be retrieved
 *  @param size The size of the image, pass CGSizeZero if unknown or background decompressing is not desired
 *  @param onCompletion Block executed when the image is loaded
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method allows you to provide a custom engine. Any previous outstanding downloads for the image view are cancelled. If forceReload is YES, the cache will get skipped. Optionally an activity indicator can be shown while the network operation is performed. The loadingImage is displayed during loading, notAvailableImage is shown when a network error occurs or no image was found at the URL. The fade in of the result is optional.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL usingEngine:(MKNetworkEngine *)engine forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion;

/*!
 *  @abstract Cancels the download of the image.
 *
 *  @discussion
 *	Cancels the download of the image.
 */
- (void)mk_cancelImageDownload;

/*!
 *  @abstract Indicates if an image is currenlty being downloaded.
 *
 *  @discussion
 *	Indicates if an image is currenlty being downloaded.
 */
@property (nonatomic, assign, readonly, getter=mk_isLoading) BOOL loading;

/*!
 *  @abstract MKNetworkEngine used by default for downloading images.
 *
 *  @discussion
 *	Exposed to be able to access images directly without using an UIImageView.
 */
+ (MKNetworkEngine *)mk_sharedImageEngine;


/*!
 *  @abstract add by cq, 允许使用自定义engine
 *
 *  
 *	这样可以控制图片缓存处理
 */
+(void) setDefaultEngine:(MKNetworkEngine*) engine;

@end
#endif