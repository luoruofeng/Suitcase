//
//  BaseViewController.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-10.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstPageViewController.h"
#import "SuitcaseViewController.h"
#import "MenuItemViewController.h"

@interface MenuViewController : UIViewController<UIScrollViewDelegate,FirstPageDelegate,MenuItemViewControllerDelegate,SuitcaseDelegate>



@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger curentItemIndex;

@property (nonatomic, strong) NSMutableArray *suitcases;
@property (strong, nonatomic) UIPageControl *pageControl;
@end
