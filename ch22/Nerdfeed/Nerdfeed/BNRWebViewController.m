//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by 洪龙通 on 2016/10/5.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UIWebViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIBarButtonItem *goBackButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;

@end

@implementation BNRWebViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:webView action:@selector(goBack)];
    self.goBackButton = goBackButton;
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStyleDone target:webView action:@selector(goForward)];
    toolBar.items = @[goBackButton, forwardButton];
    self.forwardButton = forwardButton;
    
    [webView addSubview:toolBar];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.goBackButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}

#pragma mark - UISpliteViewControllerDelegate

//- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
//{
//    barButtonItem.title = @"Courses";
//    self.navigationItem.leftBarButtonItem = barButtonItem;
//}
//
//- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    
//}


- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else if (displayMode == UISplitViewControllerDisplayModeAllVisible){
        if (self.navigationItem.leftBarButtonItem) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}
@end
