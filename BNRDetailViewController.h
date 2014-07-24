//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Kurt Walker on 7/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (strong, nonatomic) BNRItem *item;

@end
