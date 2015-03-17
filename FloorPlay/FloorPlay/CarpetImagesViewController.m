//
//  CarpetImagesViewController.m
//  FloorPlay
//
//  Created by Vikas Kumar on 05/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "CarpetImagesViewController.h"
#import "ImagesDataSource.h"
#import "ImageData.h"
#import <AsyncImageView/AsyncImageView.h>

@interface CarpetImagesViewController ()
{
    NSMutableArray *carpetImageURLs;
}

@end

@implementation CarpetImagesViewController

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

    carpetImageURLs = [[NSMutableArray alloc] init];
    [self loadSavedCarpetImages];
}

-(void)loadSavedCarpetImages
{
    NSArray *array = [[ImagesDataSource singleton] objects];
    for(ImageData *imagedata in  array)
    {
        NSURL *imageURL = [NSURL URLWithString:[[imagedata.imagesList firstObject] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(imageURL)
            [carpetImageURLs addObject:imageURL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return carpetImageURLs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"collectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor whiteColor];
    AsyncImageView *imageView = (AsyncImageView*)[cell viewWithTag:555];
    imageView.imageURL = carpetImageURLs[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor blueColor];
    UIImage *selectedImage = [(AsyncImageView*)[cell viewWithTag:555] image];
    
    [_delegate carpetImageDidChange:selectedImage];
}

@end
