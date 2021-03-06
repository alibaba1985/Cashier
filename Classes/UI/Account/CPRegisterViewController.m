//
//  CPRegisterViewController.m
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPRegisterViewController.h"
#import "CPNetworkManager.h"
#import "WLSideMenuItem.h"
#import "WLSideMenuViewController.h"
#import "CPStoreViewController.h"
#import "CPBusinessViewController.h"
#import "CPAccountManagerViewController.h"
#import "CPMoreViewController.h"
#import "CPStoreInfoViewController.h"


#define kHeadLogoWidth  150
#define kHeadLogoHeight 150


@interface CPRegisterViewController ()
{
    UIImageView *_headLogo;
    CPTextField *_userName;
    CPTextField *_userMail;
    CPTextField *_userPassword;
}

- (void)priorAction;

- (void)submitAction;

- (void)pushToMainView:(NSString *)msg;

@end

@implementation CPRegisterViewController



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
    self.title = FGetStringByKey(kTitle_RegisterVC);
    self.netEntry = [[[CPNetworkManager alloc] init] autorelease];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FScreenWidth, FScreenHeight)];
    [bgView setImage:[UIImage imageNamed:@"File7.jpg"]];
    [self.view addSubview:bgView];
    [bgView release];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(priorAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    
    
    
    
    CGFloat y = kTextFieldHeight;
    
//    CGRect logoFrame = CGRectMake((FScreenWidth - kHeadLogoWidth)/2, y, kHeadLogoWidth, kHeadLogoHeight);
//    _headLogo = [[UIImageView alloc] initWithFrame:logoFrame];
//    [_headLogo setImage:FGetImageNameByKey(kBar_Menu_Normal)];
//    [self.view addSubview:_headLogo];
//    [_headLogo release];
    
    y+= kTextFieldHeight;
    
    CGRect userNameFrame = CGRectMake((FScreenWidth - kTextFieldWidth)/2, y, kTextFieldWidth, kTextFieldHeight);
    _userName = [CPCocoaSubViews textFieldWithFrame:userNameFrame placeHolder:nil  delegate:self description:@"用户名"];
    _userName.text = @"Test888";
    [self.view addSubview:_userName];
    _userName.backgroundColor =[UIColor whiteColor];
    
    y += kTextFieldHeight*4/3;
    
    CGRect userMailFrame = CGRectMake((FScreenWidth - kTextFieldWidth)/2, y, kTextFieldWidth, kTextFieldHeight);
    
    _userMail = [CPCocoaSubViews textFieldWithFrame:userMailFrame placeHolder:nil delegate:self description:@"邮箱"];
    _userMail.text = @"6304564@163.com";
    [self.view addSubview:_userMail];
    _userMail.backgroundColor =[UIColor whiteColor];
    
    y += kTextFieldHeight*4/3;
    
    CGRect userPWDFrame = CGRectMake((FScreenWidth - kTextFieldWidth)/2, y, kTextFieldWidth, kTextFieldHeight);
    _userPassword = [CPCocoaSubViews textFieldWithFrame:userPWDFrame placeHolder:nil delegate:self description:@"密码"];
    _userPassword.text = @"88888888";
    [self.view addSubview:_userPassword];
    _userPassword.backgroundColor =[UIColor whiteColor];
    
    y += kTextFieldHeight*4/3;
    
//    UIButton *button = [CPCocoaSubViews buttonWithFrame:CGRectMake((FScreenWidth - kTextFieldWidth)/2, y, kTextFieldWidth, kTextFieldHeight)
//                                                  title:FGetStringByKey(kBtn_Register)
//                                            normalImage:FGetImageNameByKey(kBtn_StartTryNormal)
//                                         highlightImage:FGetImageNameByKey(kBtn_StartTryHighLight)
//                                                 target:self
//                                                 action:@selector(submitAction)];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [self.view addSubview:button];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark- Member Method

- (BOOL)checkUserInputSuccess
{
    BOOL ret = YES;
    
    if (_userName.text.length == 0 ) {
        [self showToastMessage:@"亲，用户名没填~" position:CPToastPositionTop];
        return NO;
    }
    if (![CPValueUtility isValidateTextField:_userName.text regex:kUserNameRegex]) {
        [self showToastMessage:@"亲，用户名格式错啦~" position:CPToastPositionTop];
        return NO;
    }
    
    if (_userMail.text.length == 0 ) {
        [self showToastMessage:@"亲，邮箱没填哦~" position:CPToastPositionTop];
        return NO;
    }
    
    if (![CPValueUtility isValidateTextField:_userMail.text regex:kEmailRegex]) {
        [self showToastMessage:@"亲，邮箱格式错啦~" position:CPToastPositionTop];
        return NO;
    }
    
    if (_userPassword.text.length == 0 ) {
        [self showToastMessage:@"亲，密码没填~" position:CPToastPositionTop];
        return NO;
    }
    if (_userMail.text.length <6) {
        [self showToastMessage:@"亲，密码错误~" position:CPToastPositionTop];
        return NO;
    }
    
    return ret;
}


- (void)pushToMainView:(NSString *)msg
{
    [self showAlertMessage:msg okBtn:@"知道了" cancelBtn:nil];
}





- (void)createMainPage
{
    [self dismissLoading];
    
    CPStoreInfoViewController *i = [[CPStoreInfoViewController alloc] init];
    [self.navigationController pushViewController:i animated:YES];
    [i release];
    return;
    
    
    
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitAction
{
    [_currentResponserTextField resignFirstResponder];
    _currentResponserTextField = nil;
    
    
    if ([self checkUserInputSuccess]) {
        [self showLoadingWithTitle:@"正在玩儿命注册..."];
        
        NSString *format = @"{\"v\":\"1.0\",\"cmd\":\"sign_up\",\"user_name\":\"%@\",\"password\":\"%@\",\"email\":\"%@\"}";
        NSString *message = [NSString stringWithFormat:format, _userName.text, _userPassword.text, _userMail.text];
        NSLog(@"%@", message);
        __block CPRegisterViewController *weakSelf = self;
        [self.netEntry post:kCPServerAdress body:message header:nil successHandler:^(NSString *response) {
            [weakSelf performSelectorOnMainThread:@selector(createMainPage) withObject:response waitUntilDone:NO];
        } errorHandler:^(NSString *error) {
            [weakSelf performSelectorOnMainThread:@selector(pushToMainView:) withObject:error waitUntilDone:NO];
        }];

    }
}


@end
