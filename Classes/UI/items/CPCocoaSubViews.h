//
//  CPCocoaSubViews.h
//  Cashier
//
//  Created by liwang on 14-1-9.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CPTextField.h"

//@interface UIButton (BackGround)
//
//- (void) setHighlighted:(BOOL)highlighted;
//
//@end

@interface CPCocoaSubViews : NSObject



+ (UIButton *)roundButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                       normalImage:(UIImage *)normalImage
                    highlightImage:(UIImage *)highlightImage
                            target:(id)target
                            action:(SEL)action;


+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                  normalImage:(UIImage *)normalImage
               highlightImage:(UIImage *)highlightImage
                       target:(id)target
                       action:(SEL)action;


+ (CPTextField *)textFieldWithFrame:(CGRect)frame
                        placeHolder:(NSString *)placeHolder
                           delegate:(id<UITextFieldDelegate>) delegate
                        description:(NSString *)description;


+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image;

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  alignment:(NSTextAlignment)alignment
                      color:(UIColor *)color
                       font:(UIFont *)font;

+ (CAShapeLayer *)lineLayerWithStartPoint:(CGPoint)start
                                 endPoint:(CGPoint)end
                                    width:(CGFloat)width
                                    color:(UIColor *)color;


+ (UIView *)maskViewWithFrame:(CGRect)frame;


@end
