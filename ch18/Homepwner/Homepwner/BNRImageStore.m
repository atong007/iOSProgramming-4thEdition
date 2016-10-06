//
//  BNRImageStore.m
//  Homepwner
//
//  Created by 洪龙通 on 2016/9/30.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore()

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end
@implementation BNRImageStore


+ (instancetype)sharedInstance {
	
    static BNRImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _dictionary = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRImageStore sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (void)clearCache
{
    NSLog(@"flushing %d images out of the cache.", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    [imageData writeToFile:[self imagePathForKey:key] atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    // 尝试通过字典对象获取图片
    UIImage *image = self.dictionary[key];
    
    // 如果字典里面没有保存
    if (!image) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // 通过文件创建UIImage对象
        image = [UIImage imageWithContentsOfFile:imagePath];
        
        // 如果能够通过文件创建图片，就将其放入缓存
        if (image) {
            self.dictionary[key] = image;
        }else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return image;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self imagePathForKey:key] error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:key];
}
@end
