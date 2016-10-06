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
@import CoreData;

@interface BNRItemStore()
@property (nonatomic, strong) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
        // 读取Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // 设置SQLite文件路径
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // 创建NSManagedObjectContext对象
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
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
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    }else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %ld items, order = %.2f",[self.privateItems count], order);
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
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
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:fromIndex];
    
    // 为移动的BNRItem对象计算新的orderingValue
    double lowerBound = 0.0;
    
    // 在数组中，该对象之前是否有其他对象？
    if (toIndex > 0) {
        // 前一个对象的orderingValue
        lowerBound = [self.privateItems[toIndex -1] orderingValue];
    }else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // 在数组中，该对象之后是否有其他对象？
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[toIndex + 1] orderingValue];
    }else {
        upperBound = [self.privateItems[toIndex - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath {
	
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges {
    NSError *error = nil;
    BOOL success = [self.context save:&error];
    if (!success) {
        NSLog(@"Error saving:%@", [error localizedDescription]);
    }
    return success;
}

/**
 *  获取所有items
 */
- (void)loadAllItems
{
    if (!self.privateItems) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *description = [NSEntityDescription entityForName:@"BNRItem"
                                                       inManagedObjectContext:self.context];
        request.entity = description;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason:%@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes {
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BNRAssetType"
                                                  inManagedObjectContext:self.context];
        request.entity = entity;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    // 第一次运行？
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furnture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    return _allAssetTypes;
}

- (void)addNewAssetTypeWithName:(NSString *)name
{
    NSManagedObject *type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                                          inManagedObjectContext:self.context];
    [type setValue:name forKey:@"label"];
    [_allAssetTypes addObject:type];
}
@end
