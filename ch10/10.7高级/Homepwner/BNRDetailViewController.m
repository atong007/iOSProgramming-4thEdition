//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRReminderViewController.h"

@interface BNRDetailViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemNameTexField;
@property (weak, nonatomic) IBOutlet UITextField *serailTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation BNRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNameTexField.text = self.selectedItem.itemName;
    self.itemNameTexField.delegate = self;
    self.serailTextField.text = self.selectedItem.serialNumber;
    self.serailTextField.delegate = self;
    self.valueTextField.text = [NSString stringWithFormat:@"%li", self.selectedItem.valueInDollars];
    self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.valueTextField.delegate = self;

    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
    }
    NSString *dateString = [formatter stringFromDate:self.selectedItem.dateCreated];
    self.dateLabel.text = dateString;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
    self.selectedItem.itemName = self.itemNameTexField.text;
    self.selectedItem.serialNumber = self.serailTextField.text;
    self.selectedItem.valueInDollars = [self.valueTextField.text integerValue];
    
}
- (IBAction)changeDate:(id)sender {
    
    BNRReminderViewController *reminderVC = [[BNRReminderViewController alloc] init];
    reminderVC.dateCreated = self.selectedItem.dateCreated;
    [self.navigationController pushViewController:reminderVC animated:YES];
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
