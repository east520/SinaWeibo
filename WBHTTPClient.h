//
//  WBHTTPClient.h
//  SinaWeibo
//
//  Created by 东方 刘 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AFNetworking.h"

@interface WBHTTPClient : AFHTTPClient

+ (WBHTTPClient *)sharedClient;
@end
