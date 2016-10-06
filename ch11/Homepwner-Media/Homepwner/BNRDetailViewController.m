//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemNameTexField;
@property (weak, nonatomic) IBOutlet UITextField *serailTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

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
    
    self.imageView.image = [[BNRImageStore sharedInstance] imageForKey:self.selectedItem.itemKey];
    if (!self.imageView.image) {
        self.trashButton.enabled = NO;
    }
    
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
/**
 *  点击背景空白处弹回键盘
 */
- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    // 如果设备支持拍照，就使用拍照模式
    // 否则让用户从照片库选择图片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)deleteImage:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除照片"
                                                                   message:@"确定删除此照片？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                                  self.imageView.image = nil;
                                                                  [[BNRImageStore sharedInstance] deleteImageForKey:self.selectedItem.itemKey];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImage picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
//    self.imageView.image = pickedImage;
//    self.trashButton.enabled = YES;

    if (mediaURL) {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([mediaURL path])) {
            
            UISaveVideoAtPathToSavedPhotosAlbum([mediaURL path], nil, nil, nil);
            
            [[NSFileManager defaultManager] removeItemAtPath:[mediaURL path] error:NULL];
        }
    }
//    [[BNRImageStore sharedInstance] setImage:pickedImage forKey:self.selectedItem.itemKey];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
