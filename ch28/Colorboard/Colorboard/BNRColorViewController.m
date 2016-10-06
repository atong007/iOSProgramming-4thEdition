//
//  BNRColorViewController.m
//  Colorboard
//
//  Created by 洪龙通 on 2016/10/6.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRColorViewController.h"
#import "BNRColorDescription.h"

@interface BNRColorViewController ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;
@end

@implementation BNRColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat red, green, blue;
    [self.colorDescription.color getRed:&red green:&green blue:&blue alpha:nil];
    
    self.redSlider.value = red * 255;
    self.greenSlider.value = green * 255;
    self.blueSlider.value = blue * 255;
    
    [self changeColor:nil];
    self.colorTextField.text = self.colorDescription.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.existingColor) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

    self.colorDescription.name = self.colorTextField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

- (IBAction)dismiss:(id)sender {
    
    [self.view endEditing:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changeColor:(id)sender {
    
    float red = self.redSlider.value / 255;
    float greent = self.greenSlider.value / 255;
    float blue = self.blueSlider.value / 255;
    
    UIColor *newColor = [UIColor colorWithRed:red green:greent blue:blue alpha:1.0];
    
    self.view.backgroundColor = newColor;
}
@end
