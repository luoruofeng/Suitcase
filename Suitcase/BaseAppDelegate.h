//
//  BaseAppDelegate.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-10.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@class MenuViewController;

@interface BaseAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MenuViewController *viewController;

@end
