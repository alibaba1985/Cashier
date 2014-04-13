//
//  CPStoreInfoViewController.m
//  Cashier
//
//  Created by liwang on 14-1-25.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPStoreInfoViewController.h"
#import "CPBusinessViewController.h"
#import "CPGoodsInfoViewController.h"
#import "CPCategoryViewController.h"
#import "CPTextField.h"


#define kLogoSize       200
#define kTopMargin      30
#define kTextTopMargin  20
#define kMargin         20
#define kLableWidth     60
#define kLabelheight    30

#define kTextHeight     35

#define kStartTimeTag   101
#define kEndTimeTag     102




@interface UIImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;

@end

@implementation UIImagePickerController (LandScapeImagePicker)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
@end




@interface CPStoreInfoViewController ()
{
    UIImageView *_logoImageView;
    UILabel     *_addImageLabel;
    CPTextField *_storeName;
    CPTextField *_storeCity;
    CPTextField *_storeStreet;
    CPTextField *_sotrePhone;
    CPTextField *_worktimeStart;
    CPTextField *_worktimeEnd;
    UIButton    *_worktimeStartAnchor;
    UIButton    *_worktimeEndAnchor;
    UIButton    *_storeAdressAnchor;
    
    UIPickerView *_datePicker;
    UIPickerView *_storeCityPicker;
    
    UIView *_geoCityIndicator;
    UIView *_geoStreetIndicator;
    
    CLLocationManager   *_locationManager;
    UIActionSheet       *_actionSheet;
    UIPopoverController *_popoverController;
    UIImagePickerController *_imagePicker;
    BOOL _didImagePickerPopover;
}

// important value
@property(nonatomic, copy)NSString *businessStartTime;
@property(nonatomic, copy)NSString *businessEndTime;


- (void)startLocation;

- (CGFloat)createStoreLogoFromY:(CGFloat)y;

- (CGFloat)createStoreNameFromY:(CGFloat)y;

- (CGFloat)createStorePhoneFromY:(CGFloat)y;

- (CGFloat)createStoreAdressFromY:(CGFloat)y;

- (CGFloat)createWorkTimeFromY:(CGFloat)y;

- (void)nextStepAction;

- (void)logoTapAction:(UITapGestureRecognizer *)gesture;

- (void)addGeoIndicator;

- (void)removeGeoIndicator;

- (CAShapeLayer *)lineLayer;

- (UIDatePicker *)createPickerWithTime;

- (void)pickerAction:(UIDatePicker *)picker;


@end

@implementation CPStoreInfoViewController
@synthesize businessEndTime, businessStartTime;

- (void)dealloc
{
    self.businessStartTime = nil;
    self.businessEndTime = nil;
    
    FRelease(_locationManager);
    FRelease(_actionSheet);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array removeObjectAtIndex:0];
    self.navigationController.viewControllers = array;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"设置店铺信息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    
    CGFloat y = kTopMargin*2;
    y = [self createStoreLogoFromY:y];
    
    y = [self createStoreNameFromY:y];
    
    y = [self createStorePhoneFromY:y];
    
    y = [self createStoreAdressFromY:y];
    
    y = [self createWorkTimeFromY:y];
    
    [self addGeoIndicator];
    [self startLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Member Method

- (void)pickerAction:(UIDatePicker *)picker
{
    
    NSDate *date = picker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"time:%@", dateString);
    if (picker.tag == kStartTimeTag) {
        self.businessStartTime = dateString;
        [_worktimeStart setText:dateString]; 
    }
    
    if (picker.tag == kEndTimeTag) {
        self.businessEndTime = dateString;
        [_worktimeEnd setText:dateString];
    }
    [formatter release];
}

- (UIDatePicker *)createPickerWithTime
{
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.backgroundColor = [UIColor clearColor];
    picker.datePickerMode = UIDatePickerModeTime;
    [picker addTarget:self action:@selector(pickerAction:) forControlEvents:UIControlEventValueChanged];
    
    return picker;
}

- (CAShapeLayer *)lineLayer
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, kTextHeight);
    CGPathAddLineToPoint(path, NULL, kLogoSize*2-kLableWidth, kTextHeight);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    [layer setStrokeColor:[[UIColor grayColor] CGColor]];
    [layer setFillColor:[[UIColor clearColor] CGColor]];
    [layer setLineWidth:1];
    [layer setLineCap:kCALineJoinRound];
    [layer setLineJoin:kCALineJoinRound];
    [layer setPosition:CGPointMake(0, 0)];
    [layer setPath:path];
    
    return layer;
}


- (void)addGeoIndicator
{
    //
    _geoCityIndicator = [[UIView alloc] initWithFrame:_storeCity.frame];
    _geoCityIndicator.backgroundColor = [UIColor whiteColor];
    UIActivityIndicatorView *cityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cityIndicator setFrame:CGRectMake(0, 0, CGRectGetHeight(_storeCity.frame), CGRectGetHeight(_storeCity.frame))];
    cityIndicator.center = CGPointMake(CGRectGetWidth(_storeCity.frame)/2 - 40, CGRectGetHeight(_storeCity.frame)/2);
    [cityIndicator startAnimating];
    [_geoCityIndicator addSubview:cityIndicator];
    [cityIndicator release];
    
    UILabel *cityLabel = [CPCocoaSubViews labelWithFrame:CGRectMake(CGRectGetWidth(_storeCity.frame)/2 - 20, 0, 100, CGRectGetHeight(_storeCity.frame)) text:@"定位中..." alignment:NSTextAlignmentLeft color:[UIColor grayColor] font:[UIFont systemFontOfSize:18]];
    [_geoCityIndicator addSubview:cityLabel];
    
    [_mainBoardView addSubview:_geoCityIndicator];
    [_geoCityIndicator release];
    
    //
    _geoStreetIndicator = [[UIView alloc] initWithFrame:_storeStreet.frame];
    _geoStreetIndicator.backgroundColor = [UIColor whiteColor];
    
    UIActivityIndicatorView *streetIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [streetIndicator setFrame:CGRectMake(0, 0, CGRectGetHeight(_storeCity.frame), CGRectGetHeight(_storeCity.frame))];
    streetIndicator.center = CGPointMake(CGRectGetWidth(_storeCity.frame)/2 - 40, CGRectGetHeight(_storeCity.frame)/2);
    [streetIndicator startAnimating];
    [_geoCityIndicator addSubview:streetIndicator];
    [streetIndicator release];
    
    UILabel *streetLabel = [CPCocoaSubViews labelWithFrame:CGRectMake(CGRectGetWidth(_storeCity.frame)/2 - 20, 0, 100, CGRectGetHeight(_storeCity.frame)) text:@"定位中..." alignment:NSTextAlignmentLeft color:[UIColor grayColor] font:[UIFont systemFontOfSize:18]];
    [_geoCityIndicator addSubview:streetLabel];
    
    [_geoStreetIndicator addSubview:streetIndicator];
    [_geoStreetIndicator addSubview:streetLabel];
    [_mainBoardView addSubview:_geoStreetIndicator];
    [_geoStreetIndicator release];
}

- (void)removeGeoIndicator
{
    [_geoCityIndicator removeFromSuperview];
    [_geoStreetIndicator removeFromSuperview];
}


- (void)startLocation
{
    _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=1000.0f;
    //启动位置更新
    [_locationManager startUpdatingLocation];
}


- (void)nextStepAction
{
    for (UITextField *textField in _textFieldArray) {
        if (![self checkEmptyAndIllegalForTextField:textField]) {
            return;
        }
    }

    CPCategoryViewController *c = [[CPCategoryViewController alloc] init];
    [self.navigationController pushViewController:c animated:YES];
    [c release];
}

- (void)logoTapAction:(UITapGestureRecognizer *)gesture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"制作头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片", @"从相册选择", nil];
        _actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [_actionSheet showInView:self.view];
    }
    else
    {
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([CPValueUtility iPadDevice]) {
            _didImagePickerPopover = YES;
            [_popoverController presentPopoverFromRect:_logoImageView.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
    }
}

- (CGFloat)createStoreLogoFromY:(CGFloat)y
{
    
    CGRect logoFrame = CGRectMake((FScreenWidth-kLogoSize)/2, y, kLogoSize, kLogoSize);
    UIView *logoBGView = [[UIView alloc] initWithFrame:logoFrame];
    logoBGView.backgroundColor = [UIColor whiteColor];
    logoBGView.layer.borderColor = [UIColor grayColor].CGColor;
    logoBGView.layer.borderWidth = 1;
    [_mainBoardView addSubview:logoBGView];
    [logoBGView release];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:logoBGView.bounds];
    _logoImageView.userInteractionEnabled = NO;
    [logoBGView addSubview:_logoImageView];
    [_logoImageView release];
    
    CGRect labelFrame = CGRectMake(0, (kLogoSize-kLabelheight)/2, kLogoSize, kLabelheight);
    _addImageLabel = [CPCocoaSubViews labelWithFrame:labelFrame
                                                text:@"点击添加图片"
                                           alignment:NSTextAlignmentCenter
                                               color:[UIColor grayColor]
                                                font:[UIFont systemFontOfSize:kFontNormal]];
    [logoBGView addSubview:_addImageLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTapAction:)];
    [logoBGView addGestureRecognizer:gesture];
    [gesture release];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:_imagePicker];
    [_imagePicker release];
    
    
    
    return y+kTopMargin + kLogoSize;
}

- (CGFloat)createStoreNameFromY:(CGFloat)y
{
    CGRect labelFrame = CGRectMake((FScreenWidth - 2*kLogoSize)/2, y, kLableWidth, kLabelheight);
    UILabel *label = [CPCocoaSubViews labelWithFrame:labelFrame text:@"店名:" alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:label];
    
    CGRect nameFrame = CGRectMake(labelFrame.origin.x + labelFrame.size.width, y, kLogoSize*2-kLableWidth, kTextHeight);
    _storeName = [CPCocoaSubViews textFieldWithFrame:nameFrame placeHolder:nil delegate:self description:@"店名"];
    
    [_storeName.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:_storeName];
    [_textFieldArray addObject:_storeName];
    
    
    return y+kTopMargin/3 + kTextHeight;
}

- (CGFloat)createStorePhoneFromY:(CGFloat)y
{
    CGRect labelFrame = CGRectMake((FScreenWidth - 2*kLogoSize)/2, y, kLableWidth, kLabelheight);
    UILabel *label = [CPCocoaSubViews labelWithFrame:labelFrame text:@"电话:" alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:label];
    
    CGRect phoneFrame = CGRectMake(labelFrame.origin.x + labelFrame.size.width, y, kLogoSize*2-kLableWidth, kTextHeight);
    UITextField *phone = [CPCocoaSubViews textFieldWithFrame:phoneFrame placeHolder:nil delegate:self description:@"电话"];
    [phone.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:phone];
    [_textFieldArray addObject:phone];
    
    
    return y+kTopMargin/3 + kTextHeight;
}

- (CGFloat)createStoreAdressFromY:(CGFloat)y
{
    CGRect cityLabelFrame = CGRectMake((FScreenWidth - 2*kLogoSize)/2, y, kLableWidth, kLabelheight);
    UILabel *cityLabel = [CPCocoaSubViews labelWithFrame:cityLabelFrame text:@"省市:" alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:cityLabel];
    
    CGRect cityFrame = CGRectMake(cityLabelFrame.origin.x + cityLabelFrame.size.width, y, kLogoSize*2-kLableWidth, kTextHeight);
    _storeCity = [CPCocoaSubViews textFieldWithFrame:cityFrame placeHolder:nil delegate:self description:@"省市"];
    [_storeCity.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:_storeCity];
    [_textFieldArray addObject:_storeCity];
    
    y += kTopMargin/3 + kTextHeight;
    
    
    CGRect streetLabelFrame = CGRectMake((FScreenWidth - 2*kLogoSize)/2, y, kLableWidth, kLabelheight);
    UILabel *streetLabel = [CPCocoaSubViews labelWithFrame:streetLabelFrame text:@"街道:" alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:streetLabel];
    
    CGRect streetFrame = CGRectMake(streetLabelFrame.origin.x + streetLabelFrame.size.width, y, kLogoSize*2-kLableWidth, kTextHeight);
    _storeStreet = [CPCocoaSubViews textFieldWithFrame:streetFrame placeHolder:nil delegate:self description:@"街道"];
    [_storeStreet.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:_storeStreet];
    [_textFieldArray addObject:_storeStreet];
    
    y += kTopMargin/3 + kTextHeight;
    
    return y;
}

- (CGFloat)createWorkTimeFromY:(CGFloat)y
{
    CGRect timeLabelFrame = CGRectMake((FScreenWidth - 2*kLogoSize)/2, y, kLableWidth, kLabelheight);
    UILabel *timeLabel = [CPCocoaSubViews labelWithFrame:timeLabelFrame text:@"营业日:" alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:timeLabel];
    
    CGRect timeFrame = CGRectMake(timeLabelFrame.origin.x + timeLabelFrame.size.width, y, (kLogoSize*2-kLableWidth - kMargin)/2, kTextHeight);
    _worktimeStart = [CPCocoaSubViews textFieldWithFrame:timeFrame placeHolder:nil delegate:self description:@"营业开始时间"];
    UIDatePicker *startPicker = [self createPickerWithTime];
    startPicker.tag = kStartTimeTag;
    _worktimeStart.inputView = startPicker;
    [_worktimeStart.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:_worktimeStart];
    [_textFieldArray addObject:_worktimeStart];
    
    
    CGRect indicatorFrame = CGRectMake(_worktimeStart.frame.origin.x + _worktimeStart.frame.size.width, y, kMargin, kTextHeight);
    UILabel *indicator = [CPCocoaSubViews labelWithFrame:indicatorFrame text:@"~" alignment:NSTextAlignmentCenter color:[UIColor blackColor] font:[UIFont systemFontOfSize:kFontNormal]];
    [_mainBoardView addSubview:indicator];
    
    
    CGRect endtimeFrame = CGRectMake(_worktimeStart.frame.origin.x + _worktimeStart.frame.size.width + kMargin, y, (kLogoSize*2-kLableWidth - kMargin)/2, kTextHeight);
    _worktimeEnd = [CPCocoaSubViews textFieldWithFrame:endtimeFrame placeHolder:nil delegate:self description:@"营业结束时间"];
    UIDatePicker *endPicker = [self createPickerWithTime];
    endPicker.tag = kEndTimeTag;
    _worktimeEnd.inputView = endPicker;
    [_worktimeEnd.layer addSublayer:[self lineLayer]];
    [_mainBoardView addSubview:_worktimeEnd];
    [_textFieldArray addObject:_worktimeEnd];;
    
    y += kTopMargin/3 + kTextHeight;
    
    return y;
}


#pragma mark - CLLocation Delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    NSString *lat = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
    
    NSLog(@"-%@=%@", lat, lon);
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    
    [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"failed with error: %@", error);
        }
        else {
            
            /*
             --key:Street---value:上丰路 943号--
             --key:Thoroughfare---value:上丰路--
             --key:Name---value:中国上海市浦东新区唐镇上丰路943号--
             --key:Country---value:中国--
             --key:State---value:上海市--
             --key:SubLocality---value:浦东新区--
             --key:SubThoroughfare---value:943号--
             --key:CountryCode---value:CN--
             */
            for (CLPlacemark *placemark in placemarks) {
                NSString *state = [placemark.addressDictionary objectForKey:@"State"];
                NSString *subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
                NSString *street = [placemark.addressDictionary objectForKey:@"Street"];
                NSString *city = nil;
                if (state != nil) {
                    city = (subLocality != nil) ? [NSString stringWithFormat:@"%@%@", state, subLocality] : state;
                }
                else
                {
                    city = subLocality;
                }
                
                if (city != nil) {
                    [_storeCity setText:city];
                }
                
                if (street != nil) {
                    [_storeStreet setText:street];
                }

            }
  
        }
        [self removeGeoIndicator];
    }];
    
    FRelease(geo);
    FRelease(_locationManager);
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    FRelease(_locationManager);
    [self removeGeoIndicator];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {// camera
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.showsCameraControls = YES;
        _imagePicker.allowsEditing = YES;
        if ([CPValueUtility iPadDevice]) {
            _didImagePickerPopover = YES;
            [_popoverController presentPopoverFromRect:_logoImageView.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1)// ablum
    {
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([CPValueUtility iPadDevice]) {
            _didImagePickerPopover = YES;
            [_popoverController presentPopoverFromRect:_logoImageView.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 2)// cancel
    {
        
    }
}


#pragma mark - UIImagePickerDelegate


//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_logoImageView setImage:selectedImage];
    [_addImageLabel removeFromSuperview];
    
    if (_didImagePickerPopover) {
        [_popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //模态方式退出uiimagepickercontroller
    //[_imagePicker dismissModalViewControllerAnimated:YES];
}
//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}

@end
