//
//  BNRItemCell.h
//  Homepwner
//
//  Created by 洪龙通 on 2016/10/4.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;
@interface BNRItemCell : UITableViewCell

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void(^actionBlock)();
@end
