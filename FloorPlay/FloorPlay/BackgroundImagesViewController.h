//
//  BackgroundImagesViewController.h
//  FloorPlay
//
//  Created by Vikas Kumar on 05/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackgroundImagesDelegate <NSObject>
    -(void) backgroungImageDidChange :(UIImage*)image;

@end

@interface BackgroundImagesViewController : UICollectionViewController

@property(weak, nonatomic) id <BackgroundImagesDelegate> delegate;

@end
