//
//  WBHTTPClient.m
//  SinaWeibo
//
//  Created by 东方 刘 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBHTTPClient.h"
#import "JSON.h"


#define kWBbaseURL                      @"https://api.weibo.com/"

@implementation WBHTTPClient


+ (id)sharedClient
{
    static WBHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate = 0;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWBbaseURL]];
    });
    
    return _sharedClient;
}


#pragma mark - Custom requests

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
//    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//	[self setDefaultHeader:@"Accept" value:@"application/json"];
//    
//    // X-Gowalla-API-Key HTTP Header; see http://api.gowalla.com/api/docs
//	[self setDefaultHeader:@"X-Gowalla-API-Key" value:kAFGowallaClientID];
//	
//	// X-Gowalla-API-Version HTTP Header; see http://api.gowalla.com/api/docs
//	[self setDefaultHeader:@"X-Gowalla-API-Version" value:@"1"];
//	
//	// X-UDID HTTP Header
//	[self setDefaultHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
    
    return self;
}

- (void) post:(NSString*)urlstring
parameters:(NSDictionary*)objects
success:(void (^)(AFHTTPRequestOperation *request, NSArray *jsonobjects))success
failure:(void (^)(AFHTTPRequestOperation *request, NSError *error))failure
{
    [self postPath:urlstring
        parameters:objects
           success:^(AFHTTPRequestOperation *request, id JSON){
               NSLog(@"postPath request: %@", request.request.URL);
               
               if ([JSON isKindOfClass: [NSString class]]){
                   JSON = [JSON JSONValueWithOptions: nil];
                   if ([JSON isKindOfClass: [NSDictionary class]]){
                       
                       if(success) {
                           success(request,JSON);
                       }
                   }
               }
               else
               {
                   if ([JSON isKindOfClass: [NSDictionary class]]){
                   
                   if(success) {
                       success(request,JSON);
                    }
                   }
               }
           }
           failure:failure];
}

- (void) get:(NSString*)urlstring
   parameters:(NSDictionary*)objects
      success:(void (^)(AFHTTPRequestOperation *request, NSArray *jsonobjects))success
      failure:(void (^)(AFHTTPRequestOperation *request, NSError *error))failure
{
    [self getPath:urlstring
        parameters:objects
           success:^(AFHTTPRequestOperation *request, id JSON){
               NSLog(@"getPath request: %@", request.request.URL);
               
               if ([JSON isKindOfClass: [NSString class]]){
                   JSON = [JSON JSONValueWithOptions: nil];
                   if ([JSON isKindOfClass: [NSDictionary class]]){
                       
                       if(success) {
                           success(request,JSON);
                       }
                   }
               }
               else
               {
                   if ([JSON isKindOfClass: [NSDictionary class]]){
                       
                       if(success) {
                           success(request,JSON);
                       }
                   }
               }
           }
           failure:failure];
}

@end
