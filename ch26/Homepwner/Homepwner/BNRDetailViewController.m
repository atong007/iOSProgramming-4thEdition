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
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"
#import "AppDelegate.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemNameTexField;
@property (weak, nonatomic) IBOutlet UITextField *serailTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (isNew) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddition)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
        }else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing)];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNameTexField.text = self.item.itemName;
    self.itemNameTexField.delegate = self;
    self.serailTextField.text = self.item.serialNumber;
    self.serailTextField.delegate = self;
    self.valueTextField.text = [NSString stringWithFormat:@"%lu", self.item.valueInDollars];
    self.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.valueTextField.delegate = self;

    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
    }
    NSString *dateString = [formatter stringFromDate:self.item.dateCreated];
    self.dateLabel.text = dateString;
    
    self.imageView.image = [[BNRImageStore sharedInstance] imageForKey:self.item.itemKey];
    if (!self.imageView.image) {
        self.trashButton.enabled = NO;
    }

    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareViewsForOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type:%@", typeLabel];
    
    [self updateFonts];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.view endEditing:YES];
    self.item.itemName = self.itemNameTexField.text;
    self.item.serialNumber = self.serailTextField.text;
    
    int newValue = [self.valueTextField.text intValue];
    // 比较valueInDollars属性与valueField中的新值，判断是否有改动
    if (newValue != self.item.valueInDollars) {
        
        // 如果有改动，将新值赋给valueInDollars属性
        self.item.valueInDollars = newValue;
        
        // 将新值存入NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:newValue forKey:BNRNextItemValuePrefsKey];
    }
    
}

/**
 *  根据用户首选字体和传入的文本样式返回对应的UIFont对象
 */
- (void)updateFonts
{
//    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFont *font = [UIFont systemFontOfSize:8.0];
    
    self.NameLabel.font = font;
    self.serialLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.itemNameTexField.font = font;
    self.serailTextField.font = font;
    self.valueTextField.font = font;
}

/**
 *  取消添加
 */
- (void)cancelAddition
{
    [[BNRItemStore sharedInstance] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        self.dismissBlock();
    }];
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

- (void)setitem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // 如果是iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // 判断设置是否处于横排方向
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 如果是iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // 如果宽度大于高度则说明是横屏状态
    if (size.width > size.height) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

/**
 *  点击背景空白处弹回键盘
 */
- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(UIBarButtonItem *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;
    imagePicker.popoverPresentationController.sourceView = self.toolBar;
    imagePicker.popoverPresentationController.sourceRect = self.toolBar.bounds;
    
    // 如果设备支持拍照，就使用拍照模式
    // 否则让用户从照片库选择图片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
//    [self setModalInPopover:YES];
}
- (IBAction)showAssetTypePicker:(id)sender
{
    BNRAssetTypeViewController *assetTypeVC = [[BNRAssetTypeViewController alloc] init];
    assetTypeVC.item = self.item;
    
    [self.navigationController pushViewController:assetTypeVC animated:YES];
}

- (IBAction)deleteImage:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"删除照片"
                                                                   message:@"确定删除此照片？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                                  self.imageView.image = nil;
                                                                  [[BNRImageStore sharedInstance] deleteImageForKey:self.item.itemKey];
                                                              self.item.thumbnail = nil;
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
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = pickedImage;
    self.trashButton.enabled = YES;
    // 利用选择的图片生成缩略图
    [self.item setThumbnailFromImage:pickedImage];
    
    [[BNRImageStore sharedInstance] setImage:pickedImage forKey:self.item.itemKey];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
