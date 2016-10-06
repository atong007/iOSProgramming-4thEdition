//
//  BNRContainer.m
//  RandomItems
//
//  Created by 洪龙通 on 2016/9/27.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRContainer.h"

@interface BNRContainer()

@end
@implementation BNRContainer
{
    NSInteger _valueCount;
}

- (void)setSubitems:(NSArray *)subitems
{
    _subitems = [subitems copy];
    for (BNRItem *item in _subitems) {
        _valueCount += item.valueInDollars;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ :worth %li \n%@",self.itemName, _valueCount, self.subitems];
}
@end
