//
//  HomeViewController.h
//  SinaWeibo
//
//  Created by Liu East on 11-8-19.
//  Copyright 2011 eshore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"


@interface HomeViewController : UIViewController<WBEngineDelegate,UITableViewDelegate, UITableViewDataSource> {
    WBEngine *weiBoEngine;
    NSMutableArray *timeLine;
    UITableView *timeLineTableView;


}
@property (nonatomic, retain) WBEngine *weiBoEngine;

-(void)startAuth;

@end
