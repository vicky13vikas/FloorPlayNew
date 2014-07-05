//
//  MainTableViewCell.h
//  FloorPlay
//
//  Created by Vikas kumar on 29/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageData.h"

@interface MainTableViewCell : UITableViewCell

@property (nonatomic,retain) ImageData* image;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;

@end
