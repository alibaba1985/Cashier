//
//  CPConstDefine.h
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPResourceManager.h"
#import "CPValueUtility.h"
//  string

#define kEmptyFormatter   @"亲,%@还没填呢~"
#define kErrorFormatter   @"亲,%@格式错啦~"
#define kInputPrefix      @"请输入"

#define FStringEmptyWith(X)  [NSString stringWithFormat:kEmptyFormatter, X]
#define FStringErrorWith(X)  [NSString stringWithFormat:kErrorFormatter, X]

#define FCheckRegex(S,D)     [CPValueUtility isValidateTextField:S regex:D]

#define FRemoveString(S,D)   [S stringByReplacingOccurrencesOfString:D withString:@""]

// consts

#define kUserNameRegex      @"^\\w*[a-zA-Z_]+\\w*$"
#define kEmailRegex         @"(?=.{0,64})\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
#define kPhoneRegex         @"1[3458]\\d{9}"
#define kPWDRegex           @"^([A-Z]|[a-z]|[\d])*$"

//-----------------Size Const------------------

#define kFontNormal  20
#define kFontBig     22
#define kFontMiddle  18
#define kFontSmall   16

#define kTextFieldWidth    300
#define kTextFieldHeight   44


//-----------------Function Const------------------
#define FScreenWidth              [CPValueUtility screenWidth]
#define FScreenHeight             [CPValueUtility screenHeight]
#define FGetStringByKey(X)           [[CPResourceManager shareInstance].stringResource objectForKey:X]
#define FGetImageNameByKey(X)            [UIImage imageNamed:[[CPResourceManager shareInstance].imageResource objectForKey:X]]


#define FRelease(X) if (X != nil) {[X release];X = nil;}

//-----------------String Const------------------

#define kTitle_MainVC                       @"Title_MainVC"
#define kTitle_LoginVC                      @"Title_LoginVC"
#define kTitle_RegisterVC                   @"Title_RegisterVC"
#define kTitle_ResetPWDVC                   @"Title_ResetPWDVC"
#define kTitle_GetBackPWDVC                 @"Title_GetBackPWDVC"



//-----------------Image Const------------------

#define kImage_NavBarBg                     @"Image_NavBarBg"
#define kImage_Display                      @"Image_Display"

#define kPreDisplay_1                       @"PreDisplay_1"
#define kPreDisplay_2                       @"PreDisplay_2"
#define kPreDisplay_3                       @"PreDisplay_3"
#define kPreDisplay_4                       @"PreDisplay_4"
#define kPreDisplay_5                       @"PreDisplay_5"

#define kBtn_StartTryNormal                 @"Btn_StartTryNormal"
#define kBtn_StartTryHighLight              @"Btn_StartTryHighLight"

#define kBar_Background                     @"Bar_Background"
#define kBar_Infos_HighLight                @"Bar_Infos_HighLight"
#define kBar_Infos_Normal                   @"Bar_Infos_Normal"
#define kBar_Menu_HighLight                 @"Bar_Menu_HighLight"
#define kBar_Menu_Normal                    @"Bar_Menu_Normal"
#define kBar_Back_Normal                    @"Bar_Back_Normal"
#define kBar_Back_HighLight                 @"Bar_Back_HighLight"

//-----------------BtnTitlt Const------------------
#define kBtn_Register                       @"Btn_Register"
#define kBtn_Login                          @"Btn_Login"
#define kBtn_StartTry                       @"Btn_StartTry"


// database

// 1
#define kDBID                    @"ID"
#define kDBName                  @"ConfigName"
#define kDBValue                 @"ItemValue"
#define kDBText                  @"ItemText"
#define kDBRemark                @"Remark"
#define kDBCreateUser            @"CreateUser"
#define kDBCreateTime            @"CreateTime"
#define kDBUpdateUser            @"UpdateUser"
#define kDBUpdateTime            @"UpdateTime"

// 2

#define kGoodsTotalPrice         @"GoodsTotalPrice"
#define kGoodsNumber             @"GoodsNumber"

#define kDBMenuNo                @"MenuNo"
#define kDBMenuName              @"MenuName"
#define kDBMenuType              @"MenuType"
#define kDBImagePath             @"ImagePath"
#define kDBSalePrice             @"SalePrice"
#define kDBSaleUnit              @"SaleUnit"
