//
//  SelectedCategoryViewController.h
//  FloorPlay
//
//  Created by Vikas kumar on 14/12/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol selectCategoryDelegate <NSObject>

-(void)selectionDoneInCategory:(CategoryType)category withString:(NSString*)selectedString;

@end

@interface SelectedCategoryViewController : UITableViewController

@property (nonatomic, assign) CategoryType categoryType;
@property(nonatomic, assign) id<selectCategoryDelegate> materTableDelegate;
@property(nonatomic, assign) id<selectCategoryDelegate> detailControllerDelegate;

@end
