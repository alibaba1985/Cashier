//
//  WLMenuViewController.m
//  Cashier
//
//  Created by liwang on 14-1-24.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "WLMenuViewController.h"

@interface WLMenuViewController ()


@end

@implementation WLMenuViewController
@synthesize menuItems;

- (void)dealloc
{
    self.menuItems = nil;
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

- (void)initWithItems:(NSArray *)items
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    NSInteger count = self.leftMenuItems.count;
    CGFloat width = [self screenWidth] - kScale*[self screenWidth]/2;
    _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableTopMargin, width, kTableCellHeight*count)];
    _menuTable.dataSource = self;
    _menuTable.delegate = self;
    _menuTable.backgroundColor = [UIColor clearColor];
    _menuTable.scrollEnabled = NO;
    _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTable];
    [_menuTable release];
    _menuTable.alpha = 0;
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
