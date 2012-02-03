//
//  SinaWeiboAppDelegate.h
//  SinaWeibo
//
//  Created by Liu East on 11-8-19.
//  Copyright 2011 eshore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinaWeiboAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarContronller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

