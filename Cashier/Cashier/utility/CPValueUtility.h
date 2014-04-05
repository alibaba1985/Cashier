//
//  CPValueUtility.h
//  Cashier
//
//  Created by liwang on 14-1-9.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPValueUtility : NSObject

+ (CGFloat)statusBarHeight;

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (BOOL)iOS7Device;

+ (BOOL)iPadDevice;

+ (BOOL)isValidateTextField:(NSString *)text regex:(NSString *)regex;

+ (NSString*)readFileInfoByKey:(NSString *)key;

+ (void)writeFile:(id)object key:(NSString *)key;

+ (void)deleteFileInfoByKey:(NSString*)key;

+ (NSString*)localFilePath;

+ (UIColor *)underLineNormalColor;

+ (UIColor *)underLineHighLightColor;

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha;

+ (void)debugViewInfoByParentView:(UIView *)parentView;

@end
