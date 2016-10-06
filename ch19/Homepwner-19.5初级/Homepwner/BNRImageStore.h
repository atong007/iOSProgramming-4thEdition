//
//  BNRImageStore.h
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/30.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

+ (instancetype)sharedInstance;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;
@end
