//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"


@interface BNRItemsViewController ()

@property (nonatomic, copy) NSArray *items;
@end

@implementation BNRItemsViewController
{
    NSUInteger firstSectionCount;
}

/**
 *  UITableViewController的指定初始化方法
 */
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)init
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 10; i++) {
            BNRItem *item = [[BNRItemStore sharedInstance] createItem];
            if (item.valueInDollars > 50) {
                firstSectionCount++;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
}

- (NSArray *)items
{
    if (!_items) {
        _items = [BNRItemStore sharedInstance].allItems;
    }
    return _items;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (firstSectionCount == 0 || self.items.count - firstSectionCount == 0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] == 1) {
        return self.items.count + 1;
    }
    if (section == 0) {
        return firstSectionCount;
    }else {
        return self.items.count - firstSectionCount + 1;
    }
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *reuseID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    //2.传递数据模型来设置cell属性
    NSUInteger index = firstSectionCount * indexPath.section + indexPath.row;
    if (index == self.items.count) {
        cell.textLabel.text = @"No more items";
    }else{
        BNRItem *item = self.items[index];
        cell.textLabel.text = [item description];
    }
    
    //3.返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = firstSectionCount * indexPath.section + indexPath.row;
    if (index == self.items.count) {
        return 44;
    }
    return 60;
}

@end
