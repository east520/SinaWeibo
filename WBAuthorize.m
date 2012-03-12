//
//  WBAuthorize.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorize.h"
#import "AFNetworking.h"
#import "WBSDKGlobal.h"
#import "WBHTTPClient.h"

#define kWBBaseURL          @"https://api.weibo.com/oauth2/authorize"
#define kWBAuthorizeURL     @"/oauth2/authorize"
#define kWBAccessTokenURL   @"/oauth2/access_token"

@interface WBAuthorize (Private)

- (void)dismissModalViewController;
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code;

@end

@implementation WBAuthorize

@synthesize appKey;
@synthesize appSecret;
@synthesize redirectURI;
@synthesize rootViewController;
@synthesize delegate;

#pragma mark - WBAuthorize Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
    }
    
    return self;
}

- (void)dealloc
{
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [redirectURI release], redirectURI = nil;
    
    rootViewController = nil;
    delegate = nil;
    
    [super dealloc];
}

#pragma mark - WBAuthorize Private Methods

- (void)dismissModalViewController
{
    [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      appSecret, @"client_secret",
                                                                      @"authorization_code", @"grant_type",
                                                                      redirectURI, @"redirect_uri",
                                                                      code, @"code", nil];
    
    
    [[WBHTTPClient sharedClient] post:kWBAccessTokenURL parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* result) {
        NSLog(@"OK");
        
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)result;
            
            NSString *token = [dict objectForKey:@"access_token"];
            NSString *userID = [dict objectForKey:@"uid"];
            NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
            
            BOOL success = NO;
            success = token && userID;
            
            if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
            {
                [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }
    ];
    
    
}


#pragma mark - WBAuthorize Public Methods

- (void)startAuthorize
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:appKey, @"client_id",
                                                                      @"code", @"response_type",
                                                                      redirectURI, @"redirect_uri", 
                                                                      @"mobile", @"display", nil];
    
    
    
    NSString *urlString = [WBUtil serializeURL:kWBBaseURL
                                           params:params
                                       httpMethod:@"GET"];
    
    WBAuthorizeWebView *webView = [[WBAuthorizeWebView alloc] init];
    [webView setDelegate:self];
    [webView loadRequestWithURL:[NSURL URLWithString:urlString]];
    [webView show:YES];
    [webView release];
}

#pragma mark - WBAuthorizeWebViewDelegate Methods

- (void)authorizeWebView:(WBAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)code
{
    [webView hide:YES];
    
    // if not canceled
    if (![code isEqualToString:@"21330"])
    {
        [self requestAccessTokenWithAuthorizeCode:code];
    }
}

#pragma mark - WBRequestDelegate Methods

/*
- (void)request:(WBRequest *)theRequest didFinishLoadingWithResult:(id)result
{
    BOOL success = NO;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        
        NSString *token = [dict objectForKey:@"access_token"];
        NSString *userID = [dict objectForKey:@"uid"];
        NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
        
        success = token && userID;
        
        if (success && [delegate respondsToSelector:@selector(authorize:didSucceedWithAccessToken:userID:expiresIn:)])
        {
            [delegate authorize:self didSucceedWithAccessToken:token userID:userID expiresIn:seconds];
        }
    }
    
    // should not be possible
    if (!success && [delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        NSError *error = [NSError errorWithDomain:kWBSDKErrorDomain 
                                             code:kWBErrorCodeSDK 
                                         userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeAuthorizeError] 
                                                                              forKey:kWBSDKErrorCodeKey]];
        [delegate authorize:self didFailWithError:error];
    }
}

- (void)request:(WBRequest *)theReqest didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(authorize:didFailWithError:)])
    {
        [delegate authorize:self didFailWithError:error];
    }
}
 */

@end
