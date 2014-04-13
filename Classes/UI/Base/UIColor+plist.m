//
//  UIColor+plist.m
//  TelenavNavigator
//
//  Created by Ryan Drake on 8/31/11.
//  Copyright (c) 2011 Telenav, Inc. All rights reserved.
//

#import "UIColor+plist.h"


static NSDictionary* colorsDict=nil;

@implementation UIColor (plist)

+ (UIColor*)colorWithKeyName:(NSString*)name
{
    if  (colorsDict==nil) {
        colorsDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"colors.plist" ofType:nil]];
    }
    return [UIColor colorWithHexValue:colorsDict[name]];
}

+(UIColor *)colorWithHexValue:(NSString *)hexValue{
    unsigned int c = 0xffffff;
    if([hexValue characterAtIndex:0] == '#') {
        [[NSScanner scannerWithString:[hexValue substringFromIndex:1]] scanHexInt:&c];
    } else {
        [[NSScanner scannerWithString:hexValue] scanHexInt:&c];
    }
    
    // Convert to UIColor format RGB_A
    if([hexValue length] > 7) {
        return [UIColor colorWithRed:((c & 0xff000000) >> 24)/255.0f
                               green:((c & 0xff0000) >> 16)/255.0f
                                blue:((c & 0xff00) >> 8)/255.0f
                               alpha:(c & 0xff)/255.0f];
    } else {
        return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0f
                               green:((c & 0xff00) >> 8)/255.0f
                                blue:(c & 0xff)/255.0f
                               alpha:1.0f];
    }
}

+(UIColor *)tableViewBackgroundColor{
    static UIImage* tableViewBackgroundImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.f, 1.f), NO, 0.0);
        CGContextRef c = UIGraphicsGetCurrentContext();
        [[self colorWithRed:185/255.f green:192/255.f blue:202/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
        [[self colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
        [[self colorWithRed:192/255.f green:200/255.f blue:207/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
        tableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return [self colorWithPatternImage:tableViewBackgroundImage];
}

@end
