//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)();

@class BNRItem;
@interface BNRDetailViewController : UIViewController

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) completeBlock dismissBlock;

- (instancetype)initForNewItem:(BOOL)isNew;

@end
