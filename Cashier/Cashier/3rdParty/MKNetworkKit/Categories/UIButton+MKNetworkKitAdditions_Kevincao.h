//
//  UIButton+MKNetworkKitAdditions_Kevincao.h
//  UPClientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-8-8.
//
//

#import <UIKit/UIKit.h>

@class MKNetworkEngine;

typedef void (^MKNKButtonLoadCompletionBlock) (BOOL success, BOOL fromCache);

@interface UIButton (MKNetworkKitAdditions_Kevincao)

/*!
 *  @abstract Downloads or retrieves from cache the image at the URL and displays it
 *
 *  @param imageURL The URL of the image
 *  @param onCompletion Block executed when the image is loaded
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method uses a default engine. Any previous outstanding downloads for the image view are cancelled. This convenience method does not force a reload, shows a grey activity indicator, no loading or not available images and does a fade in of the resulting image.
 */
- (void)mk_setImageAtURL:(NSURL *)imageURL onCompletion:(MKNKButtonLoadCompletionBlock)onCompletion;

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
- (void)mk_setImageAtURL:(NSURL *)imageURL size:(CGSize)size onCompletion:(MKNKButtonLoadCompletionBlock)onCompletion;

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
- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKButtonLoadCompletionBlock)onCompletion;

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
- (void)mk_setImageAtURL:(NSURL *)imageURL usingEngine:(MKNetworkEngine *)engine forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKButtonLoadCompletionBlock)onCompletion;

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
 *  @abstract 先获取verify ID, 然后拼出验证码的URL, 并显示最终的验证码
 *
 *  @param fetchID The URL to get verify ID
 *  @param captchaFormat 验证码URL的格式
 *  @param showActivityIndicator Wether a spinning indicator should be shown during loading
 *  @param indicatorStyle The style of the spinning indicator
 *  @param loadingImage The image to show while loading
 *  @param fadeIn Wether the loaded image should be faded in
 *  @param notAvailableImage The image to show if no image could be retrieved
 *
 *  @discussion
 *	A network operation will be created that downloads or retrieves from cache the image at the URL and displays it. This method allows you to provide a custom engine. Any previous outstanding downloads for the image view are cancelled. If forceReload is YES, the cache will get skipped. Optionally an activity indicator can be shown while the network operation is performed. The loadingImage is displayed during loading, notAvailableImage is shown when a network error occurs or no image was found at the URL. The fade in of the result is optional.
 */
-(void) up_setVerifyCodeAndImage:(NSString*)fetchID
                         captcha:(NSString*)captchaFormat
           showActivityIndicator:(BOOL)showActivityIndicator
          activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
                    loadingImage:(UIImage *)loadingImage
                          fadeIn:(BOOL)fadeIn
               notAvailableImage:(UIImage *)notAvailableImage
                       virtualID:(void (^)(NSString* vid))virtualBlock;



/*!
 *  @abstract add by cq, 允许使用自定义engine
 *
 *
 *	这样可以控制图片缓存处理
 */

+(void) setDefaultEngine:(MKNetworkEngine*) engine;

@end
