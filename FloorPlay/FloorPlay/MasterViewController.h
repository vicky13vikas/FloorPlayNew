//
//  MasterViewController.h
//  FloorPlay
//
//  Created by Vikas kumar on 12/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SelectedCategoryViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <selectCategoryDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic) BOOL isCustom;


@end
