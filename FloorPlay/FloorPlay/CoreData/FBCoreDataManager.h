//
//  FBCoreDataManager.h
//  FloorPlay
//
//  Created by Vikas Kumar on 18/03/15.
//  Copyright (c) 2015 Vikas Kumar. All rights reserved.
//

@import Foundation;
@import CoreData;

#import "ImageData.h"
#import "FPImageData.h"

@interface FBCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(instancetype)sharedDataManager;

- (BOOL)saveImageData:(ImageData *)imageData;
- (NSArray *)getAllOfflineImages;


@end
