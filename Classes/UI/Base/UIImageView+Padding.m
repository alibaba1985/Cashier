//
//  UIImageView+Padding.m
//  CHSP
//
//  Created by jhyu on 13-10-30.
//
//

#import "UIImageView+Padding.h"
#import "UIColor+plist.h"

@implementation UIImageView (Padding)

- (UIImageView *)paddingWithLeft:(NSUInteger)left withRight:(NSUInteger)right
{
    CGRect frame = self.frame;
    frame.size.width += (left + right);
    
    UIImageView * myImageView = [[UIImageView alloc] initWithFrame:frame];
    //myImageView.backgroundColor = [UIColor colorWithHexValue:@"#00000000"]; // #RGB_A
    //myImageView.alpha = 1.0f;
    myImageView.opaque = YES;
    
    CGRect imageFrame = self.frame;
    imageFrame.origin.x += left;
    self.frame = imageFrame;
    [myImageView addSubview:self];
    
    return myImageView;
}

@end
