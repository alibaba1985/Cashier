//
//  CPValueUtility.m
//  Cashier
//
//  Created by liwang on 14-1-9.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPValueUtility.h"

#define LOCAL_FILE_PATH      @"LocalInfos.plist"

@implementation CPValueUtility


+ (CGFloat)statusBarHeight
{
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    return (statusBarSize.height > statusBarSize.width) ? statusBarSize.width : statusBarSize.height;
}


+ (CGFloat)screenWidth
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    return width;
}

+ (CGFloat)screenHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        height -= [CPValueUtility statusBarHeight];
    }
    
    return height;
}

+ (BOOL)iOS7Device
{
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
}



+ (BOOL)iPadDevice
{
    BOOL iPad = NO;
    // 判断是否是iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        iPad = YES;
    }
    return iPad;
}

+ (BOOL)isValidateTextField:(NSString *)text regex:(NSString *)regex
{
    BOOL validate = NO;
    NSPredicate *textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    validate = [textPredicate evaluateWithObject:text];
    return validate;
}

//file manager

+ (NSString*)readFileInfoByKey:(NSString *)key
{
    NSString* info = nil;
    NSString* filePath = [CPValueUtility localFilePath];

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if ([dict objectForKey:key] != nil)
    {
        info = [[[NSString alloc] initWithString:[dict objectForKey:key]] autorelease];
    }
    
    return  info;
}

+ (void)writeFile:(id)object key:(NSString *)key
{
    NSMutableDictionary *fileDictionary = nil;
    NSString *path = [CPValueUtility localFilePath];

    fileDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [fileDictionary setObject:object forKey:key];
    [fileDictionary writeToFile:path atomically:YES];
}

+ (void)deleteFileInfoByKey:(NSString*)key{
    NSString* path = [CPValueUtility localFilePath];
    NSMutableDictionary* fileDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [fileDictionary removeObjectForKey:key];
    [fileDictionary writeToFile:path atomically:YES];
    
}

+ (NSString*)localFilePath
{
    NSString * profix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString * endfix = [profix stringByAppendingPathComponent:LOCAL_FILE_PATH];
    NSString *path = [[[NSString alloc] initWithString:endfix] autorelease];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        
    }
    
    return path;
}


#pragma mark - color

+ (UIColor *)underLineNormalColor
{
    CGFloat red = ((CGFloat)0x30)/0xFF;
    CGFloat green = ((CGFloat)0x74)/0xFF;
    CGFloat blue = ((CGFloat)0xAB)/0xFF;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)underLineHighLightColor
{
    CGFloat red = ((CGFloat)0x0D)/0xFF;
    CGFloat green = ((CGFloat)0x3D)/0xFF;
    CGFloat blue = ((CGFloat)0x71)/0xFF;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(r/0xFF) green:(g/0xFF) blue:(b/0xFF) alpha:alpha];
}


@end
