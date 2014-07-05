//
//  FPAFNetworking.h
//  FloorPlay
//
//  Created by Vikas Kumar on 05/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface FPAFNetworking : AFHTTPSessionManager

+(instancetype)client;

+(instancetype)imageDownloadClient;

@end
