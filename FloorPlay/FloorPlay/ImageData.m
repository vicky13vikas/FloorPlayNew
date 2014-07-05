//
//  ImageData.m
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

-(id)initWithID:(NSString*)identifier name:(NSString*)name description:(NSString*)desc size:(NSString*)size color:(NSString*)color pattern:(NSString*)pattern material:(NSString*)material price:(NSString*)price createdDate:(NSDate*)date imagesList:(NSArray*)images;
{
    self = [super init];
    if(self)
    {
        _identfier = identifier;
        _name = name;
        _description = desc;
        _size = size;
        _color = color;
        _pattern = pattern;
        _material = material;
        _price = price;
        _createddate = date;
        _imagesList = [images copy];
    }
    return self;
}

-(UIImage*)getImageFromImageName:(NSString*)imageName
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"Images/"];
    NSString *filePath = [dirPath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
