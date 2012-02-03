//
//  SinaWeiboAppDelegate.m
//  SinaWeibo
//
//  Created by Liu East on 11-8-19.
//  Copyright 2011 eshore. All rights reserved.
//

#import "SinaWeiboAppDelegate.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "PlazaViewController.h"
#import "AccountViewController.h"
#import "SettingsViewController.h"
#import "UImageScale.h"


@implementation SinaWeiboAppDelegate

@synthesize window;


- (UINavigationController *)createNavControllerWrappingViewControllerOfClass:(Class)cntrloller 
																	 nibName:(NSString*)nibName 
																 tabIconName:(NSString*)iconName
																	tabTitle:(NSString*)tabTitle
{
	UIViewController* viewController = [[cntrloller alloc] initWithNibName:nibName bundle:nil];
	
	UINavigationController *theNavigationController;
	theNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	viewController.tabBarItem.image = [[UIImage imageNamed:iconName] scaleToSize:CGSizeMake(32,32)];
	viewController.title = NSLocalizedString(tabTitle, @""); 
	[viewController release];
	
	return theNavigationController;
}

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	// Add the view controller's view to the window and display.
	CGRect frame = [[UIScreen mainScreen] bounds];
	window = [[UIWindow alloc] initWithFrame:frame];
	window.backgroundColor = [UIColor whiteColor];
	
	tabBarContronller = [[UITabBarController alloc] init];
	UINavigationController *localNavigationController;
	NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:4];
	
	{
		//主页
		localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[HomeViewController class] nibName:@"HomeViewController" tabIconName:@"HomeView.png" tabTitle:@"主页"];
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		//消息
		localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[MessageViewController class] nibName:@"MessageViewController" tabIconName:@"MessageView.png" tabTitle:@"消息"];
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		//广场
		localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[PlazaViewController class] nibName:@"PlazaViewController" tabIconName:@"PlazaView.png" tabTitle:@"看看"];
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		//我的资料
		localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[AccountViewController class] nibName:@"AccountViewController" tabIconName:@"AccountView.png" tabTitle:@"我的资料"];
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
		
		//设定
		localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[SettingsViewController class] nibName:@"SettingsViewController" tabIconName:@"SettingsView.png" tabTitle:@"设定"];
		[localViewControllersArray addObject:localNavigationController];
		[localNavigationController release];
	}	
	
	tabBarContronller.viewControllers = localViewControllersArray;
	
	[localViewControllersArray release];
	
	[window addSubview: tabBarContronller.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarContronller release];
    [window release];
    [super dealloc];
}


@end
