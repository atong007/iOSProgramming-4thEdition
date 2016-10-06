//
//  BNRItemCell.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/10/4.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItemCell.h"
#import "BNRItem.h"

@interface BNRItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end
@implementation BNRItemCell

- (void)awakeFromNib
{
    [self updateInterfaceDynamicTypeSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterfaceDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.image
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.image
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:1.0 constant:0];
    [self.image addConstraint:constraint];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.image.image = self.item.thumbnail;
    self.nameLabel.text = self.item.itemName;
    self.serialNameLabel.text = self.item.serialNumber;
    static NSNumberFormatter *currencyFormatter = nil;
    if (!currencyFormatter) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    self.valueLabel.text = [currencyFormatter stringFromNumber:@(self.item.valueInDollars)];
    if (self.item.valueInDollars >= 50) {
        self.valueLabel.textColor = [UIColor greenColor];
    }else {
        self.valueLabel.textColor = [UIColor redColor];
    }
    
}

- (IBAction)showImage:(id)sender {
    
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}

- (void)updateInterfaceDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNameLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{
                                 UIContentSizeCategoryAccessibilityMedium : @40,
                                 UIContentSizeCategoryExtraSmall : @40,
                                 UIContentSizeCategorySmall : @40,
                                 UIContentSizeCategoryMedium : @40,
                                 UIContentSizeCategoryLarge : @40,
                                 UIContentSizeCategoryAccessibilityLarge : @40,
                                 UIContentSizeCategoryAccessibilityExtraLarge : @45,
                                 UIContentSizeCategoryAccessibilityExtraExtraLarge : @55,
                                 UIContentSizeCategoryAccessibilityExtraExtraExtraLarge : @65
                                 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
}
@end
