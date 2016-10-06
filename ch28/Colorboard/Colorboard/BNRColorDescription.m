//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by 洪龙通 on 2016/10/6.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRColorDescription.h"

@implementation BNRColorDescription

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.0];
        _name = @"Blue";
    }
    return self;
}
@end
