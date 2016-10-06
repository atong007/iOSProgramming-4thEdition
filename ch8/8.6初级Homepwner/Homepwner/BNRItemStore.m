//
//  BNRItemStore.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore()

@property (nonatomic, strong) NSMutableArray *privateItems;
@end
@implementation BNRItemStore

+ (instancetype)sharedInstance {
    static BNRItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)initPrivate
{
    return [super init];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemSore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (NSMutableArray *)privateItems
{
    if (!_privateItems) {
        _privateItems = [NSMutableArray array];
    }
    return _privateItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randonItem];
    [self.privateItems addObject:item];
    return item;
}

- (NSArray *)allItems
{
    return [self.privateItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BNRItem *firstItem = (BNRItem *)obj1;
        BNRItem *secondItem = (BNRItem *)obj2;
        NSComparisonResult result = firstItem.valueInDollars < secondItem.valueInDollars;
        return result;
    }];
}

@end
