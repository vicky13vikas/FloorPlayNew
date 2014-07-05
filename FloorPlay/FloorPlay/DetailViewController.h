//
//  DetailViewController.h
//  FloorPlay
//
//  Created by Vikas kumar on 12/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "ImageData.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) ImageData *image;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) FirstViewController *firstViewController; //This will be inventory or custom depending upon the first selection


-(void)updateImage;
@end
