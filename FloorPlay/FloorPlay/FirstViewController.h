//
//  FirstViewController.h
//  FloorPlay
//
//  Created by Vikas kumar on 16/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class MasterViewController;

@interface FirstViewController : UIViewController

@property (strong, nonatomic) NSString *dataFrom; //This will be inventory or custom depending upon the first selection

@property (strong, nonatomic) MasterViewController *master;

@end
