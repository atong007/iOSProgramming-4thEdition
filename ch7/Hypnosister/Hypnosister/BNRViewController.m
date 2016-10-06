//
//  BNRViewController.m
//  Hypnosister
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRViewController.h"
#import "BNRHypnosisterView.h"

@interface BNRViewController () <UIScrollViewDelegate>

@end

@implementation BNRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    //    [self.window addSubview:scrollView];
    [self.view addSubview:scrollView];
    
    scrollView.delegate = self;
    scrollView.multipleTouchEnabled = YES;
    // 这两个值不设置的话view的缩放代理无法调用
    scrollView.maximumZoomScale = 5.0;
    scrollView.minimumZoomScale = 0.5;
    CGRect bigRect = scrollView.bounds;
    bigRect.size.width *= 2;
    bigRect.size.height *= 2;
    BNRHypnosisterView *firstView = [[BNRHypnosisterView alloc] initWithFrame:bigRect];
    [scrollView addSubview:firstView];
    scrollView.contentSize = bigRect.size;

}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    BNRHypnosisterView *firstView = [scrollView.subviews lastObject];
    CGRect frame = firstView.frame;
    frame.size.width *= scrollView.zoomScale;
    frame.size.height *= scrollView.zoomScale;
    firstView.frame = frame;
}
@end
