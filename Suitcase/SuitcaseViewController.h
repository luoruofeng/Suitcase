//
//  SuitcaseViewController.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-21.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"
@class Suitcase;
@class DZWebBrowser;

@protocol SuitcaseDelegate <NSObject>

@optional
- (void)goBack;

@end


@interface SuitcaseTextField : UITextField
@end

@interface GoodsListView : UIScrollView
@end

@interface UITypeView : UIScrollView
@end

@interface SuitcaseViewController : UIViewController<UIGestureRecognizerDelegate,
    UITextFieldDelegate
    ,UIScrollViewDelegate,DWTagListDelegate,
    NSFetchedResultsControllerDelegate,
    UIAlertViewDelegate>

@property(nonatomic, strong) Suitcase *suitcase;

@property(nonatomic, strong) UILabel *orderDescription;
@property(nonatomic, strong) UILabel *bagDescription;
@property(nonatomic, strong) UILabel *orderNumber;
@property(nonatomic, strong) UILabel *bagNumber;
@property(nonatomic, strong) UIScrollView *order;
@property(nonatomic, strong) UIScrollView *bag;
@property(nonatomic, assign) CGRect orderRect;
@property(nonatomic, assign) CGRect bagRect;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSTimer *timerCorner;
@property(nonatomic, strong) UIImageView *cornerAddImageView;
@property(nonatomic, strong) UIImageView *cornerMenuImageView;
@property(nonatomic, strong) UIImageView *cornerImageView;
@property(nonatomic, strong) UIButton *cornerButton;
@property(nonatomic, strong) UIButton *cornerLeftButton;
@property(nonatomic, strong) UITypeView *typeMenu;
@property(nonatomic, strong) GoodsListView *goodsListView;
@property(nonatomic, strong) NSMutableDictionary *goodsTypes;
@property(nonatomic, strong) UIImageView *triangleImageView;
@property(nonatomic, strong) NSArray *typesArray;
@property(nonatomic, strong) UIView *titleNav;
@property(nonatomic, strong) UIView *bigTaobaoView;
@property(nonatomic, strong) UIView *bigDeleteView;

@property (nonatomic, strong) UIView *selectView;

@property(nonatomic, strong) NSMutableDictionary *orderDictionary; // 名字 颜色
@property(nonatomic, strong) NSMutableArray *orderArray;//goods


@property(nonatomic, strong) NSMutableDictionary *bagDictionary;// 名字 颜色
@property(nonatomic, strong) NSMutableArray *bagArray;//goods

@property(nonatomic, strong) CoreDataUtil *coreData;

@property (nonatomic, strong) UIView *bigBlock;

@property (nonatomic, strong) UIView *greenSeq;

@property (nonatomic, strong) DZWebBrowser *webBrowser;

@property (nonatomic, strong) UIButton *closeTypesList;
@property (nonatomic, strong) UIButton *keyBored;

@property (nonatomic, strong) UIImageView *finishImageView;

@property (nonatomic, strong) UIAlertView *deleteAllAlert;

@property (nonatomic, assign) id<SuitcaseDelegate> delegate;

@property (nonatomic, strong) SuitcaseTextField *textField;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIScrollView *alertScroll;

@property (nonatomic, strong) UIView *scoreView;

@property (nonatomic, strong) UIButton *scoreBlockButton;

@property (nonatomic, strong) UITextField *scoreText;

@property (nonatomic, assign) NSInteger scoreInt;

@property (nonatomic, strong) UILabel *summaryLabel;

@property (nonatomic, strong) UIAlertView *commonAlert;

- (id)initWithSuitcase:(Suitcase *)suitcase;

@end
