//
//  BNRItem.m
//  RandomItems
//
//  Created by 洪龙通 on 2016/9/27.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

+ (instancetype)randonItem {
	
    NSArray *randomAbjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    NSInteger abjectiveIndex = arc4random() % [randomAbjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];

    NSString *randomItemName = [NSString stringWithFormat:@"%@ %@", randomAbjectiveList[abjectiveIndex], randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    return [[self alloc] initWithItemName:randomItemName valueInDollars:randomValue serialNumber:randomSerialNumber];
}

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    if (self = [super init]) {
        _itemName = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        _dateCreated = [NSDate date];

    }
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

- (instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@): Worth $%i, recodered on %@",
            self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
}
@end
