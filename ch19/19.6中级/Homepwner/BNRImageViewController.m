//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/10/4.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:pinchGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 必须将view转换为UIImageView对象，以便向其发送setImage:消息
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView;
}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pinchImage:(UIPinchGestureRecognizer *)gr
{
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, gr.scale, gr.scale);
}
@end
