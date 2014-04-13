//
//  UIColor+plist.h
//  TelenavNavigator
//
//  Created by Ryan Drake on 8/31/11.
//  Copyright (c) 2011 Telenav, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UP_COLOR_BLACK  @"up_black"
#define UP_COLOR_DARK_GREY  @"up_dark_grey"
#define UP_COLOR_GREY  @"up_grey"
#define UP_COLOR_LIGHT_GREY  @"up_light_grey"
#define UP_COLOR_RED  @"up_red"
#define UP_COLOR_DARK_RED  @"up_dark_red"
#define UP_COLOR_BLUE  @"up_blue"
#define UP_COLOR_BLUE_GREEN  @"up_blue_green"
#define UP_COLOR_GREEN  @"up_green"


@interface UIColor (plist)

+ (UIColor*)colorWithKeyName:(NSString*)name;
+ (UIColor*)colorWithHexValue:(NSString*)hexValue;//takes input such as @"de001f"

// http://stackoverflow.com/questions/12452810/is-grouptableviewbackgroundcolor-deprecated-on-ios-6
// needed at some places such as DriveToAddressViewController.
+ (UIColor*)tableViewBackgroundColor;

@end
