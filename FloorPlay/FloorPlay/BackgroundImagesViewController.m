//
//  BackgroundImagesViewController.m
//  FloorPlay
//
//  Created by Vikas Kumar on 05/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "BackgroundImagesViewController.h"

@interface BackgroundImagesViewController ()
{
    NSMutableArray *bgImages;
}

@end

@implementation BackgroundImagesViewController

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
    bgImages = [[NSMutableArray alloc] init];
    [self loadSavedBGImages];
}

-(void)loadSavedBGImages
{
    bgImages = [[NSMutableArray alloc] init];
    
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"BGImages/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:dirPath])
    {
        NSLog(@"%@: does not exists...will attempt to create", dirPath);
    }
    else
    {
        NSArray *fileList = [fileManager subpathsAtPath:dirPath];
        for (NSString *filename in fileList) {
            NSString *filePath = [dirPath stringByAppendingString:@"/"];
            filePath = [filePath stringByAppendingString:filename];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            if(image)
                [bgImages addObject:image];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return bgImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"collectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:555];
    imageView.image = bgImages[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
    UIImage *selectedImage = [(UIImageView*)[cell viewWithTag:555] image];
    
    [_delegate backgroungImageDidChange:selectedImage];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
