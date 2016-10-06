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
}

- (NSArray *)items
{
    if (!_items) {
        _items = [BNRItemStore sharedInstance].allItems;
        NSLog(@"%@", _items);
    }
    return _items;
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return firstSectionCount;
    }else {
        return self.items.count - firstSectionCount;
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
    BNRItem *item = self.items[firstSectionCount * indexPath.section + indexPath.row];
    cell.textLabel.text = [item description];
    
    //3.返回cell
    return cell;
}

@end
