//
//  BNRItem.h
//  RandomItems
//
//  Created by Kurt Walker on 6/25/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding>

    @property (nonatomic, copy) NSString *itemName;
    @property (nonatomic, copy) NSString *serialNumber;
    @property (nonatomic) int valueInDollars;
    @property (nonatomic, strong) NSDate *dateCreated;

@property (nonatomic,copy) NSString *itemKey;
@property (strong, nonatomic) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;


+ (instancetype)randomItem;


// Designated initializer for BNRItem
-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;

- (void)changeDate:(NSDate *)dateCreated;

@end
