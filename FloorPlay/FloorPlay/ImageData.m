//
//  ImageData.m
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

-(id)initWithID:(NSString*)identifier name:(NSString*)name description:(NSString*)desc size:(NSString*)size color:(NSString*)color pattern:(NSString*)pattern material:(NSString*)material price:(NSString*)price createdDate:(NSDate*)date imagesURLs:(NSArray *)images
{
    self = [super init];
    if(self)
    {
        _identfier = identifier;
        _name = name;
        _imageDescription = desc;
        _size = size;
        _color = color;
        _pattern = pattern;
        _material = material;
        _price = price;
        _createddate = date;
        _imageURLs = [images copy];
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

-(NSString*)pathToSaveOffline
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString *dataPath = (NSMutableString *)[documentsDirectory stringByAppendingPathComponent:self.identfier];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
        {
            return nil;
        }
        else
        {
            return dataPath;
        }
    }
    else
        return dataPath;
    return nil;
}

@end
