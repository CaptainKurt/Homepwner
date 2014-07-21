//
//  BNRDateChangerViewController.m
//  Homepwner
//
//  Created by Kurt Walker on 7/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDateChangerViewController.h"
#import "BNRItem.h"

@interface BNRDateChangerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRDateChangerViewController


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.dateCreated = self.datePicker.date;
    
}

-(void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = @"Date";
}
@end
