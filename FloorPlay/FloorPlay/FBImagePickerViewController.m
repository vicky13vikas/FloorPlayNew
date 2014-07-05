//
//  FBImagePickerViewController.m
//  FloorPlay
//
//  Created by Vikas Kumar on 05/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "FBImagePickerViewController.h"

@interface FBImagePickerViewController ()

@end

@implementation FBImagePickerViewController

#pragma mark - Interface orientation controlling methods

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    if (isIpad())
    {
        interfaceOrientationMask = UIInterfaceOrientationMaskAll;
    }
    
    return interfaceOrientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation prefferedOrientation = UIInterfaceOrientationPortrait;
    
    if (isIpad())
    {
        prefferedOrientation = [self interfaceOrientation];
    }
    
    return prefferedOrientation;
}

#pragma mark - View controller delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
