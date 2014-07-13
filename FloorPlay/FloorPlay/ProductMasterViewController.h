//
//  ProductMasterViewController.h
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPProduct.h"

@class ProductMasterViewController;

@protocol ProductMasterDelegate <NSObject>
@optional
-(void)productMasterController:(ProductMasterViewController*) controller didSelectProduct:(FPProduct*)productID;

@end

@interface ProductMasterViewController : UITableViewController

@property(strong, nonatomic) id <ProductMasterDelegate> productMasterDelegate;

@end
