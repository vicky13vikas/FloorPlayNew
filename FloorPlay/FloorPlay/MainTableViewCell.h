//
//  MainTableViewCell.h
//  FloorPlay
//
//  Created by Vikas kumar on 29/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageData.h"
#import <AsyncImageView/AsyncImageView.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet AsyncImageView *imagePreview;

@end
