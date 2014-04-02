//
//  FirstPageViewController.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectTypeViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
@class DZWebBrowser;

@protocol FirstPageDelegate <NSObject>

@required
- (void)firstPageModelViewShow;
- (void)firstPageModelViewDismiss;
- (void)createSuitcaseWithType:(NSInteger)typeId;
- (void)firstPageModelViewDidLoad;
@end

@interface FirstPageViewController : UIViewController<NSFetchedResultsControllerDelegate,SelectTypeDelegate,WXApiDelegate,UIActionSheetDelegate,WeiboSDKDelegate>

@property (nonatomic,assign) id<FirstPageDelegate> delegate;
@property (nonatomic,retain) UIActionSheet *shareActionSheet;
@property (nonatomic,retain) DZWebBrowser *webBrowser;

- (id)initWithScroll:(UIScrollView *)scroll;

@end
