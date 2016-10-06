//
//  BNRLine.m
//  TouchTracker
//
//  Created by 洪龙通 on 2016/9/30.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRLine.h"

@interface BNRLine() <NSCopying>

@end
@implementation BNRLine

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSValue valueWithCGPoint:self.begin] forKey:@"begin"];
    [coder encodeObject:[NSValue valueWithCGPoint:self.end] forKey:@"end"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSValue *beginValue = [coder decodeObjectForKey:@"begin"];
        NSValue *endValue = [coder decodeObjectForKey:@"end"];
        _begin = [beginValue CGPointValue];
        _end = [endValue CGPointValue];
    }
    return self;
}
@end
