//
//  ImageData.h
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject

@property (nonatomic, retain) NSString* identfier;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* size;
@property (nonatomic, retain) NSString* color;
@property (nonatomic, retain) NSString* pattern;
@property (nonatomic, retain) NSString* price;
@property (nonatomic, retain) NSString* material;
@property (nonatomic, retain) NSDate* createddate;

@property (nonatomic, retain) NSArray *imagesList;



-(id)initWithID:(NSString*)identifier name:(NSString*)name description:(NSString*)desc size:(NSString*)size color:(NSString*)color pattern:(NSString*)pattern material:(NSString*)material price:(NSString*)price createdDate:(NSDate*)date imagesList:(NSArray*)images;

@end
