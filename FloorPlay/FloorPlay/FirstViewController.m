//
//  FirstViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 16/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "FirstViewController.h"
#import "Constants.h"
//#import "AFHTTPClient.h"
#import "UIViewControllerCategories.h"
#import "AFHTTPRequestOperation.h"
#import "ImagesDataParser.h"
#import "ImagesDataSource.h"
#import "FPAFNetworking.h"

@interface FirstViewController ()

@property (nonatomic) NSInteger imageDownloadCount;

@property (nonatomic, retain) NSMutableArray *imagesList;
@property (nonatomic, retain) NSMutableArray *bgImagesList;

- (IBAction)dateSourceSelected:(id)sender;
- (IBAction)updateTapped:(id)sender;

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _imageDownloadCount = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![[[FloorPlayServices singleton] preferences] objectForKey:IS_FIRST_TIME_LAUNCH])
    {
        [self downloadImagesListFirstTime];
        [self downloadBackgroundImages];
    }
    else
    {
        [self loadDataFromSavedJson];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateSourceSelected:(id)sender
{
    _dataFrom = [sender restorationIdentifier];
    
    if([_dataFrom isEqualToString:@"Custom"])
    {
        self.master.isCustom = YES;
    }
    else
        self.master.isCustom = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)updateTapped:(id)sender
{
    [self downloadImagesListFirstTime];
    [self downloadBackgroundImages];
}



-(void)downloadImagesListFirstTime
{
    NSString *url = [NSString stringWithFormat:@"api/getImage.php"];
    
    FPAFNetworking * client = [FPAFNetworking client];    
    [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [self saveJsonData:responseObject];
        [self loadDataFromSavedJson];
        [self downloadInventoryImages];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [self showAlertWithMessage:[error localizedDescription] andTitle:@"Error"];
        [self hideLoadingScreen];

    }];
    
    [self showLoadingScreenWithMessage:@"Downloading..."];
}


-(void)downloadBackgroundImages
{
    NSString *url = [NSString stringWithFormat:@"api/getBackgroundImage.php"];
    
    FPAFNetworking * client = [FPAFNetworking client];
    [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [self saveBackgroundJsonData:responseObject];
         [self loadDataFromSavedJsonBGList];
         [self downloadAllImagesBG];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self showAlertWithMessage:[error localizedDescription] andTitle:@"Error"];
         [self hideLoadingScreen];
     }];
    
    [self showLoadingScreenWithMessage:@"Downloading..."];

    
}

-(void)saveJsonData:(NSData*)data
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_JSON_FILE];
    
    [data writeToFile:documentDirPath atomically:YES];
    
    [[[FloorPlayServices singleton] preferences] setObject:@"YES" forKey:IS_FIRST_TIME_LAUNCH];
}

-(void)saveBackgroundJsonData:(NSData*)data
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_BG_IMAGES_JSON_FILE];
    
    [data writeToFile:documentDirPath atomically:YES];
}

-(void)loadDataFromSavedJson
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_JSON_FILE];
    
    NSData *data = [NSData dataWithContentsOfFile:documentDirPath];
    if (data)
        self.imagesList = [[NSMutableArray alloc] initWithArray:[ImagesDataParser parseImagesFromData:data andCacheDataSource:YES]];
}

-(void)loadDataFromSavedJsonBGList
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_BG_IMAGES_JSON_FILE];
    
    NSData *data = [NSData dataWithContentsOfFile:documentDirPath];
    if (data)
    {
        self.bgImagesList = [NSMutableArray arrayWithContentsOfFile:documentDirPath];
    }
}


-(void)downloadInventoryImages
{
    for (ImageData *image in self.imagesList)
    {
        for (NSString *imageName in image.imagesList)
        {
            if(imageName.length > 0)
            {
                [self downloadImageNamed:imageName];
            }
        }
    }
}

-(void)downloadDone
{
    _imageDownloadCount--;
    if(_imageDownloadCount <= 0)
    {
        [self hideLoadingScreen];
    }
}

-(void)downloadFailed
{
    _imageDownloadCount--;
    if(_imageDownloadCount <= 0)
    {
        [self hideLoadingScreen];
    }
}

-(void)downloadImageNamed:(NSString*)imageName
{
        NSString *url = [[NSString stringWithFormat:@"data/images/%@", imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        FPAFNetworking *client = [FPAFNetworking imageDownloadClient];
    
        _imageDownloadCount++;
        [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
        {
            [self downloadDone];
            [self saveImage:responseObject forURL:task.response.URL];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self downloadFailed];
            NSLog(@"%@", error);
        }];
        
        [self showLoadingScreenWithMessage:@"Downloading Images..."];
}

- (void)saveImage:(UIImage*)image forURL:(NSURL*)url
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"Images/"];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath])
    {
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"errormsg:%@", [error description]);
    }
    
    
    NSString *filePath = [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

- (void)saveBGImage:(UIImage*)image forURL:(NSURL*)url
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"BackgroundImages/"];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath])
    {
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"errormsg:%@", [error description]);
    }
    
    
    NSString *filePath = [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

-(void)downloadAllImagesBG
{
    for (int i = 0; i < _bgImagesList.count; i++)
    {
        NSString *urlPath = _bgImagesList[i];
        _imageDownloadCount++;
        
        FPAFNetworking *client = [FPAFNetworking imageDownloadClient];
        
        [client GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [self downloadDone];
             [self saveBGImage:responseObject forURL:task.response.URL];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@", error);
             [self downloadFailed];
         }];
        
        [self showLoadingScreenWithMessage:@"Downloading Images..."];
    }

}

#pragma -mark Orientaion

-(BOOL)shouldAutorotate{
    return  YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskLandscape;
}


@end
