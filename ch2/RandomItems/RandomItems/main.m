//
//  main.m
//  RandomItems
//
//  Created by 洪龙通 on 2016/9/27.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray *items = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            BNRItem *item = [BNRItem randonItem];
            [items addObject:item];
        }
        
        BNRContainer *container = [BNRContainer randonItem];
        container.subitems = items;
        NSLog(@"%@", container);
    }
    return 0;
}
