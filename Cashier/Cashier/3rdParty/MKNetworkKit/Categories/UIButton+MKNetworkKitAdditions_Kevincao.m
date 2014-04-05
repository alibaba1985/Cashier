//
//  UIButton+MKNetworkKitAdditions_Kevincao.m
//  UPClientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-8-8.
//
//

#import "UIImageView+MKNetworkKitAdditions_johankool.h"
#import "MKNetworkKit.h"
#import <objc/runtime.h>

#define kActivityIndicatorTag 18942348

static char kMKNetworkOperationObjectKey;

static MKNetworkEngine *_mk_sharedImageEngine = nil;

@interface UIButton (MKNetworkKitAdditions_Private_Kevincao)

@property (readwrite, nonatomic, retain, getter=mk_imageOperation, setter = mk_setImageOperation:) MKNetworkOperation *mk_imageOperation;

@end

@implementation UIButton (MKNetworkKitAdditions_Private_Kevincao)

@dynamic mk_imageOperation;

@end

@implementation UIButton (MKNetworkKitAdditions_Kevincao)

+ (MKNetworkEngine *)mk_sharedImageEngine {
    if (!_mk_sharedImageEngine) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _mk_sharedImageEngine = [[MKNetworkEngine alloc] initWithHostName:nil customHeaderFields:nil];
            [_mk_sharedImageEngine useCache];
        });
    }
    return _mk_sharedImageEngine;
}

+(void) setDefaultEngine:(MKNetworkEngine*) engine
{
    _mk_sharedImageEngine = engine;
}

- (MKNetworkOperation *)mk_imageOperation {
    return (MKNetworkOperation *)objc_getAssociatedObject(self, &kMKNetworkOperationObjectKey);
}

- (void)mk_setImageOperation:(MKNetworkOperation *)imageOperation {
    objc_setAssociatedObject(self, &kMKNetworkOperationObjectKey, imageOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mk_showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)indicatorStyle {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGRect currentFrame = activityIndicator.frame;
    CGRect newFrame = CGRectMake(CGRectGetMidX(self.bounds) - 0.5f * currentFrame.size.width,
                                 CGRectGetMidY(self.bounds) - 0.5f * currentFrame.size.height,
                                 currentFrame.size.width,
                                 currentFrame.size.height);
    activityIndicator.frame = newFrame;
    activityIndicator.tag = kActivityIndicatorTag;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
}

- (void)mk_cleanup {
    UIView *activityIndicator = [self viewWithTag:kActivityIndicatorTag];
    [activityIndicator removeFromSuperview];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    [self mk_setImageAtURL:imageURL usingEngine:[UIButton mk_sharedImageEngine] forceReload:NO showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil fadeIn:YES notAvailableImage:nil size:CGSizeZero onCompletion:onCompletion];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    [self mk_setImageAtURL:imageURL usingEngine:[UIButton mk_sharedImageEngine] forceReload:NO showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil fadeIn:YES notAvailableImage:nil size:size onCompletion:onCompletion];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage {
    [self mk_setImageAtURL:imageURL usingEngine:[UIButton mk_sharedImageEngine] forceReload:forceReload showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage fadeIn:fadeIn notAvailableImage:notAvailableImage size:CGSizeZero onCompletion:nil];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    [self mk_setImageAtURL:imageURL usingEngine:[UIButton mk_sharedImageEngine] forceReload:forceReload showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage fadeIn:fadeIn notAvailableImage:notAvailableImage size:size onCompletion:onCompletion];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL usingEngine:(MKNetworkEngine *)engine forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    NSParameterAssert(engine);
    
    NSLog(@"mk_setImageAtURL, %@",imageURL);

    // Don't restart same URL
    BOOL operationAlreadyActive = NO;
    if ([self.mk_imageOperation.url isEqual:imageURL]) {
        operationAlreadyActive = YES;
    }
    
    // In case we are called multiple times, cleanup old stuff first
    if (operationAlreadyActive) {
        [self mk_cleanup];
    } else {
        [self mk_cancelImageDownload];
    }
    
    [self setImage:loadingImage forState:UIControlStateNormal];
    [self setImage:loadingImage forState:UIControlStateSelected];
    [self setImage:loadingImage forState:UIControlStateHighlighted];
    
    if (!imageURL) {
        [self setImage:notAvailableImage forState:UIControlStateNormal];
        [self setImage:notAvailableImage forState:UIControlStateSelected];
        [self setImage:notAvailableImage forState:UIControlStateHighlighted];
        if (operationAlreadyActive) {
            [self mk_cancelImageDownload];
        }
        return;
    }
    
    if (showActivityIndicator) {
        [self mk_showActivityIndicatorWithStyle:indicatorStyle];
    }
    
#if __has_feature(objc_arc_weak)
    __weak typeof(self) weakSelf = self;
#else
    __unsafe_unretained typeof(self) weakSelf = self;
#endif
    void (^completionBlock)(UIImage *fetchedImage, NSURL *URL, BOOL isInCache) = ^(UIImage *fetchedImage, NSURL *URL, BOOL isInCache) {
        BOOL success = (fetchedImage != nil);
        if (!success) {
            fetchedImage = notAvailableImage;
        }
        
        UIView *activityIndicator = [weakSelf viewWithTag:kActivityIndicatorTag];
        [UIView transitionWithView:weakSelf duration:(fadeIn && !isInCache) ? 0.4f : 0.0f options:(fadeIn && !isInCache) ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionNone animations:^{
            if (!isInCache) {
                [weakSelf setImage:fetchedImage forState:UIControlStateNormal];
                [weakSelf setImage:fetchedImage forState:UIControlStateSelected];
                [weakSelf setImage:fetchedImage forState:UIControlStateHighlighted];
                activityIndicator.alpha = 0.0f;
            }
        } completion:^(BOOL finished){
            if (!isInCache) {
                [activityIndicator removeFromSuperview];
            }
                if (onCompletion) {
                    onCompletion(success, isInCache);
                }
        }];
    };
    
    BOOL decompress = !CGSizeEqualToSize(size, CGSizeZero);
    if (operationAlreadyActive) {
        [self.mk_imageOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            if (decompress) {
                [completedOperation decompressedResponseImageOfSize:size
                                                  completionHandler:^(UIImage *decompressedImage) {
                                                      completionBlock(decompressedImage, imageURL, [completedOperation isCachedResponse]);
                                                  }];
            } else {
                completionBlock([completedOperation responseImage], imageURL, [completedOperation isCachedResponse]);
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            completionBlock(nil, imageURL, NO);
        }];
    } else {
        MKNetworkOperation *imageOperation = [engine operationWithURLString:[imageURL absoluteString]];
        [imageOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            if (decompress) {
                [completedOperation decompressedResponseImageOfSize:size
                                                  completionHandler:^(UIImage *decompressedImage) {
                                                      completionBlock(decompressedImage, imageURL, [completedOperation isCachedResponse]);
                                                  }];
            } else {                
                completionBlock([completedOperation responseImage], imageURL, [completedOperation isCachedResponse]);
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            completionBlock(nil, imageURL, NO);
        }];
        self.mk_imageOperation = imageOperation;
        [engine enqueueOperation:imageOperation forceReload:forceReload];
    }
}

- (void)mk_cancelImageDownload {
    [self.mk_imageOperation cancel];
    self.mk_imageOperation = nil;
    [self mk_cleanup];
}

- (BOOL)mk_isLoading {
    return (self.mk_imageOperation !=  nil);
}



//验证码按钮, 先取VID, 再拼URL得到图片地址, 返回VID
-(void) up_setVerifyCodeAndImage:(NSString*)fetchID
                                 captcha:(NSString*)captchaFormat
                   showActivityIndicator:(BOOL)showActivityIndicator
                  activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
                            loadingImage:(UIImage *)loadingImage
                                  fadeIn:(BOOL)fadeIn
                       notAvailableImage:(UIImage *)notAvailableImage
                                virtualID:(void (^)(NSString* vid))virtualBlock
{
    [self mk_cancelImageDownload];

    [self setImage:loadingImage forState:UIControlStateNormal];
    [self setImage:loadingImage forState:UIControlStateSelected];
    [self setImage:loadingImage forState:UIControlStateHighlighted];
    

    if (showActivityIndicator) {
        [self mk_showActivityIndicatorWithStyle:indicatorStyle];
    }
        
    MKNetworkOperation *op = [[UIButton mk_sharedImageEngine]
                              operationWithURLString:fetchID
                                                   params:nil
                                               httpMethod:@"GET"];
    
    UIView *activityIndicator = [self viewWithTag:kActivityIndicatorTag];

    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
        BOOL cache = [completedOperation isCachedResponse];
        if (!cache) {
            NSString* verify_id =  [[NSString alloc] initWithData:[completedOperation responseData]
                                                         encoding: NSUTF8StringEncoding];
            [activityIndicator removeFromSuperview];
            if (virtualBlock) {
                virtualBlock(verify_id);
            }
            NSURL* verifyImageURL = [NSURL URLWithString:[captchaFormat stringByAppendingString:verify_id]];
            [self mk_setImageAtURL:verifyImageURL
                       forceReload:YES
             showActivityIndicator:showActivityIndicator
            activityIndicatorStyle:indicatorStyle
                      loadingImage:loadingImage
                            fadeIn:fadeIn
                 notAvailableImage:notAvailableImage];
        }
    }
                errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                    [activityIndicator removeFromSuperview];

                    [self setImage:notAvailableImage forState:UIControlStateNormal];
                    [self setImage:notAvailableImage forState:UIControlStateSelected];
                    [self setImage:notAvailableImage forState:UIControlStateHighlighted];
                }];
    
    self.mk_imageOperation = op;

    [[UIButton mk_sharedImageEngine] enqueueOperation:op];
}

@end
