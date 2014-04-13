//
//  UIButton+UnionPay.m
//  CHSP
//
//  Created by jhyu on 13-11-27.
//
//

#import "UIButton+UnionPay.h"
#import "UIFont+UnionPay.h"
#import "UIColor+plist.h"

@implementation UIButton (UnionPay)

+ (id)buttonWithStyle:(ColorButtonStyle)eStyle withRect:(CGRect)rect withTitle:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn configButtonWithStyle:eStyle withRect:rect withTitle:title];
    return btn;
}

- (void)configButtonWithStyle:(ColorButtonStyle)eStyle withRect:(CGRect)rect withTitle:(NSString *)title
{
    self.frame = rect;
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    NSString * imageName;
    NSString * imageNamePressed;
    UIColor * textColor = [UIColor whiteColor];
    BOOL isEnable = YES;
    switch (eStyle) {
        case SMSOrangeButton:
            imageName = @"橙色.png";
            imageNamePressed = @"橙色按下.png";
            break;
        case RedButton:
            imageName = @"红色.png";
            imageNamePressed = @"红色按下.png";
            break;
        case GreyButton:
            imageName = @"灰色.png";
            imageNamePressed = @"灰色按下.png";
            isEnable = NO;
            break;
        case WhiteButton:
            imageName = @"白色.png";
            imageNamePressed = imageName;
            textColor = [UIColor colorWithHexValue:@"#127EFC"];
            break;
        case LightBlueButton:
            imageName = @"淡蓝色.png";
            imageNamePressed = @"淡蓝色按下.png";
            break;
        case BlueButton:
            imageName = @"蓝色.png";
            imageNamePressed = @"蓝色按下.png";
            break;
        case LightGreenButton:
            imageName = @"浅绿色.png";
            imageNamePressed = imageName;
            break;
        case GreenButton:
            imageName = @"绿色.png";
            imageNamePressed = @"绿色按下.png";
            break;
        default:
            break;
    }

    self.enabled = isEnable;

    UIImage * image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:(image.size.width/2-1) topCapHeight:(image.size.height/2-1)];
    
    UIImage * imagePressed = [UIImage imageNamed:imageNamePressed];
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:(imagePressed.size.width/2-1) topCapHeight:(imagePressed.size.height/2-1)];
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    [self setBackgroundImage:imagePressed forState:UIControlStateSelected];
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.exclusiveTouch = YES;
    
    self.backgroundColor = [UIColor clearColor];
}

@end
