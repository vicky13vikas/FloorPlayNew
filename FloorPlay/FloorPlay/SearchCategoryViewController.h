//
//  SearchCategoryViewController.h
//  FloorPlay
//
//  Created by Vikas kumar on 06/12/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@interface SearchCategoryViewController : UITableViewController

@property(nonatomic, assign) MasterViewController *masterTableViewController;
@property(nonatomic, assign) DetailViewController *detailViewController;


@end
