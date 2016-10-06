//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by 洪龙通 on 2016/9/30.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@interface BNRDrawViewController ()

@end

@implementation BNRDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}


@end
