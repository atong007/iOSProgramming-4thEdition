//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by 洪龙通 on 2016/9/28.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisterView.h"

@implementation BNRHypnosisViewController

// 控制器刚创建时view为nil，在需要控制器的视图显示到屏幕时，
// 如果view为nil，会调用此方法来初始化view
- (void)loadView
{
    BNRHypnosisterView *backgroundView = [[BNRHypnosisterView alloc] init];
    
    self.view = backgroundView;
}

/**
 *  指定初始化方法, init方法也会调用此方法来初始化
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.title = @"Hypnosis";
        self.tabBarItem.image = [UIImage imageNamed:@"Hypnosis-TabBar"];
    }
    return self;
}

@end
