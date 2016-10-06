//
//  BNRColorViewController.h
//  Colorboard
//
//  Created by 洪龙通 on 2016/10/6.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRColorDescription;
@interface BNRColorViewController : UIViewController

@property (nonatomic, assign) BOOL existingColor;
@property (nonatomic, strong) BNRColorDescription *colorDescription;
@end
