//
//  CPUnderLineButton.m
//  UPPayPluginEx
//
//  Created by liwang on 13-5-23.
//
//

#import "CPUnderLineButton.h"
#import "CPValueUtility.h"


#define kFontSmall            14
#define kCheckBoxHeight       35
#define kInfoBoxHeight        20
#define kMargin               20



@interface CPUnderLineButton()
{
@private
    UILabel     *_label;
    NSString    *_title;
    UIColor     *_normalColor;
    UIColor     *_highLightColor;
    UIFont      *_font;
    CAShapeLayer *_lineLayer;
}
@property(nonatomic, assign)id    mTarget;
@property(nonatomic, assign)SEL   mSelector;

- (void)addSubViews;

- (void)colorChange:(UIButton *)btn;

- (void)colorBack:(UIButton *)btn;

- (void)touchUpInside:(UIButton *)btn;


@end





@implementation CPUnderLineButton
@synthesize mTarget;
@synthesize mSelector;

- (CPUnderLineButton *)initWithFrame:(CGRect)frame
                               title:(NSString *)title
                                font:(UIFont *)font
                              target:(id)target
                              action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _title = (title == nil) ? nil : [NSString stringWithString:title];
        _font = [font retain];
        self.mTarget = target;
        self.mSelector = action;
        [self addSubViews];
        
    }
    return self;
}

- (void)dealloc
{
    self.mTarget = nil;
    self.mSelector = nil;
    
    [_normalColor release];
    [_highLightColor release];
    [_font release];
    
    [super dealloc];
}

#pragma mark- Member Functions



- (void)addSubViews
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGSize labelSize = [_title sizeWithFont:_font];

    CGRect frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    _label = [[UILabel alloc] initWithFrame:frame];
    [_label setFont:_font];
    [_label setText:_title];
    _label.backgroundColor = [UIColor clearColor];
    [_label setTextColor:[CPValueUtility underLineNormalColor]];
    [self addSubview:_label];
    [_label release];
    
    
    //_lineLayer = [CPValueUtility lineLayerWithStartPoint:CGPointMake(0, self.frame.size.height) endPoint:CGPointMake(self.frame.size.width, self.frame.size.height) width:1 color:[CPValueUtility underLineNormalColor]];
    
    //[self.layer addSublayer:_lineLayer];
    
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(colorBack:) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:btn];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, labelSize.height);
}

- (void)colorChange:(UIButton *)btn
{
    [_label setTextColor:[CPValueUtility underLineHighLightColor]];
    //[_lineLayer setStrokeColor:[CPValueUtility underLineHighLightColor].CGColor];
}
- (void)colorBack:(UIButton *)btn
{
    [_label setTextColor:[CPValueUtility underLineNormalColor]];
    //[_lineLayer setStrokeColor:[CPValueUtility underLineNormalColor].CGColor];
}
- (void)touchUpInside:(UIButton *)btn
{
    [self colorBack:btn];
    if ([self.mTarget respondsToSelector:self.mSelector]) {
        [self.mTarget performSelector:self.mSelector withObject:nil];
    }
}


- (void)setTitleNormalColor:(UIColor *)color
{
    [_label setTextColor:[CPValueUtility underLineNormalColor]];
    //[_lineLayer setStrokeColor:[CPValueUtility underLineNormalColor].CGColor];
}



@end
