//
//  BNRHypnosisterView.m
//  Hypnosister
//
//  Created by 洪龙通 on 2016/9/27.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRHypnosisterView.h"

@implementation BNRHypnosisterView

//- (void)drawRect:(CGRect)rect
//{
//    CGPoint center;
//    center.x = self.bounds.origin.x + self.bounds.size.width / 2.0;
//    center.y = self.bounds.origin.y + self.bounds.size.height / 2.0;
//
//    float maxRadius = hypot(self.bounds.size.width, self.bounds.size.height) / 2.0;
//
//    UIBezierPath *path = [[UIBezierPath alloc] init];
//
//    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
//        // 每次绘制时提起笔
//        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
//        [path addArcWithCenter:center radius:currentRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    }
//    [path setLineWidth:10];
//    [[UIColor lightGrayColor] setStroke];
//
//    [path stroke];
//
//    UIImage *image = [UIImage imageNamed:@"logo"];
//    [image drawInRect:self.bounds];
//}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentRef = UIGraphicsGetCurrentContext();
    
    CGPoint center;
    center.x = self.bounds.origin.x + self.bounds.size.width / 2.0;
    center.y = self.bounds.origin.y + self.bounds.size.height / 2.0;
    
    float maxRadius = hypot(self.bounds.size.width, self.bounds.size.height) / 2.0;
    CGContextSetStrokeColorWithColor(currentRef, [[UIColor lightGrayColor] CGColor]);
    CGContextSetLineWidth(currentRef, 10.0);
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        CGContextAddArc(currentRef, center.x, center.y, currentRadius, 0, M_PI * 2, YES);
        CGContextStrokePath(currentRef);
    }
    
    CGContextMoveToPoint(currentRef, center.x, 100);
    CGContextAddLineToPoint(currentRef, center.x - 150, 600);
    CGContextAddLineToPoint(currentRef, center.x + 150, 600);
    CGContextClosePath(currentRef);
    
    CGContextSaveGState(currentRef);
    CGContextClip(currentRef);
    
    CGFloat locations[2]  = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0,// 起始颜色为红色
        1.0, 1.0, 0.0, 1.0};// 起始颜色为黄色
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, 2);
    CGContextDrawLinearGradient(currentRef, gradient, CGPointMake(center.x, 100), CGPointMake(center.x + 150, 700), kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(currentRef);
    
    CGContextSaveGState(currentRef);
    CGContextSetShadow(currentRef, CGSizeMake(4, 7), 3);
    
    UIImage *image = [UIImage imageNamed:@"logo"];
    [image drawInRect:CGRectMake(100, 100, self.bounds.size.width - 200, self.bounds.size.height - 200)];
    
    CGContextRestoreGState(currentRef);
}

@end
