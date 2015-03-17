//
//  FPImageData.m
//  FloorPlay
//
//  Created by Vikas Kumar on 18/03/15.
//  Copyright (c) 2015 Vikas Kumar. All rights reserved.
//

#import "FPImageData.h"
#import <objc/runtime.h>


@implementation FPImageData

@dynamic identfier;
@dynamic name;
@dynamic imageDescription;
@dynamic size;
@dynamic color;
@dynamic pattern;
@dynamic price;
@dynamic material;
@dynamic createddate;
@dynamic imageURL1;
@dynamic imageURL2;
@dynamic imageURL4;
@dynamic imageURL3;

- (void)setDataFromImageData:(ImageData*)data
{
    self.identfier = data.identfier;
    self.name = data.name;
    self.imageDescription = data.imageDescription;
    self.size = data.size;
    self.color = data.color;
    self.pattern = data.pattern;
    self.price = data.price;
    self.material = data.material;
    self.createddate = data.createddate;
    for (int i = 0; i<data.imagesList.count ; i++)
    {
        NSString *imageURL = [data.imagesList objectAtIndex:i];
        NSString *propertyName = [NSString stringWithFormat:@"imageURL%d",i+1];
        objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
        if(property)
        {
            [self setValue:imageURL forKey:propertyName];
        }
    }
  
}

@end
