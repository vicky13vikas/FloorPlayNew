//
//  FBCoreDataManager.m
//  FloorPlay
//
//  Created by Vikas Kumar on 18/03/15.
//  Copyright (c) 2015 Vikas Kumar. All rights reserved.
//

#import "FBCoreDataManager.h"
#import <AsyncImageView/AsyncImageView.h>
#import <AFHTTPRequestOperation.h>

@implementation FBCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize saveCompletion = _saveCompletion;

+(instancetype)sharedDataManager
{
    static FBCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FBCoreDataManager alloc] init];
    });
    return sharedInstance;
}

/// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBImageData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBImageData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSArray *)getAllOfflineImages
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FPImageData"];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"serailNumber" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSArray *images = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSMutableArray *imageDataList = [[NSMutableArray alloc] init];
    for(FPImageData *imageData in images)
    {
        [imageDataList addObject:[imageData getImageData]];
    }
    return imageDataList;
}

-(NSUInteger)getCountOfOfflineImage
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FPImageData"];
   
    NSError *err;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];

    return count;
}

- (void)saveImageData:(ImageData *)imageData withCompletionHandler:(SaveCompletion)completion;
{
    _saveCompletion = completion;
    BOOL status = NO;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    FPImageData *image = (FPImageData*)[NSEntityDescription insertNewObjectForEntityForName:@"FPImageData" inManagedObjectContext:context];
    NSError *error = nil;
    
    [image setDataFromImageData:imageData];
    image.serailNumber = [NSNumber numberWithUnsignedInteger:[self getCountOfOfflineImage]];
    
    // Save the object to persistent store
    if (YES == [context save:&error])
    {
        status = YES;
        [self saveImageToDocuments:imageData];
    }
    else
    {
        _saveCompletion(NO);
    }
    
}

-(void)saveImageToDocuments:(ImageData*)imagedata
{
    NSString *dataPath = [imagedata pathToSaveOffline];
    if(!dataPath)
    {
        _saveCompletion(NO);
    }
    
    NSMutableArray *requestArray = [[NSMutableArray alloc] init];
    
    for(NSURL *imageURL in imagedata.imageURLs)
    {
        NSURL *url = imageURL;
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
        op.responseSerializer = [AFImageResponseSerializer serializer];
        
        NSString* constPath = [dataPath stringByAppendingPathComponent:[imageURL lastPathComponent]];
        
        op.outputStream = [NSOutputStream outputStreamToFileAtPath:constPath append:NO];
        op.queuePriority = NSOperationQueuePriorityLow;
        
        [op setDownloadProgressBlock:^(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
            
        }];
        
        op.completionBlock = ^{
            
            //do whatever you want with the downloaded photo, it is stored in the path you create in constPath
        };
        [requestArray addObject:op];
    }
    
    NSArray *batches = [AFURLConnectionOperation batchOfRequestOperations:requestArray
                                                            progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                                                
                                                                
    } completionBlock:^(NSArray *operations) {
        _saveCompletion(YES);
    }];
    
    [[NSOperationQueue mainQueue] addOperations:batches waitUntilFinished:NO];
}

- (void)swapImageAtIndex:(NSUInteger)source withImageAtIndex:(NSUInteger)dest
{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"FPImageData"];
    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"serailNumber == %@ OR serailNumber == %@",
                            [NSNumber numberWithUnsignedInteger:source],
                            [NSNumber numberWithUnsignedInteger:dest]];
    
    fetchRequest.predicate=predicate;
    NSArray *list = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    FPImageData *firstImage = [list firstObject];
    FPImageData *secondImage = [list lastObject];
    
    NSNumber *temp = firstImage.serailNumber;
    firstImage.serailNumber = secondImage.serailNumber;
    secondImage.serailNumber = temp;
    
    [self.managedObjectContext save:nil];
}

@end
