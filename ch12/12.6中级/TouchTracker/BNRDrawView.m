//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 洪龙通 on 2016/9/30.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

#define kFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lines.archive"]

@interface BNRDrawView()

//@property (nonatomic, strong) BNRLine *currentLine;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end
@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.finishedLines = [self restoreLinesFromFile];
        if (!self.finishedLines) {
            self.finishedLines = [NSMutableArray array];
        }
        self.linesInProgress = [NSMutableDictionary dictionary];
        self.multipleTouchEnabled = YES;
    }
    [self setNeedsDisplay];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:line.begin];
    [path addLineToPoint:line.end];
    [path stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // UITouch不遵循NSCopy协议，所以不能直接作为key存入字典中
    for (UITouch *touch in touches) {
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = [touch locationInView:self];
        line.end = [touch locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 向控制台输出日志，查看触摸事件发生的顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        BNRLine *line = self.linesInProgress[key];
        line.end = [touch locationInView:self];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        BNRLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self storeLines];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)storeLines
{
    BOOL success = [NSKeyedArchiver archiveRootObject:self.finishedLines toFile:kFilePath];
    if (!success) {
        NSLog(@"file archive failed");
    }
}

- (NSMutableArray *)restoreLinesFromFile
{
    NSMutableArray *lineArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
    NSLog(@"line:%@", lineArray);
   return lineArray;
}
@end
