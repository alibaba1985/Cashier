//
//  UpProductTourViewController.m
//  CHSP
//
//  Created by jhyu on 13-11-28.
//
//

#import "UpProductTourViewController.h"
#import "DDPageControl.h"
#import "CPValueUtility.h"
//#import "UIColor+plist.h"
//#import "UPConfig.h"

@interface UpProductTourViewController () {
    DDPageControl * _pageControl;
}

@end

@implementation UpProductTourViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(self.pages == nil) {
        self.pages = [self colletAllTourImages];
    }
    
    TnPreviewPagingScrollView * preview = [[TnPreviewPagingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    preview.tiltDistance = 0.0f;
    [preview setupPagingViewWithViews:self.pages];
    preview.delegate = self;
    preview.scrollView.directionalLockEnabled = YES;
    preview.scrollView.pagingEnabled = YES;
    preview.scrollView.bounces = NO;
    
    [self.view addSubview:preview];
    
    //[self addPageControl];
    
    [self addSubmitButton];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CPValueUtility navigationController:self.navigationController popGestureRecognizerEnable:NO];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CPValueUtility navigationController:self.navigationController popGestureRecognizerEnable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//- (void)addPageControl
//{
//    _pageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffFull];
//    _pageControl.indicatorDiameter = 8.0f;
//    _pageControl.numberOfPages = self.pages.count;
//    _pageControl.onColor = [UIColor colorWithHexValue:@"142943"];
//    _pageControl.offColor = [UIColor colorWithHexValue:@"275286"];
//    CGSize size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
//    CGRect frame = _pageControl.frame;
//    frame.origin.x = (self.view.frame.size.width-size.width)/2;
//    frame.size = size;
//    frame.origin.y = [[UIScreen mainScreen] bounds].size.height - 110;
//    _pageControl.frame = frame;
//    [self.view addSubview:_pageControl];
//}

- (NSArray *)colletAllTourImages
{
    int num = 4;
    
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:num];
    for(int i = 1; i <= num; ++i) {
        UIView * containerView = [[UIView alloc] initWithFrame:self.view.frame];
        
        // Image size is fit for iPhone5.
        NSString * picName;
        picName = [NSString stringWithFormat:@"iOS%d@2x", i];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:picName ofType:@"png"];
        UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:bounds];
        imageView.image = image;
        [containerView addSubview:imageView];
        
        [images addObject:containerView];
    }
    
    return images;
}

- (void)addSubmitButton
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    CGFloat btnBottomTag;
    if(NO/*[UPUtils iPhone5]*/) {
        btnBottomTag = 21.0f;
    }
    else {
        btnBottomTag = 14.0f;
    }
    
    CGRect rcBtn = CGRectZero;
    rcBtn.size.height = 40;
    rcBtn.origin.x = 20;
    rcBtn.size.width = self.view.frame.size.width - 2 * rcBtn.origin.x;
    rcBtn.origin.y = bounds.origin.y + bounds.size.height - rcBtn.size.height - btnBottomTag;
    
    UIButton * btn = [UIButton buttonWithStyle:LightGreenButton withRect:rcBtn withTitle:@"抢鲜体验"];
    [btn addTarget:self action:@selector(tryApp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)dealloc
{
    self.pages = nil;
    self.dismissAction = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tryApp:(id)sender
{
    self.dismissAction();
}

#pragma mark - TnPreviewPagingScrollViewDelegate

-(void)didActivatePage:(NSInteger)index inView:(TnPreviewPagingScrollView*)view
{
    _pageControl.currentPage = index;
}

@end
