//
//  BNRPaletteViewController.m
//  Colorboard
//
//  Created by 洪龙通 on 2016/10/6.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRPaletteViewController.h"
#import "BNRColorDescription.h"
#import "BNRColorViewController.h"

@interface BNRPaletteViewController ()
@property (nonatomic, strong) NSMutableArray *colors;
@end

@implementation BNRPaletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (NSMutableArray *)colors
{
    if (!_colors) {
        _colors = [NSMutableArray array];
        BNRColorDescription *cd = [[BNRColorDescription alloc] init];
        [_colors addObject:cd];
    }
    return _colors;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"]) {
        
        BNRColorDescription *color = [[BNRColorDescription alloc] init];
        [self.colors addObject:color];
        
        UINavigationController *navi = (UINavigationController *)segue.destinationViewController;
        BNRColorViewController *colorVC = (BNRColorViewController *)navi.topViewController;
        
        colorVC.colorDescription = color;
    }else if([segue.identifier isEqualToString:@"ExistingColor"]) {
        
        BNRColorViewController *colorVC = (BNRColorViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        colorVC.colorDescription = self.colors[indexPath.row];
        colorVC.existingColor = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colors.count;
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *reuseID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    //2.传递数据模型来设置cell属性
    BNRColorDescription *cd = self.colors[indexPath.row];
    cell.textLabel.text = cd.name;
    
    //3.返回cell
    return cell;
}

@end
