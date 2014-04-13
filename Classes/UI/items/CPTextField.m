//
//  CPTextField.m
//  Cashier
//
//  Created by liwang on 14-2-21.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPTextField.h"

@implementation CPTextField
@synthesize fieldDescription;

- (void) dealloc
{
    self.fieldDescription = nil;
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
