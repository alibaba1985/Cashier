//
//  CPCategoryViewController.m
//  Cashier
//
//  Created by liwang on 14-2-14.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPCategoryViewController.h"
#import "WLSideMenuItem.h"
#import "WLSideMenuViewController.h"
#import "CPStoreViewController.h"
#import "CPBusinessViewController.h"
#import "CPAccountManagerViewController.h"
#import "CPMoreViewController.h"
#import "CPStoreInfoViewController.h"

@interface CPCategoryViewController ()
{
    CPTextField *_categoryTextField;
}

- (void)priorAction;

- (void)nextAction;

@end

@implementation CPCategoryViewController

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
	// Do any additional setup after loading the view.
    
    self.title = @"添加商品类型";
    
    CGFloat y = kTextFieldHeight;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FScreenWidth, FScreenHeight)];
    [bgView setImage:[UIImage imageNamed:@"File7.jpg"]];
    [self.view addSubview:bgView];
    [bgView release];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(priorAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    //    CGRect logoFrame = CGRectMake((FScreenWidth - kHeadLogoWidth)/2, y, kHeadLogoWidth, kHeadLogoHeight);
    //    _headLogo = [[UIImageView alloc] initWithFrame:logoFrame];
    //    [_headLogo setImage:FGetImageNameByKey(kBar_Menu_Normal)];
    //    [self.view addSubview:_headLogo];
    //    [_headLogo release];
    
    y+= kTextFieldHeight*2;
    
    CGRect userMailFrame = CGRectMake((FScreenWidth - kTextFieldWidth)/2, y, kTextFieldWidth, kTextFieldHeight);
    _categoryTextField = [CPCocoaSubViews textFieldWithFrame:userMailFrame placeHolder:nil delegate:self description:@"商品种类"];
    [self.view addSubview:_categoryTextField];
    [_textFieldArray addObject:_categoryTextField];
    _categoryTextField.backgroundColor =[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentMainPages
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    CPBusinessViewController *b = [[[CPBusinessViewController alloc] init] autorelease];
    UINavigationController *page1 = [[[UINavigationController alloc] initWithRootViewController:b] autorelease];
    //page1.view.center = CGPointMake(FScreenWidth / 2, FScreenHeight / 2);
    WLSideMenuItem *item1 = [[WLSideMenuItem alloc] initWithViewController:page1 type:WLMenuTypeDefault indicator:nil title:@"营业" subMenus:nil];
    
    [array addObject:item1];
    
    
    CPStoreViewController *s = [[[CPStoreViewController alloc] init] autorelease];
    UINavigationController *page2 = [[[UINavigationController alloc] initWithRootViewController:s] autorelease];
    //page2.view.center = CGPointMake(FScreenWidth / 2, FScreenHeight / 2);
    WLSideMenuItem *item2 = [[WLSideMenuItem alloc] initWithViewController:page2 type:WLMenuTypeDefault indicator:nil title:@"店铺" subMenus:nil];
    
    [array addObject:item2];
    
    CPAccountManagerViewController *a = [[[CPAccountManagerViewController alloc] init] autorelease];
    UINavigationController *page3 = [[[UINavigationController alloc] initWithRootViewController:a] autorelease];
    //page3.view.center = CGPointMake(FScreenWidth / 2, FScreenHeight / 2);
    WLSideMenuItem *item3 = [[WLSideMenuItem alloc] initWithViewController:page3 type:WLMenuTypeDefault indicator:nil title:@"账户" subMenus:nil];
    
    [array addObject:item3];
    
    CPMoreViewController *m = [[[CPMoreViewController alloc] init] autorelease];
    UINavigationController *page4 = [[[UINavigationController alloc] initWithRootViewController:m] autorelease];
    //page4.view.center = CGPointMake(FScreenWidth / 2, FScreenHeight / 2);
    WLSideMenuItem *item4 = [[WLSideMenuItem alloc] initWithViewController:page4 type:WLMenuTypeDefault indicator:nil title:@"更多" subMenus:nil];
    [array addObject:item4];
    
    WLSideMenuViewController *menuC = [[WLSideMenuViewController alloc] initWithLeftMenuItems:array rightMenuItems:nil];
    menuC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:menuC animated:YES completion:nil];
    
    [menuC release];
    
}



- (void)priorAction
{
    
}

- (void)nextAction
{
    if (![self checkEmptyAndIllegalForTextField:_categoryTextField]) {
        return;
    }
    
    [self presentMainPages];
}

@end
