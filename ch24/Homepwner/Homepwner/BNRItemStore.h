//
//  BNRItemStore.h
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/29.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem, NSManagedObject;
@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedInstance;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (BOOL)saveChanges;

- (NSArray *)allAssetTypes;
- (void)addNewAssetTypeWithName:(NSString *)name;
- (NSArray *)getAllItemsWithSameAssetType:(NSManagedObject *)type;

@end
