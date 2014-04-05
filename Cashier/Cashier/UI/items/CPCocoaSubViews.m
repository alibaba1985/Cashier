//
//  CPCocoaSubViews.m
//  Cashier
//
//  Created by liwang on 14-1-9.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPCocoaSubViews.h"
#import "CPConstDefine.h"

//@implementation UIButton (BackGround)
//
//- (void) setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//    
//    if (highlighted) {
//        self.backgroundColor = [CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0];
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.layer.borderWidth = 0;
//        
//    }
//    else
//    {
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderWidth = 1;
//        self.titleLabel.textColor = [UIColor blackColor];
//    }
//}
//
//@end


@implementation CPCocoaSubViews

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIButton *)roundButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                       normalImage:(UIImage *)normalImage
                    highlightImage:(UIImage *)highlightImage
                            target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    //
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = CGRectGetWidth(frame)/2;
    button.exclusiveTouch = YES;
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                  normalImage:(UIImage *)normalImage
               highlightImage:(UIImage *)highlightImage
                       target:(id)target
                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;

    button.exclusiveTouch = YES;
    return button;
}



+ (CPTextField *)textFieldWithFrame:(CGRect)frame
                        placeHolder:(NSString *)placeHolder
                           delegate:(id<UITextFieldDelegate>) delegate
                        description:(NSString *)description
{
    CPTextField *textField = [[[CPTextField alloc] initWithFrame:frame] autorelease];
    textField.delegate = delegate;
    textField.fieldDescription = description;
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = placeHolder;
    textField.font = [UIFont systemFontOfSize:kFontMiddle];
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.cornerRadius = 3;
    
    return textField;
}


+ (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [imageView setImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}


+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  alignment:(NSTextAlignment)alignment
                      color:(UIColor *)color
                       font:(UIFont *)font
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.font = font;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}


+ (CAShapeLayer *)lineLayerWithStartPoint:(CGPoint)start
                                 endPoint:(CGPoint)end
                                    width:(CGFloat)width
                                    color:(UIColor *)color
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setStrokeColor:[color CGColor]];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setLineWidth:width];
    [layer setLineCap:kCALineJoinRound];
    [layer setLineJoin:kCALineJoinRound];
    [layer setPath:path];
    
    return layer;
}


+ (UIView *)maskViewWithFrame:(CGRect)frame
{
    UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];
    view.backgroundColor = [UIColor blackColor];
    view.userInteractionEnabled = NO;
    
    return view;
}


@end
