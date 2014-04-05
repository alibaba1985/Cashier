//
//  CPUnderLineButton.h
//  UPPayPluginEx
//
//  Created by liwang on 13-5-23.
//
//

#import <UIKit/UIKit.h>

@interface CPUnderLineButton : UIView



- (CPUnderLineButton *)initWithFrame:(CGRect)frame
                               title:(NSString *)title
                                font:(UIFont *)font
                              target:(id)target
                              action:(SEL)action;

- (void)setTitleNormalColor:(UIColor *)color;




@end
