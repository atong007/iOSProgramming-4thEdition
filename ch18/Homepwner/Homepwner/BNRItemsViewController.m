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
#import "BNRDetailViewController.h"


@interface BNRItemsViewController ()

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
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    self.navigationItem.title = @"Homepwner";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (NSArray *)items
{
    if (!_items) {
        _items = [BNRItemStore sharedInstance].allItems;
    }
    return _items;
}

- (void)addNewItem:(id)sender {
    
    BNRItem *item = [[BNRItemStore sharedInstance] createItem];
    
    BNRDetailViewController *detailVC = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailVC.item = item;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
    navi.modalPresentationStyle = UIModalPresentationFormSheet;
    __weak typeof(self) weakSelf = self;
    detailVC.dismissBlock = ^{
        [weakSelf.tableView reloadData];
    };
    [self presentViewController:navi animated:YES completion:nil];
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
        cell.textLabel.text = @"                    No More Item!";
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

/**
 *  编辑删除时显示的按钮标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

/**
 *  cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    BNRDetailViewController *detailVC = [[BNRDetailViewController alloc] initForNewItem:NO];
    detailVC.item = self.items[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
