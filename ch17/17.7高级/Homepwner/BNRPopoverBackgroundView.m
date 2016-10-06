//
//  BNRPopoverBackgroundView.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/10/3.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRPopoverBackgroundView.h"

#define kArrowBase 30.0f
#define kArrowHeight 20.0f
#define kBorderInset 2.0f

@interface BNRPopoverBackgroundView()

@property (nonatomic, weak) UIImageView *arrowImageView;
@end
@implementation BNRPopoverBackgroundView

/**
 *  这两个属性必须自己实现，不然会报错
 */
@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.arrowImageView = arrowImageView;
        [self addSubview:self.arrowImageView];
    }
    return self;
}

/**
 * arrowBase方法确定arrow底部的宽度。
 */
+ (CGFloat)arrowBase
{
    return kArrowBase;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kBorderInset, kBorderInset, kBorderInset, kBorderInset);
}

/**
 * arrowHeight方法确定arrow的高度
 */
+ (CGFloat)arrowHeight
{
    return kArrowHeight;
}

- (UIPopoverArrowDirection)arrowDirection
{
    return UIPopoverArrowDirectionLeft;
}

/**
 *  wantsDefaultContentAppearance方法决定是否在popover中展示默认的内置阴影和圆角，如果返回的是“NO”，
    Popover Background View将不再展示默认的阴影和圆角，允许执行你自己的.
 *
 */
+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}


- (UIImage *)drawArrowImage:(CGSize)size;
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f);
    CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height);
    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height);
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    UIColor *fillColor = [UIColor yellowColor];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    self.arrowImageView.image = [self drawArrowImage:arrowSize];
    self.arrowImageView.frame = CGRectMake(kBorderInset, 0, arrowSize.width, arrowSize.height);
}


@end
