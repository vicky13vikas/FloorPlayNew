//
//  AGQuadControlViewController.m
//  FloorPlay
//
//  Created by Vikas Kumar on 23/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "AGQuadControlViewController.h"
#import <AGGeometryKit/AGGeometryKit.h>
#import "BackgroundImagesViewController.h"
#import "CarpetImagesViewController.h"

@interface AGQuadControlViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BackgroundImagesDelegate, CarpetImagesDelegate>
{
    BOOL isContolsHidden;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *topLeftControl;
@property (nonatomic, strong) IBOutlet UIView *topRightControl;
@property (nonatomic, strong) IBOutlet UIView *bottomLeftControl;
@property (nonatomic, strong) IBOutlet UIView *bottomRightControl;
@property (nonatomic, strong) IBOutlet UIView *maskView;
@property (nonatomic, strong) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (strong, nonatomic) UIImagePickerController *cameraPicker;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIPopoverController  *popOver;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeCarpet;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeBG;


@end

@implementation AGQuadControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isContolsHidden = NO;
    //    [self createAndApplyQuad];

}

- (void)createAndApplyQuad
{
    AGKQuad quad = AGKQuadMake(self.topLeftControl.center,
                                         self.topRightControl.center,
                                         self.bottomRightControl.center,
                                         self.bottomLeftControl.center);
    
    if(AGKQuadIsValid(quad))
    {
        self.imageView.layer.quadrilateral = quad;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = _image;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(loadFreezedImage) withObject:nil afterDelay:0.2];
}

- (IBAction)panGestureChanged:(UIPanGestureRecognizer *)recognizer
{
    UIImageView *view = (UIImageView *)[recognizer view];
    
    CGPoint translation = [recognizer translationInView:self.view];
    view.centerX += translation.x;
    view.centerY += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    view.highlighted = recognizer.state == UIGestureRecognizerStateChanged;
    
    [self createAndApplyQuad];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)doneTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)freezeTapped:(id)sender
{
    NSMutableDictionary *dicToSave = [[NSMutableDictionary alloc] init];
    
    [dicToSave setObject:CFBridgingRelease(CGRectCreateDictionaryRepresentation(self.topLeftControl.frame)) forKey:@"topLeftControl"];
    [dicToSave setObject:CFBridgingRelease(CGRectCreateDictionaryRepresentation(self.topRightControl.frame)) forKey:@"topRightControl"];
    [dicToSave setObject:CFBridgingRelease(CGRectCreateDictionaryRepresentation(self.bottomLeftControl.frame)) forKey:@"bottomLeftControl"];
    [dicToSave setObject:CFBridgingRelease(CGRectCreateDictionaryRepresentation(self.bottomRightControl.frame)) forKey:@"bottomRightControl"];
    
    [[[FloorPlayServices singleton] preferences] setObject:dicToSave forKey:@"FreezedImage"];
    [[[FloorPlayServices singleton] preferences] synchronize];
    
    [[[UIAlertView alloc] initWithTitle:@"Floorplay" message:@"Your transform is saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (IBAction)changeCarpetTapped:(id)sender
{
    CarpetImagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CarpetImagesViewController"];
    vc.delegate = self;
    
    CGRect rect = [_barView convertRect:_btnChangeCarpet.frame toView:self.view];
    _popOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [_popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)selectBackgroundTapped:(UIButton*)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Camera Roll", @"Choose existing", nil];
    [actionSheet showFromRect:sender.frame inView:_barView animated:YES];
}

- (IBAction)resetTapped:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Floorplay" message:@"Your transform will be lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil] show];
}

-(void)loadFreezedImage
{
    NSMutableDictionary *dicToSave = [[[FloorPlayServices singleton] preferences] objectForKey:@"FreezedImage"];
    
    if(dicToSave)
    {
        NSDictionary *topLeftControl = [dicToSave valueForKey:@"topLeftControl"];
        NSString *topRightControl = [dicToSave valueForKey:@"topRightControl"];
        NSString *bottomLeftControl = [dicToSave valueForKey:@"bottomLeftControl"];
        NSString *bottomRightControl = [dicToSave valueForKey:@"bottomRightControl"];
        
        CGRect topLeftFrame ;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)topLeftControl, &topLeftFrame);
        CGRect topRightFrame ;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)topRightControl, &topRightFrame);
        CGRect bottomLeftFrame ;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)bottomLeftControl, &bottomLeftFrame);
        CGRect bottomRightFrame ;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)bottomRightControl, &bottomRightFrame);
        
        _topLeftControl.frame = topLeftFrame;
        _topRightControl.frame = topRightFrame;
        _bottomLeftControl.frame = bottomLeftFrame;
        _bottomRightControl.frame = bottomRightFrame;
    }
    [self createAndApplyQuad];
}

-(void)resetImage
{
    CGRect topLeftFrame = CGRectMake(38, 83, 46, 46);
    CGRect topRightFrame = CGRectMake(914, 83, 46, 46) ;
    CGRect bottomLeftFrame = CGRectMake(38, 660, 46, 46) ;
    CGRect bottomRightFrame = CGRectMake(914, 660, 46, 46) ;
    _topLeftControl.frame = topLeftFrame;
    _topRightControl.frame = topRightFrame;
    _bottomLeftControl.frame = bottomLeftFrame;
    _bottomRightControl.frame = bottomRightFrame;
    
    [self createAndApplyQuad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[[FloorPlayServices singleton] preferences] removeObjectForKey:@"FreezedImage"];
            [self resetImage];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self showCamerawithSource:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self showCamerawithSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 2:
            [self loadbackgroundImages];
            break;
            
        default:
            break;
    }
}

#pragma -mark UIImagePickerController Delegates

- (void)showCamerawithSource:(UIImagePickerControllerSourceType)sourceType
{
    if(_cameraPicker == nil)
    {
        _cameraPicker = [[UIImagePickerController alloc] init];
        _cameraPicker.delegate = self;
    }
    
    [_cameraPicker setSourceType:sourceType];
    
//    [self presentViewController:_cameraPicker animated:YES completion:nil];
    CGRect rect = [_barView convertRect:_btnChangeBG.frame toView:self.view];
    _popOver = [[UIPopoverController alloc] initWithContentViewController:_cameraPicker];
    [_popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [_cameraPicker dismissViewControllerAnimated:NO completion:nil];
    [_popOver dismissPopoverAnimated:YES];
    
    UIImage *_pickedAvatar;
    
//    if([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary)
//    {
//        _pickedAvatar = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    }
//    else
//    {
        _pickedAvatar = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    }
    
    _backgroundImageView.image = _pickedAvatar;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    [_popOver dismissPopoverAnimated:YES];
}

-(void)loadbackgroundImages
{
    BackgroundImagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BackgroundImagesViewController"];
    vc.delegate = self;
    
    CGRect rect = [_barView convertRect:_btnChangeBG.frame toView:self.view];
    _popOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [_popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)backgroungImageDidChange:(UIImage *)image
{
    _backgroundImageView.image = image;
}

-(void)carpetImageDidChange:(UIImage *)image
{
    _imageView.image = image;
}

-(void)timerTriggered
{
    if(!isContolsHidden)
        [self setControlsHidden:YES];
}

- (IBAction)handleSingletap:(id)sender
{
    [self setControlsHidden:!isContolsHidden];
}

-(void)setControlsHidden:(BOOL)hidden
{
    isContolsHidden = hidden;
    _barView.hidden = hidden;
    self.topLeftControl.hidden = hidden;
    self.topRightControl.hidden = hidden;
    self.bottomRightControl.hidden = hidden;
    self.bottomLeftControl.hidden = hidden;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.contentSizeForViewInPopover = CGSizeMake(600, 600);
}

@end
