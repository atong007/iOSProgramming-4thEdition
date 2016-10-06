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

@end
@implementation BNRItemCell

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.image.image = self.item.thumbnail;
    self.nameLabel.text = self.item.itemName;
    self.serialNameLabel.text = self.item.serialNumber;
    self.valueLabel.text = [NSString stringWithFormat:@"$%lu", self.item.valueInDollars];
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
@end
