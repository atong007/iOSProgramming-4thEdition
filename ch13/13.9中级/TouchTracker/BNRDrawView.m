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

@interface BNRDrawView() <UIGestureRecognizerDelegate>

// 此处line设置为weak引用是因为finishedLines已经拥有了这个对象，不需要作强引用
// 而且当finishedLines做remove操作时，此line也会变成nil
@property (nonatomic, weak) BNRLine *selectedLine;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end
@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.finishedLines = [self restoreLinesFromFile];
        if (!self.finishedLines) {
            self.finishedLines = [NSMutableArray array];
        }
        self.linesInProgress = [NSMutableDictionary dictionary];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        // 当双击事件发生时禁止单击事件识别
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressRecognizer.delaysTouchesBegan = YES;
        NSLog(@"%d", longPressRecognizer.cancelsTouchesInView);
        // 当双击事件发生时禁止单击事件识别
        [self addGestureRecognizer:longPressRecognizer];
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        // 默认为YES，这个对象会在识别出手势时优先“吃掉”所有和该手势相关的UITouch对象，
        // 导致touchMove:WithEvent:无法触发更无法创建BNRLine；
        // 设置为NO则可以保证能继续收到UIResponder消息
        self.panRecognizer.cancelsTouchesInView = NO;
        self.panRecognizer.delegate = self;
        
        // 当双击事件发生时禁止单击事件识别
        [self addGestureRecognizer:self.panRecognizer];
    }
    [self setNeedsDisplay];
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gr
{
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    NSLog(@"tap!");
    if (self.selectedLine) {
        
        // 使视图成为UIMenuItem动作消息的目标
        [self becomeFirstResponder];
        
        // 获取UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        // 创建一个新的标题为“Delete”的UIMenuItem对象
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        // 先为UIMenuController对象设置显示区域，然后将其设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
        [self setNeedsDisplay];
    }else {
        // 如果没有选中，则隐藏已经显示的UIMenuController对象
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)deleteLine:(id)sender
{
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

- (void)doubleTap:(UITapGestureRecognizer *)gr
{
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)longPress:(UILongPressGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    }else if (gr.state == UIGestureRecognizerStateEnded){
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)gr
{
    if (!self.selectedLine || [UIMenuController sharedMenuController].isMenuVisible) {
        return;
    }
    if (gr.state == UIGestureRecognizerStateChanged) {
        // 获取手指的拖移位置
        CGPoint translation = [gr translationInView:self];
        
        // 将拖移距离加至选中的线条的起点和终点
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        // 为选中的线条设置新的起点和终点
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        // 将手指的当前位置设为拖移手势的起始位置
        [gr setTranslation:CGPointZero inView:self];
    }
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
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
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

- (BNRLine *)lineAtPoint:(CGPoint)p
{
    // 找出离p最近的BNRLine对象
    for (BNRLine *line in self.finishedLines) {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        
        // 检查线条的若干点
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            // 如果线条的某个点和p的距离在20点之内，就返回相应的BNRLine对象
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return line;
            }
        }
    }
    return nil;
}

#pragma mark - UIResponder message
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.selectedLine) {
        self.selectedLine = nil;
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
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

#pragma mark - UIGestureRecognizer delegate
// 允许多个手势识别器对同一个手势进行识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panRecognizer) {
        return YES;
    }
    return NO;
}
@end
