//
//  UIButton+UnionPay.h
//  CHSP
//
//  Created by jhyu on 13-11-27.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    SMSOrangeButton,
    RedButton,
    GreyButton,
    LightBlueButton,
    BlueButton,
    LightGreenButton,
    GreenButton,
    WhiteButton
}ColorButtonStyle;

@interface UIButton (UnionPay)

+ (id)buttonWithStyle:(ColorButtonStyle)eStyle withRect:(CGRect)rect withTitle:(NSString *)title;

- (void)configButtonWithStyle:(ColorButtonStyle)eStyle withRect:(CGRect)rect withTitle:(NSString *)title;

@end
