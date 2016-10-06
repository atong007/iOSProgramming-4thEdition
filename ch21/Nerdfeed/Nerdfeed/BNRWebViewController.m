//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by 洪龙通 on 2016/10/5.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController ()

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation BNRWebViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    if (_url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:_url];
        [(UIWebView *)self.view loadRequest:request];
    }
}

@end
