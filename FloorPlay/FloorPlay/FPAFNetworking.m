//
//  FPAFNetworking.m
//  FloorPlay
//
//  Created by Vikas Kumar on 05/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "FPAFNetworking.h"
#import "Constants.h"

@implementation FPAFNetworking

+(instancetype)client
{
    static FPAFNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             if(status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable)
             {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"No_Internet", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
             }
         }];
    });
    return sharedInstance;
    
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    return self;
}





+(instancetype)imageDownloadClient
{
    static FPAFNetworking *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] initWithBaseImageDownloadURL:[NSURL URLWithString:SERVER_URL]];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
         {
             if(status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable)
             {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"No_Internet", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
             }
         }];
    });
    return sharedInstance;
}

- (id)initWithBaseImageDownloadURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    self.responseSerializer = [AFImageResponseSerializer serializer];
    return self;
}



@end
