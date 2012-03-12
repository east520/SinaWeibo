    //
//  HomeViewController.m
//  SinaWeibo
//
//  Created by Liu East on 11-8-19.
//  Copyright 2011 eshore. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"


#ifndef kWBSDKDemoAppKey
#define kWBSDKDemoAppKey @"216747118"
#endif

#ifndef kWBSDKDemoAppSecret
#define kWBSDKDemoAppSecret @"d286230908d3c968640c135cb608af8c"
#endif

#ifndef kWBSDKDemoUsername
#define kWBSDKDemoUsername @"east520@gmail.com"
#endif

#ifndef kWBSDKDemoPassword
#define kWBSDKDemoPassword @"439439439"
#endif


#define kWBAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kWBAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"


#define kWBAlertViewLogInTag  101


@interface HomeViewController (Private)

- (void)dismissTimelineViewController;
- (void)presentTimelineViewController:(BOOL)animated;
- (void)presentTimelineViewControllerWithoutAnimation;
- (void)refreshTimeline;

@end

@implementation HomeViewController

@synthesize weiBoEngine;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    timeLine = [[NSMutableArray alloc] init];
    
    timeLineTableView = [[UITableView alloc] init];
    [timeLineTableView setDelegate:self];
    [timeLineTableView setDataSource:self];
    [timeLineTableView setBackgroundColor:[UIColor whiteColor]];
    
    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
    int height = ((hasStatusBar) ? 20 : 0);
    [timeLineTableView setFrame:CGRectMake(0, 0, 320, 480 - height - 32)];
    
    [self.view addSubview:timeLineTableView];
    
    [self startAuth];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release], weiBoEngine = nil;
    
    
    [timeLine release], timeLine = nil;
    
    [timeLineTableView setDelegate:nil];
    [timeLineTableView setDataSource:nil];
    [timeLineTableView release], timeLineTableView = nil;

}

#pragma -
#pragma custom method
- (void) startAuth{
    
    
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
    
    if ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        [self performSelector:@selector(presentTimelineViewControllerWithoutAnimation) withObject:nil afterDelay:0.0];
    }
    else
    {
        [weiBoEngine logIn];
    }
    
}


- (void)presentTimelineViewControllerWithoutAnimation
{
    [self presentTimelineViewController:NO];
}

- (void)presentTimelineViewController:(BOOL)animated
{
//    WBSDKTimelineViewController *controller = [[WBSDKTimelineViewController alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
//    
//    self.timeLineViewController = controller;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain
                                                               target:self 
                                                               action:@selector(onLogOutButtonPressed)];
    
    
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"写微博" style:UIBarButtonItemStylePlain
                                                                target:self 
                                                                action:@selector(onSendButtonPressed)];
    
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [rightBtn release];
    
    [self.navigationItem setTitle:@"微博"];
    
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [controller release];
//    [self presentModalViewController:navController animated:animated];
//    [navController release];
    
//    timeLineTableView = [[UITableView alloc] init];
//    [timeLineTableView setDelegate:self];
//    [timeLineTableView setDataSource:self];
//    [timeLineTableView setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:timeLineTableView];
    [self refreshTimeline];
}


- (void)engineDidLogIn:(WBEngine *)engine
{
    //[indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
	[alertView release];
}

#pragma mark - WBSDKTimelineViewController Private Methods

- (void)refreshTimeline
{
    [weiBoEngine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:nil
                     httpHeaderFields:nil];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeLine count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Timeline Cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Timeline Cell"] autorelease];
    }
    
    NSDictionary *detail = [timeLine objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[[detail objectForKey:@"user"] objectForKey:@"screen_name"]];
    [cell.detailTextLabel setText:[detail objectForKey:@"text"]];
    
    return cell;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    
    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        [timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
        [timeLineTableView reloadData];
    }
}

@end
