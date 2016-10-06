//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"

@interface BNRDetailViewController () <UITextFieldDelegate>


@property (nonatomic, weak) UIView *secondView;
@end

@implementation BNRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIView *secondView = [[UIView alloc] init];
//    secondView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:secondView];
//    secondView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.secondView = secondView;
//    NSLog(@"bigView:%@", secondView.superview);
//
//    NSDictionary *nameMap = @{@"bigView" : self.secondView
//                            };
//    
//
//    NSArray *bigViewVerticalConstraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bigView]-|"
//                                            options:NSLayoutFormatAlignAllCenterY
//                                            metrics:nil
//                                              views:nameMap];
//    NSArray *bigViewHorizentalConstraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bigView]-|"
//                                            options:NSLayoutFormatAlignAllCenterX
//                                            metrics:nil
//                                              views:nameMap];
//    NSArray *bigViewConstraint =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bigView(282)]"
//                                            options:0
//                                            metrics:nil
//                                              views:nameMap];
//    NSArray *bigViewConstraint2 =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[bigView(100)]"
//                                            options:0
//                                            metrics:nil
//                                              views:nameMap];
//    [self.view addConstraints:bigViewConstraint];
//    [self.view addConstraints:bigViewConstraint2];
//
//    [self.view addConstraints:bigViewVerticalConstraints];
//    [self.view addConstraints:bigViewHorizentalConstraints];
//    NSLog(@"frame:%@", NSStringFromCGRect(self.secondView.frame));
//    
    
    UIView* imagevew = [[UIView alloc] init];
    imagevew.backgroundColor = [UIColor redColor];
//    [imagevew setContentMode:UIViewContentModeScaleToFill];
    imagevew.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imagevew];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(imagevew);
    //设置高度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-550-[imagevew(100)]" options:0 metrics:nil views:views]];
    //设置宽度
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imagevew(282)]" options:0 metrics:nil views:views]];
    //垂直居中
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imagevew attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    //水平居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imagevew attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //end
    
//    self.itemNameTexField.text = self.selectedItem.itemName;
//    self.itemNameTexField.delegate = self;
//    self.serailTextField.text = self.selectedItem.serialNumber;
//    self.serailTextField.delegate = self;
//    self.valueTextField.text = [NSString stringWithFormat:@"%li", self.selectedItem.valueInDollars];
//    self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
//    self.valueTextField.delegate = self;
//
//    
//    static NSDateFormatter *formatter = nil;
//    if (!formatter) {
//        formatter = [[NSDateFormatter alloc] init];
//        formatter.dateStyle = NSDateFormatterMediumStyle;
//    }
//    NSString *dateString = [formatter stringFromDate:self.selectedItem.dateCreated];
//    self.dateLabel.text = dateString;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
//    self.selectedItem.itemName = self.itemNameTexField.text;
//    self.selectedItem.serialNumber = self.serailTextField.text;
//    self.selectedItem.valueInDollars = [self.valueTextField.text integerValue];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)endEditing
{
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setSelectedItem:(BNRItem *)selectedItem
{
    _selectedItem = selectedItem;
    self.navigationItem.title = selectedItem.itemName;
}

@end
