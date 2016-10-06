//
//  BNRItemStore.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()
@property (nonatomic, strong) NSMutableArray *privateItems;
@end
@implementation BNRItemStore
// 默认带extern声明，可以在其他文件中用extern来访问
NSString *name = @"hello";
// ****************************************** //

+ (instancetype)sharedInstance {
    static BNRItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

/**
 *  方便启动时载入所有item对象，所以需要在此方法获取数据
 *
 */
- (instancetype)initPrivate
{
    if (self = [super init]) {
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemArchivePath]];
        
        if (!_privateItems) {
            _privateItems = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemSore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (BNRItem *)createItem
{
    BNRItem *item = [[BNRItem alloc] init];
//    BNRItem *item = [BNRItem randonItem];
    [self.privateItems addObject:item];
    return item;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (void)removeItem:(BNRItem *)item {
	// 根据item地址的值来进行匹配查找
    [[BNRImageStore sharedInstance] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:fromIndex];
}

- (NSString *)itemArchivePath {
	
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges {
    NSString *filePath = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:filePath];
}

@end
