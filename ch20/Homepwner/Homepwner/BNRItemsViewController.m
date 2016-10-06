//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageViewController.h"

#define kReuseID @"BNRItemCell"

@interface BNRItemsViewController ()

@property (nonatomic, copy) NSArray *items;
@end

@implementation BNRItemsViewController

/**
 *  UITableViewController的指定初始化方法
 */
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    self.navigationItem.title = @"Homepwner";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    // UITableView对象中注册了包含BNRItemCell.xib的UINib对象之后，UITableView对象
    // 就可以通过“BNRItemCell”键找到并加载BNRItemCell对象
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:kReuseID];
//    
//    for (int i= 0; i < 10; i++) {
//        [[BNRItemStore sharedInstance] createItem];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self updateTableViewForDynamicTypeSize];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    }else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
                                 UIContentSizeCategoryAccessibilityMedium : @44,
                                 UIContentSizeCategoryExtraSmall : @44,
                                 UIContentSizeCategorySmall : @44,
                                 UIContentSizeCategoryMedium : @44,
                                 UIContentSizeCategoryLarge : @44,
                                 UIContentSizeCategoryExtraLarge : @55,
                                 UIContentSizeCategoryExtraExtraLarge : @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge : @75,
                                 UIContentSizeCategoryAccessibilityLarge : @44,
                                 UIContentSizeCategoryAccessibilityExtraLarge : @55,
                                 UIContentSizeCategoryAccessibilityExtraExtraLarge : @65,
                                 UIContentSizeCategoryAccessibilityExtraExtraExtraLarge : @75
                                 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSLog(@"userSize:%@", userSize);
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    self.tableView.rowHeight = [cellHeight floatValue];
    [self.tableView reloadData];
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
    return self.items.count;
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseID];
    
    //2.传递数据模型来设置cell属性
    BNRItem *item = self.items[indexPath.row];
    cell.item = item;
    __weak typeof(self) weakSelf = self;
    cell.actionBlock = ^{
        BNRImageViewController *imageVC = [[BNRImageViewController alloc] init];
        imageVC.image = [[BNRImageStore sharedInstance] imageForKey:item.itemKey];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:imageVC];
        navi.modalPresentationStyle = UIModalPresentationFormSheet;
        navi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:navi animated:YES completion:nil];
    };
    
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
