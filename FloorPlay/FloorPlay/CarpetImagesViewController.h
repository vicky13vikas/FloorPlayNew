//
//  CarpetImagesViewController.h
//  FloorPlay
//
//  Created by Vikas Kumar on 05/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CarpetImagesDelegate <NSObject>
-(void) carpetImageDidChange :(UIImage*)image;

@end

@interface CarpetImagesViewController : UICollectionViewController

@property(weak, nonatomic) id <CarpetImagesDelegate> delegate;

@end
