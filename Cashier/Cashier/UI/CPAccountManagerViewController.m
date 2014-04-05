//
//  CPAccountManagerViewController.m
//  Cashier
//
//  Created by liwang on 14-1-21.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPAccountManagerViewController.h"

@interface CPAccountManagerViewController ()

@end

@implementation CPAccountManagerViewController

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
    self.title = @"账户";
    self.view.backgroundColor = [UIColor brownColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
