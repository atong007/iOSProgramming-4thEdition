//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/10/5.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRImageTransformer.h"
@import UIKit;

@implementation BNRImageTransformer

/**
 *  声明transformedValue：方法的返回类型
 */
+ (Class)transformedValueClass
{
    return [NSData class];
}

/**
 *  将存储transformable的实体属性转换为可以存储的类型
 */
- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

/**
 *  将转化存储的属性恢复为原有的类型
 */
- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}
@end
