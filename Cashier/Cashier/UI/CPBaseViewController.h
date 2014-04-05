//
//  CPBaseViewController.h
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPResourceManager.h"
#import "CPConstDefine.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPPreDisplayArea.h"
#import "CPViewAnimations.h"
#import "CPNetworkManager.h"
#import "CPToast.h"
#import "CPServerAdressDefine.h"
#import "CPTextField.h"

@interface CPBaseViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_currentResponserTextField;
    CGRect _originalFrame;
    CGRect _mainBoardFrame;
    UIScrollView *_mainBoardView;
    NSMutableArray *_textFieldArray;
    
}

@property(nonatomic, retain)CPNetworkManager *netEntry;

- (void)showToastMessage:(NSString *)message position:(CPToastPosition)position;

- (void)showAlertMessage:(NSString *)message okBtn:(NSString *)okTitle cancelBtn:(NSString *)cancelTitle;

- (void)showLoadingWithTitle:(NSString *)title;

- (void)dismissLoading;

- (BOOL)checkEmptyAndIllegalForTextField:(UITextField *)textField;

@end
