//
//  MainTableViewCell.m
//  FloorPlay
//
//  Created by Vikas kumar on 29/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "MainTableViewCell.h"
#import "ImagesDataSource.h"

@implementation MainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
 //   [_imagePreview setShowActivityIndicator:YES];
  //  [_imagePreview setCrossfadeDuration:0];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.imagePreview.image = nil;
}

@end
