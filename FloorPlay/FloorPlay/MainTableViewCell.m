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
    _imagePreview.image = [[ImagesDataSource singleton] getImageAtIndex:0 forImage:self.image];
    if (_image.name) {
        _lblName.text = _image.name;
    }
    
    if ([_image.description isKindOfClass:[NSString class]]) {
        _lblDesc.text = _image.description;
    }
}

@end
