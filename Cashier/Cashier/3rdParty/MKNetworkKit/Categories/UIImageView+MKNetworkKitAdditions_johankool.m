//
//  UIImageView+MKNetworkKitAdditions.m
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
#import "MKNetworkKit.h"
#import "UIImageView+MKNetworkKitAdditions_johankool.h"
#import <objc/runtime.h>

#define kActivityIndicatorTag 18942347

static char kMKNetworkOperationObjectKey;

static MKNetworkEngine *_mk_sharedImageEngine = nil;

@interface UIImageView (MKNetworkKitAdditions_Private_Johankool)

@property (readwrite, nonatomic, retain, getter=mk_imageOperation, setter = mk_setImageOperation:) MKNetworkOperation *mk_imageOperation;

@end

@implementation UIImageView (MKNetworkKitAdditions_Private_Johankool)

@dynamic mk_imageOperation;

@end

@implementation UIImageView (MKNetworkKitAdditions_Johankool)


+(void) setDefaultEngine:(MKNetworkEngine*) engine
{
    _mk_sharedImageEngine = engine;
}


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
    [self mk_setImageAtURL:imageURL usingEngine:[UIImageView mk_sharedImageEngine] forceReload:NO showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil fadeIn:YES notAvailableImage:nil size:CGSizeZero onCompletion:onCompletion];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    [self mk_setImageAtURL:imageURL usingEngine:[UIImageView mk_sharedImageEngine] forceReload:NO showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil fadeIn:YES notAvailableImage:nil size:size onCompletion:onCompletion];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage {
    [self mk_setImageAtURL:imageURL usingEngine:[UIImageView mk_sharedImageEngine] forceReload:forceReload showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage fadeIn:fadeIn notAvailableImage:notAvailableImage size:CGSizeZero onCompletion:nil];
}

- (void)mk_setImageAtURL:(NSURL *)imageURL forceReload:(BOOL)forceReload showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage fadeIn:(BOOL)fadeIn notAvailableImage:(UIImage *)notAvailableImage size:(CGSize)size onCompletion:(MKNKImageLoadCompletionBlock)onCompletion {
    [self mk_setImageAtURL:imageURL usingEngine:[UIImageView mk_sharedImageEngine] forceReload:forceReload showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage fadeIn:fadeIn notAvailableImage:notAvailableImage size:size onCompletion:onCompletion];
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
    
    if (loadingImage) {
        self.image = loadingImage;
    }
    
    if (!imageURL) {
        self.image = notAvailableImage;
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
            weakSelf.image = fetchedImage;
            activityIndicator.alpha = 0.0f;
        } completion:^(BOOL finished){
            [activityIndicator removeFromSuperview];
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
            NSLog(@"operation complete, %@ cache %d",imageURL,[completedOperation isCachedResponse]);
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

@end
#endif
