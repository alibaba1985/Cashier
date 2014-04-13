//
//  CPMoreViewController.m
//  Cashier
//
//  Created by liwang on 14-1-24.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPMoreViewController.h"

@interface CPMoreViewController ()

@end

@implementation CPMoreViewController

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
    self.title = @"更多";
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
