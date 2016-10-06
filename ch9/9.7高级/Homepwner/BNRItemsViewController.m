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

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, copy) NSArray *items;
@end

@implementation BNRItemsViewController

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
            [[BNRItemStore sharedInstance] createItem];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
}

- (NSArray *)items
{
    if (!_items) {
        _items = [BNRItemStore sharedInstance].allItems;
    }
    return _items;
}

- (UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

- (IBAction)addNewItem:(id)sender {
    
    BNRItem *item = [[BNRItemStore sharedInstance] createItem];
    NSInteger lastRow = [[[BNRItemStore sharedInstance] allItems] indexOfObject:item];
    NSIndexPath *lastItemIndex = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[lastItemIndex] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)toggleEdittingMode:(UIButton *)sender {
    
    if (self.tableView.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
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
    if (indexPath.row == self.items.count) {
        cell.textLabel.text = @"                No More Item!";
    }else {
        BNRItem *item = self.items[indexPath.row];
        cell.textLabel.text = [item description];
    }
    
    //3.返回cell
    return cell;
}

#pragma mark - table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        return NO;
    }
    return YES;
}

/**
 *  移动行
 *
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (destinationIndexPath.row == self.items.count) {
        [tableView reloadData];
        return;
    }
    [[BNRItemStore sharedInstance] moveItemFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

/**
 *  删除行
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [tableView cellForRowAtIndexPath:indexPath].contentView.subviews);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItem *item = self.items[indexPath.row];
        [[BNRItemStore sharedInstance] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}
@end
