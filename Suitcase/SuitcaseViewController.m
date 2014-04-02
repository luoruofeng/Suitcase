//
//  SuitcaseViewController.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-21.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "SuitcaseViewController.h"
#import "TypesUtil.h"
#import "DWTagList.h"
#import "Goods.h"
#import "Suitcase.h"
#import "DZWebBrowser.h"

#define NUMBER_HEIGHT 40
#define PATH @""
int menuScrollHeight = 60;


@implementation SuitcaseTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    int leftMargin = 10;
    CGRect inset = CGRectMake(bounds.origin.x + leftMargin, bounds.origin.y, bounds.size.width - leftMargin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int leftMargin = 10;
    CGRect inset = CGRectMake(bounds.origin.x + leftMargin, bounds.origin.y, bounds.size.width - leftMargin, bounds.size.height);
    return inset;
}

@end

@implementation GoodsListView
@end

@interface UINavView : UIView

@end

@implementation UINavView

-(void)drawRect:(CGRect)rect
{
    CGMutablePathRef path=CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 110, 100);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, 100);
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, 0);
    
    CGPathMoveToPoint(path, NULL, 110, 0);
    CGPathAddLineToPoint(path, NULL, 110, 200);
    
    CGPathMoveToPoint(path, NULL, 180, 0);
    CGPathAddLineToPoint(path, NULL, 180, 200);
    
    CGPathMoveToPoint(path, NULL, 250, 0);
    CGPathAddLineToPoint(path, NULL, 250, 200);
    
    CGPathCloseSubpath(path);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.4);
    CGContextSetStrokeColorWithColor(context, DARK_GRAY_COLOR.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);

}

@end


@implementation UITypeView

-(void)drawRect:(CGRect)rect
{
    CGMutablePathRef path=CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, 0);
    
    CGPathCloseSubpath(path);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 6);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithString:@"18a69a"].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGPathMoveToPoint(path, NULL, 0, menuScrollHeight);
    CGPathAddLineToPoint(path, NULL, SCREEN_WIDTH, menuScrollHeight);
    
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 3);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithString:@"18a69a"].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
}

@end


@interface SuitcaseViewController ()
@property(nonatomic, strong) UINavView *nav;
@property(nonatomic, strong) NSMutableArray *goodsScrollArray;
@property(nonatomic, strong) NSMutableArray *typeButtonsArray;
@property(nonatomic, strong) DWTagList *tagList;
@property(nonatomic, strong) DWTagList *tagListOrder;
@property(nonatomic, strong) DWTagList *tagListBag;
@property(nonatomic, strong) GoodsListView *goodsScroll;
@property(nonatomic, strong) UIView *blockTopView;
@property(nonatomic, strong) UIView *blockBottomView;
@property(nonatomic, strong) UILabel *addToOrderLabel;
@property(nonatomic, strong) UILabel *addToBagLabel;
@property(nonatomic, strong) NSTimer *orderTimer;
@end

@implementation SuitcaseViewController
    

    int triangleHeight = 35;
    int offsetWidth = 10;
    int typeButtonWeidth = 100;
    int initFlag = 1000000;
    int goodsListHeight = 0;

- (id)init
{
    self = [super init];
    if (self) {
        if(!self.coreData)
        {
            self.coreData =[CoreDataUtil shareTypesUtil];
        }
        [[CoreDataUtil shareTypesUtil] initCoreData];
        [self loadData];
    }
    return self;
}

- (id)initWithSuitcase:(Suitcase *)suitcase
{
    self = [super init];
    if (self) {
        self.suitcase = suitcase;
        if(!self.coreData)
        {
            self.coreData =[CoreDataUtil shareTypesUtil];
        }
        [self loadData];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.bagRect = CGRectMake(0, [self getScreenHeight]/2, SCREEN_WIDTH, [self getScreenHeight]/2);
    self.orderRect = CGRectMake(0, 0, SCREEN_WIDTH, ([self getScreenHeight])/2);
    
    self.order = [[UIScrollView alloc] initWithFrame:self.orderRect];
    [self.order setContentSize:self.orderRect.size];
    self.bag = [[UIScrollView alloc] initWithFrame:self.bagRect];
                
    [self.nav setBackgroundColor:DARK_GRAY_COLOR];
    [self.order setBackgroundColor:[UIColor whiteColor]];
    [self.bag setBackgroundColor:LIGHT_GRAY_COLOR];
    
    [self.view addSubview:self.nav];
    [self.view addSubview:self.order];
    [self.view addSubview:self.bag];
    
    [self.order.layer setPosition:CGPointZero];
    [self.order.layer setAnchorPoint:CGPointZero];
    
    //nav
    
    self.nav = [[UINavView alloc] initWithFrame:CGRectMake(0, [self getScreenHeight] - SUITCASE_NAV_HEIGHT, SCREEN_WIDTH, SUITCASE_NAV_HEIGHT)];
    [self.nav setBackgroundColor:DARK_BLUE_COLOR];
    [self.view addSubview:self.nav];
    
    
    int navButtonWidth = 70;
    int navButtonHeight = 100;
    int backButtonWitdh = 110;
    int backButtonHeight = navButtonHeight * 2;

    CGPoint iconDescriptionCenter = CGPointMake(0, 70);
    CGSize iconDescriptionSize = CGSizeMake(navButtonWidth, 25);
    UIFont *iconDescription = [UIFont systemFontOfSize:14];
    UIColor *iconDescriptionColor = [UIColor colorWithString:@"18a69a"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonWitdh, backButtonHeight)];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIImage *backImage = [UIImage imageNamed:@"backToMenu"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    UILabel *backLabel = [[UILabel alloc] init];
    [backLabel setText:@"退出"];
    [backLabel setFont:iconDescription];
    [backLabel setTextColor:iconDescriptionColor];
    [backLabel setCenter:CGPointMake(0, 110)];
    [backLabel setSize:CGSizeMake(backButtonWitdh, 25)];
    [backLabel setTextAlignment:NSTextAlignmentCenter];
    [backLabel setBackgroundColor:[UIColor clearColor]];
    
    UIButton *addLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh, 0, navButtonWidth, navButtonHeight)];
    [addLabelButton addTarget:self action:@selector(commonUse) forControlEvents:UIControlEventTouchUpInside];
    UIImage *addLabelImage = [UIImage imageNamed:@"addLabel"];
    [addLabelButton setImage:addLabelImage forState:UIControlStateNormal];
    UILabel *addLabelLabel = [[UILabel alloc] init];
    [addLabelLabel setText:@"常用清单"];
    [addLabelLabel setFont:iconDescription];
    [addLabelLabel setTextColor:iconDescriptionColor];
    [addLabelLabel setCenter:iconDescriptionCenter];
    [addLabelLabel setSize:iconDescriptionSize];
    [addLabelLabel setTextAlignment:NSTextAlignmentCenter];
    [addLabelLabel  setBackgroundColor:[UIColor clearColor]];
    
    UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh + navButtonWidth, 0, navButtonWidth, navButtonHeight)];
    [addImageButton addTarget:self action:@selector(addType) forControlEvents:UIControlEventTouchUpInside];
    UIImage *addImageImage = [UIImage imageNamed:@"addImage"];
    [addImageButton setImage:addImageImage forState:UIControlStateNormal];
    UILabel *addImageLabel = [[UILabel alloc] init];
    [addImageLabel setText:@"百度行程"];
    [addImageLabel setFont:iconDescription];
    [addImageLabel setTextColor:iconDescriptionColor];
    [addImageLabel setCenter:iconDescriptionCenter];
    [addImageLabel setSize:iconDescriptionSize];
    [addImageLabel setTextAlignment:NSTextAlignmentCenter];
    [addImageLabel setBackgroundColor:[UIColor clearColor]];

    
    UIButton *alertInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh + (navButtonWidth*2), 0, navButtonWidth, navButtonHeight)];
    [alertInfoButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    UIImage *alertInfoImage = [UIImage imageNamed:@"alertInfo"];
    [alertInfoButton setImage:alertInfoImage forState:UIControlStateNormal];
    UILabel *alertInfoLabel = [[UILabel alloc] init];
    [alertInfoLabel setText:@"提示"];
    [alertInfoLabel setFont:iconDescription];
    [alertInfoLabel setTextColor:iconDescriptionColor];
    [alertInfoLabel setCenter:iconDescriptionCenter];
    [alertInfoLabel setSize:iconDescriptionSize];
    [alertInfoLabel setTextAlignment:NSTextAlignmentCenter];
    [alertInfoLabel  setBackgroundColor:[UIColor clearColor]];
    
    UIButton *taobaoButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh, navButtonHeight, navButtonWidth, navButtonHeight)];
    [taobaoButton addTarget:self action:@selector(taobao) forControlEvents:UIControlEventTouchUpInside];
    UIImage *taobaoImage = [UIImage imageNamed:@"taobao"];
    [taobaoButton setImage:taobaoImage forState:UIControlStateNormal];
    UILabel *taobaoLabel = [[UILabel alloc] init];
    [taobaoLabel setText:@"逛淘宝"];
    [taobaoLabel setFont:iconDescription];
    [taobaoLabel setTextColor:iconDescriptionColor];
    [taobaoLabel setCenter:iconDescriptionCenter];
    [taobaoLabel setSize:iconDescriptionSize];
    [taobaoLabel setTextAlignment:NSTextAlignmentCenter];
    [taobaoLabel  setBackgroundColor:[UIColor clearColor]];
    
    UIButton *scoreButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh + navButtonWidth, navButtonHeight, navButtonWidth, navButtonHeight)];
    [scoreButton addTarget:self action:@selector(score) forControlEvents:UIControlEventTouchUpInside];
    UIImage *scoreImage = [UIImage imageNamed:@"score"];
    [scoreButton setImage:scoreImage forState:UIControlStateNormal];
    UILabel *scoreLabel = [[UILabel alloc] init];
    [scoreLabel setText:@"评分"];
    [scoreLabel setFont:iconDescription];
    [scoreLabel setTextColor:iconDescriptionColor];
    [scoreLabel setCenter:iconDescriptionCenter];
    [scoreLabel setSize:iconDescriptionSize];
    [scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [scoreLabel  setBackgroundColor:[UIColor clearColor]];
    
    UIButton *deleteLabelButton = [[UIButton alloc] initWithFrame:CGRectMake(backButtonWitdh + (navButtonWidth * 2), navButtonHeight, navButtonWidth, navButtonHeight)];
    [deleteLabelButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    UIImage *deleteLabelImage = [UIImage imageNamed:@"deleteLabel"];
    [deleteLabelButton setImage:deleteLabelImage forState:UIControlStateNormal];
    UILabel *deleteLabel = [[UILabel alloc] init];
    [deleteLabel setText:@"清空背包"];
    [deleteLabel setFont:iconDescription];
    [deleteLabel setTextColor:iconDescriptionColor];
    [deleteLabel setCenter:iconDescriptionCenter];
    [deleteLabel setSize:iconDescriptionSize];
    [deleteLabel setTextAlignment:NSTextAlignmentCenter];
    [deleteLabel  setBackgroundColor:[UIColor clearColor]];

    [backButton addSubview:backLabel];
    [addLabelButton addSubview:addLabelLabel];
    [addImageButton addSubview:addImageLabel];
    [alertInfoButton addSubview:alertInfoLabel];
    [scoreButton addSubview:scoreLabel];
    [taobaoButton addSubview:taobaoLabel];
    [deleteLabelButton addSubview:deleteLabel];
    
    [self.nav addSubview:backButton];
    [self.nav addSubview:addLabelButton];
    [self.nav addSubview:addImageButton];
    [self.nav addSubview:alertInfoButton];
    [self.nav addSubview:scoreButton];
    [self.nav addSubview:taobaoButton];
    [self.nav addSubview:deleteLabelButton];
    
    //nav 定位
    [self.nav.layer setAnchorPoint:CGPointMake(0, 0)];
    [self.nav.layer setPosition:CGPointMake(SCREEN_WIDTH, [self getScreenHeight] - SUITCASE_NAV_HEIGHT)];
    
    //right corner
    int cornerHeight = 50;
    self.cornerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cornerButton setFrame:CGRectMake(SCREEN_WIDTH - cornerHeight, [self getScreenHeight] - cornerHeight, cornerHeight, cornerHeight)];
    [self.cornerButton addTarget:self action:@selector(cornerButtonPressDown) forControlEvents:UIControlEventTouchUpInside];
        UIImage *corner = [UIImage imageNamed:@"corner"];
    [self.cornerButton setBackgroundImage:corner forState:UIControlStateNormal];
    [self.view addSubview:self.cornerButton];
    

    int cornerMenuHeight = 27;
    UIImage *cornerMenu = [UIImage imageNamed:@"menuCorner"];
    self.cornerAddImageView = [[UIImageView alloc] initWithImage:cornerMenu];
    [self.cornerAddImageView setFrame:CGRectMake(cornerHeight - cornerMenuHeight - 0, cornerHeight - cornerMenuHeight -5, cornerMenuHeight, cornerMenuHeight)];
    [self.cornerButton addSubview:self.cornerAddImageView];
    
    [self.view addSubview:self.cornerButton];
    [self.cornerButton.layer setAnchorPoint:CGPointZero];
    [self.cornerButton.layer setPosition:CGPointMake(SCREEN_WIDTH - cornerHeight, [self getScreenHeight] - cornerHeight)];
    
    
    //left corner
    self.cornerLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cornerLeftButton setFrame:CGRectMake(0, [self getScreenHeight] - cornerHeight, cornerHeight, cornerHeight)];
    [self.cornerLeftButton addTarget:self action:@selector(cornerLeftButtonPressDown) forControlEvents:UIControlEventTouchUpInside];
    UIImage *leftcorner = [UIImage imageNamed:@"leftCorner"];
    [self.cornerLeftButton setBackgroundImage:leftcorner forState:UIControlStateNormal];
    [self.view addSubview:self.cornerLeftButton];
    
    
    int cornerAddHeight = 27;
    UIImage *cornerAdd = [UIImage imageNamed:@"corner_add"];
    self.cornerMenuImageView = [[UIImageView alloc] initWithImage:cornerAdd];
    [self.cornerMenuImageView setFrame:CGRectMake(cornerHeight - cornerAddHeight - 20, cornerHeight - cornerAddHeight -5, cornerAddHeight, cornerAddHeight)];
    [self.cornerLeftButton addSubview:self.cornerMenuImageView];
    
    [self.view addSubview:self.cornerLeftButton];
    [self.cornerLeftButton.layer setAnchorPoint:CGPointZero];
    [self.cornerLeftButton.layer setPosition:CGPointMake(0, [self getScreenHeight] - cornerHeight)];
    
    //selectView
    self.selectView = [[UIView alloc] initWithFrame:self.bagRect];
    [self.view addSubview:self.selectView];
    [self.view bringSubviewToFront:self.selectView];
    [self.selectView.layer setAnchorPoint:CGPointZero];
    [self.selectView.layer setPosition:CGPointMake(-SCREEN_WIDTH, [self getScreenHeight])];
    
    //menuScroll
    self.typeMenu = [[UITypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, menuScrollHeight)];
    [self.typeMenu setBackgroundColor:DARK_BLUE_COLOR];
    [self.selectView addSubview:self.typeMenu];
    
    //goodslist
    goodsListHeight = [self getScreenHeight]/2 - menuScrollHeight;
    self.goodsListView = [[GoodsListView alloc] initWithFrame:CGRectMake(0, menuScrollHeight, SCREEN_WIDTH, goodsListHeight)];
    [self.goodsListView setBackgroundColor:DARK_GRAY_COLOR];
    [self.goodsListView setDelegate:self];
    [self.selectView addSubview:self.goodsListView];
    
    //箭头
    UIImage *imageTriangle = [UIImage imageNamed:@"greenTriangle"];
    self.triangleImageView = [[UIImageView alloc] initWithImage:imageTriangle];
    [self.triangleImageView setFrame:CGRectMake(0, menuScrollHeight - triangleHeight, triangleHeight, triangleHeight)];
    [self.typeMenu addSubview:self.triangleImageView];
    
    //title nav
    self.titleNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TITLE_NAV_HEIGHT)];
    self.bigTaobaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT)];
    self.bigDeleteView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT)];
    
    int bigImageHeight = 30;
    
    UIImage *bigTaobaoImage = [UIImage imageNamed:@"big_taobao"];
    UIImageView *bigTaobaoImageView = [[UIImageView alloc] initWithImage:bigTaobaoImage];
    [bigTaobaoImageView setFrame:CGRectMake((SCREEN_WIDTH/2 - bigImageHeight) /2, self.titleNav.height - bigImageHeight-10, bigImageHeight, bigImageHeight)];
    UIImage *bigDeleteImage = [UIImage imageNamed:@"deleteLabel"];
    UIImageView *bigDeleteImageView = [[UIImageView alloc] initWithImage:bigDeleteImage];
    [bigDeleteImageView setFrame:CGRectMake((SCREEN_WIDTH/2 - bigImageHeight) /2, self.titleNav.height - bigImageHeight - 10, bigImageHeight, bigImageHeight)];
    [self.bigTaobaoView addSubview:bigTaobaoImageView];
    [self.bigDeleteView addSubview:bigDeleteImageView];
    
    [self.titleNav setBackgroundColor:DARK_BLUE_COLOR];
    
    if(IOS_VERSION >= 7.0)
    {
        [self.titleNav setHeight:TITLE_NAV_HEIGHT + 20];
        [self.bigTaobaoView setHeight:TITLE_NAV_HEIGHT + 20];
        [self.bigDeleteView setHeight:TITLE_NAV_HEIGHT + 20];
    }
    
    [self.titleNav.layer setAnchorPoint:CGPointZero];
    [self.titleNav.layer setPosition:CGPointMake(0, -self.titleNav.height)];
    
    [self.titleNav addSubview:self.bigTaobaoView];
    [self.titleNav addSubview:self.bigDeleteView];
    [KEY_WINDOW addSubview:self.titleNav];
    
    
    //big block
    self.bigBlock = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    [self.bigBlock setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.4]];
    [self.view addSubview:self.bigBlock];
    
    //描述
    self.orderDescription = [[UILabel alloc] initWithFrame:self.orderRect];
    self.bagDescription = [[UILabel alloc] initWithFrame:self.bagRect];
    
    UIFont *descriptionFont = [UIFont systemFontOfSize:59];
    [self.orderDescription setFont:descriptionFont];
    [self.bagDescription setFont:descriptionFont];
    
    [self.orderDescription setTextColor:[UIColor whiteColor]];
    [self.bagDescription setTextColor:[UIColor whiteColor]];
    
    [self.orderDescription setTextAlignment:NSTextAlignmentCenter];
    [self.bagDescription setTextAlignment:NSTextAlignmentCenter];
    
    [self.orderDescription setBackgroundColor:[UIColor clearColor]];
    [self.bagDescription setBackgroundColor:[UIColor clearColor]];
    
    [self.orderDescription setText:@"清单"];
    [self.bagDescription setText:@"背包"];
    
    [self.view addSubview:self.orderDescription];
    [self.view addSubview:self.bagDescription];
    
    [self.view bringSubviewToFront:self.orderDescription];
    [self.view bringSubviewToFront:self.bagDescription];
    
    //green seq
    self.greenSeq = [[UIView alloc] initWithFrame:CGRectMake(0, [self getScreenHeight]/2, SCREEN_WIDTH, 5)];
    [self.greenSeq setBackgroundColor:GREEN_COLOR];
    [self.view addSubview:self.greenSeq];
    [self.view bringSubviewToFront:self.greenSeq];
    
    //类型列表 关闭按钮
    self.closeTypesList = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeTypesList setBackgroundImage:[UIImage imageNamed:@"green_close_button"] forState:UIControlStateNormal];
    [self.closeTypesList setFrame:CGRectMake(SCREEN_WIDTH-30, [self getScreenHeight]/2-25, 30, 25)];
        [self.closeTypesList setAlpha:0.0];
    [self.closeTypesList setHidden:YES];
    [self.closeTypesList addTarget:self action:@selector(closeSelectView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeTypesList];
    
    //键盘 按钮
    self.keyBored = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.keyBored setBackgroundImage:[UIImage imageNamed:@"key_board"] forState:UIControlStateNormal];
    [self.keyBored setFrame:CGRectMake(0, [self getScreenHeight]/2-25, 30, 25)];
    [self.keyBored setAlpha:0.0];
    [self.keyBored setHidden:YES];
    [self.keyBored addTarget:self action:@selector(openKeyBored) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keyBored];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideDescription) userInfo:nil repeats:NO];
    
    self.timerCorner = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(cornerFlicker) userInfo:nil repeats:YES];
    
    //手指
    UITapGestureRecognizer *singleFingerOne =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent)];
    singleFingerOne.delegate = self;
    [self.view addGestureRecognizer:singleFingerOne];
    
    //DWTagList order
    [self fetchOrderObjects];
    CGSize contentSize = [self makeLabelWithLabelsArray:self.orderArray fromView:self.order withDWTagList:self.tagListOrder withFromViewType:FromViewTypeOrder];
    [self.order setContentSize:contentSize];
    [self.order setPagingEnabled:NO];
    [self.order setShowsVerticalScrollIndicator:YES];
    
    //DWTagList bag
    [self fetchBagObjects];
    [self makeLabelWithLabelsArray:self.bagArray fromView:self.bag withDWTagList:self.tagListBag withFromViewType:FromViewTypeBag];
    
    //加载类型
     self.goodsTypes = [[TypesUtil shareTypesUtil] getAllGoodsTypes];
    self.typesArray = [[TypesUtil shareTypesUtil] getTypesArray];
    
    //设置contentsize
    [self.goodsListView setContentSize:CGSizeMake(SCREEN_WIDTH*self.typesArray.count, goodsListHeight)];
    [self.goodsListView setContentOffset:CGPointZero];
    [self.goodsListView setPagingEnabled:YES];
    
    self.typeButtonsArray = [[NSMutableArray alloc] init];
    UIButton *typeButton = nil;
    int i = 0;
    int buttonX = 0;
    
    for(id type in self.typesArray)
    {
        //type button
        typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeButton setFrame:CGRectMake(buttonX, 0, typeButtonWeidth, menuScrollHeight)];
        [typeButton setTitle:type forState:UIControlStateNormal];
        [typeButton setTitleColor:LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [typeButton setBackgroundColor:[UIColor clearColor]];
        [typeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeMenu addSubview:typeButton];
        buttonX += offsetWidth;
        buttonX += typeButton.width;
        [typeButton setTag:initFlag+i];
        [self.typeButtonsArray addObject:typeButton];
        
        //goods view
        self.goodsScroll = [[GoodsListView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, goodsListHeight)];
        [self.goodsListView addSubview:self.goodsScroll];
        
        NSArray *labelsArray = [[TypesUtil shareTypesUtil] getGoodsWithType:type];
        NSString *labelColor = [[TypesUtil shareTypesUtil] getColorWithKey:type];
        
        NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
        Goods *goods = nil;
        for(NSString *name in labelsArray)
        {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Goods" inManagedObjectContext:self.coreData.context];
            goods = [[Goods alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
            [goods setName:name];
            [goods setColor:labelColor];
            [goodsArray addObject:goods];
        }
        
        CGSize contentSize =[self makeLabelWithLabelsArray:goodsArray fromView:self.goodsScroll withDWTagList:self.tagList  withFromViewType:FromViewTypeList];
        
        [self.goodsScroll setContentSize:contentSize];
        [self.goodsScroll setPagingEnabled:NO];
        [self.goodsScroll setShowsVerticalScrollIndicator:YES];

        i++;
    }
    [self.typeMenu setContentSize:CGSizeMake(buttonX, menuScrollHeight)];
    [self.typeMenu setContentOffset:CGPointZero];
    [self.typeMenu setDecelerationRate:0.2];
    [self.typeMenu setShowsHorizontalScrollIndicator:NO];
    [self.triangleImageView.layer setAnchorPoint:CGPointZero];
    [self.triangleImageView.layer setPosition:CGPointMake((typeButtonWeidth/2)+(0*(offsetWidth+typeButtonWeidth)-triangleHeight/2), self.triangleImageView.frame.origin.y)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---- 定时器

- (void)blockFiliker
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.blockTopView setAlpha:0.5];
        [self.blockBottomView setAlpha:0.5];
    } completion:^(BOOL done){
        [UIView animateWithDuration:2.0 animations:^{
            [self.blockTopView setAlpha:0.9];
            [self.blockBottomView setAlpha:0.9];
        }];
    }];
}

- (void)hideDescription
{
    [UIView animateWithDuration:0.1 animations:^{
        self.orderDescription.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.bagDescription.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL done){
        [UIView animateWithDuration:0.5 animations:^{
            self.orderDescription.transform = CGAffineTransformMakeScale(0.0, 0.0);
            self.bagDescription.transform = CGAffineTransformMakeScale(0.0, 0.0);
            
            [self.orderDescription setAlpha:0.6];
            [self.bagDescription setAlpha:0.6];
            
            self.orderNumber = [[UILabel alloc] initWithFrame:self.orderRect];
            self.bagNumber = [[UILabel alloc] initWithFrame:self.bagRect];
            
            UIFont *descriptionFont = [UIFont systemFontOfSize:59];
            [self.orderNumber setFont:descriptionFont];
            [self.bagNumber setFont:descriptionFont];
            
            
            [self.orderNumber setTextColor:[UIColor whiteColor]];
            [self.bagNumber setTextColor:[UIColor whiteColor]];
            
            [self.orderNumber setTextAlignment:NSTextAlignmentCenter];
            [self.bagNumber setTextAlignment:NSTextAlignmentCenter];
            
            [self.orderNumber setBackgroundColor:[UIColor clearColor]];
            [self.bagNumber setBackgroundColor:[UIColor clearColor]];
            
            [self.orderNumber setText:[NSString stringWithFormat:@"%d", [self.suitcase.outsideNumber intValue],nil]];
            [self.bagNumber setText:[NSString stringWithFormat:@"%d", [self.suitcase.insideNumber intValue],nil]];
            
            [self.view bringSubviewToFront:self.orderNumber];
            [self.view bringSubviewToFront:self.bagNumber];
            
            [self.view addSubview:self.orderNumber];
            [self.view addSubview:self.bagNumber];

            
        } completion:^(BOOL done){
            
            [UIView animateWithDuration:0.6 animations:^{
                self.orderNumber.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.bagNumber.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL done){
                self.orderNumber.transform = CGAffineTransformMakeScale(0.0, 0.0);
                self.bagNumber.transform = CGAffineTransformMakeScale(0.0, 0.0);
                
                [self.orderNumber removeFromSuperview];
                [self.bagNumber removeFromSuperview];
                
                self.orderNumber = nil;
                self.bagNumber = nil;
                
                [self.bigBlock removeFromSuperview];
                self.bigBlock = nil;
            }];
            
            [self.orderDescription removeFromSuperview];
            [self.bagDescription removeFromSuperview];
            
            self.orderDescription = nil;
            self.bagDescription = nil;
        }];
    }];
}

- (void)cornerFlicker
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.cornerAddImageView setAlpha:0.2];
        [self.cornerMenuImageView setAlpha:1.0];
    } completion:^(BOOL done){
        [UIView animateWithDuration:1.0 animations:^{
            [self.cornerAddImageView setAlpha:1.0];
            [self.cornerMenuImageView setAlpha:0.2];
        }];
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.triangleImageView setAlpha:0.4];
    } completion:^(BOOL done){
        [UIView animateWithDuration:1.0 animations:^{
            [self.triangleImageView setAlpha:1.0];
        }];
    }];
}

#pragma mark --- 动画

// 完成准备
- (void)finish
{
    UIImage *image = [UIImage imageNamed:@"finish"];
    self.finishImageView = [[UIImageView alloc] initWithImage:image];
    [self.finishImageView setBounds:CGRectMake(0, 0, 300, 160)];
    [self.finishImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.finishImageView.layer setPosition:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+self.finishImageView.height/2)];
    [KEY_WINDOW addSubview:self.finishImageView];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.finishImageView.layer setPosition:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    } completion:^(BOOL done){
        [UIView animateWithDuration:2.0 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.finishImageView setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
             [self.finishImageView setAlpha:0.0];
             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         } completion:^(BOOL done){
         }];
    }];
}

//nav弹出
- (void)navPopup
{
    if(!self.bigBlock)
    {
        self.bigBlock = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        [self.bigBlock setBackgroundColor:[UIColor blackColor]];
        [self.bigBlock setAlpha:0.8];
        
        [self.view addSubview:self.bigBlock];
    }
    
    [self.bigBlock setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [self.nav.layer setPosition:CGPointMake(0, [self getScreenHeight] - SUITCASE_NAV_HEIGHT)];
        [self.cornerButton.layer setPosition:CGPointMake(-self.cornerButton.height, [self getScreenHeight] - self.cornerButton.height)];
        
        [self.view addSubview:self.nav];
    }];
}

//select view弹出
- (void)selectViewPopup
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.selectView.layer setPosition:CGPointMake(0, [self getScreenHeight]/2)];
        [self.cornerLeftButton.layer setPosition:CGPointMake(SCREEN_WIDTH, [self getScreenHeight] - self.cornerLeftButton.height)];
        [self.closeTypesList setAlpha:1.0];
        [self.closeTypesList setHidden:NO];
        [self.keyBored setAlpha:1.0];
        [self.keyBored setHidden:NO];
    }];
}

//nav收回
- (void)navPushBack
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.nav.layer setPosition:CGPointMake(SCREEN_WIDTH, [self getScreenHeight] - SUITCASE_NAV_HEIGHT)];
        [self.cornerButton.layer setPosition:CGPointMake(SCREEN_WIDTH - self.cornerButton.height, [self getScreenHeight] - self.cornerButton.height)];
        
        [self.selectView.layer setPosition:CGPointMake(-SCREEN_WIDTH, [self getScreenHeight] - SUITCASE_NAV_HEIGHT)];
        [self.closeTypesList setAlpha:0.0];
        [self.closeTypesList setHidden:YES];
        [self.keyBored setAlpha:0.0];
        [self.keyBored setHidden:YES];
        
        [self.cornerLeftButton.layer setPosition:CGPointMake(0, [self getScreenHeight] - self.cornerButton.height)];
        
        [self.bigBlock removeFromSuperview];
        self.bigBlock = nil;
        [self.scoreBlockButton removeFromSuperview];
        self.scoreBlockButton = nil;
    }];
}

- (void)closeSelectView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.selectView.layer setPosition:CGPointMake(-SCREEN_WIDTH, [self getScreenHeight] - SUITCASE_NAV_HEIGHT)];
        [self.closeTypesList setAlpha:0.0];
        [self.closeTypesList setHidden:YES];
        [self.keyBored setAlpha:0.0];
        [self.keyBored setHidden:YES];
        [self.cornerLeftButton.layer setPosition:CGPointMake(0, [self getScreenHeight] - self.cornerButton.height)];
    }];
}

- (void)openKeyBored
{
    if(!self.bigBlock)
    {
        self.bigBlock = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        [self.bigBlock setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.9]];
    }
    [self.bigBlock setHidden:NO];
    [self.view addSubview:self.bigBlock];
    if(!self.textField)
    {
        int textWidth = 280;
        self.textField = [[SuitcaseTextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - textWidth)/2, [self getScreenHeight]/2/2, textWidth, 38)];
        [self.textField setBackgroundColor:[UIColor whiteColor]];
        [self.textField.layer setCornerRadius:10];
        [self.textField.layer setBorderColor:GREEN_COLOR.CGColor];
        [self.textField.layer setBorderWidth:3.0];
        [self.textField setDelegate:self];
        [self.textField setReturnKeyType:UIReturnKeyDone];
    }else
    {
        [self.textField setText:nil];
    }
    [self.bigBlock addSubview:self.textField];
    [self.textField becomeFirstResponder];
}

#pragma mark --- uitext field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.text == nil || [textField.text isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入新增物品" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.view addSubview:alert];
        [alert show];
        return NO;
    }
    
    if(textField.text.length > 20)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"物品长度不能超过20字" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [self.view addSubview:alert];
        [alert show];
        return NO;
    }
    [self.bigBlock setHidden:YES];
    
    // core data
    [self addObjectWithSuitcase:self.suitcase withName:textField.text withColor:@"18a69a"];
    //tag
    CGSize contentSize = [self refreshOrderDWTagList];
    [self.textField resignFirstResponder];
    [self.order setContentSize:contentSize];
    int offsetY = self.order.contentSize.height-self.order.height;
    [self.order setContentOffset:CGPointMake(0, offsetY < 0 ? 0 : offsetY)];
    
    [textField removeFromSuperview];
    textField.text = nil;
    return YES;
}

#pragma mark --- 按钮
    
//选择滚动条上的类
    - (void) selectType:(id)sender
{
    if(!sender)
    {
        return;
    }
    
    UIButton *selectedButton = (UIButton *)sender;
    int needOffsetX = selectedButton.center.x;
    int triangleOffsetX = 0;
    if (needOffsetX < SCREEN_WIDTH/2)
    {
        needOffsetX = 0;
        triangleOffsetX = (typeButtonWeidth/2)+(0*(offsetWidth+typeButtonWeidth)-triangleHeight/2);
    }
    else if (needOffsetX > (self.typeMenu.contentSize.width - (SCREEN_WIDTH/2)))
     {
         needOffsetX = self.typeMenu.contentSize.width - SCREEN_WIDTH;
         triangleOffsetX = (typeButtonWeidth/2)+((self.typesArray.count-1)*(offsetWidth+typeButtonWeidth)-triangleHeight/2);
     }
     else
     {
         needOffsetX = selectedButton.center.x - (SCREEN_WIDTH/2);
         triangleOffsetX = (typeButtonWeidth/2)+((selectedButton.tag-initFlag)*(offsetWidth+typeButtonWeidth)-triangleHeight/2);
     }
    [UIView animateWithDuration:0.2 animations:^{
        [self.typeMenu setContentOffset:CGPointMake(needOffsetX, 0)];
        [self.triangleImageView.layer setPosition:CGPointMake(triangleOffsetX, self.triangleImageView.frame.origin.y)];
    } completion:^(BOOL done){
        
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.goodsListView setContentOffset:CGPointMake((selectedButton.tag-initFlag)*SCREEN_WIDTH, 0)];
    }];
}

- (void) cornerButtonPressDown
{
    [self navPopup];
}

- (void) cornerLeftButtonPressDown
{
    [self selectViewPopup];
}

#pragma mark --- 手指

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 过滤掉UIButton，也可以是其他类型
    if ( [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    if ( [touch.view isKindOfClass:[UITextView class]])
    {
        return NO;
    }
    if ( [touch.view isKindOfClass:[GoodsListView class]])
    {
        return NO;
    }
    if ( [touch.view isKindOfClass:[DWTagList class]])
    {
        return NO;
    }
    if ( [touch.view isKindOfClass:[UITypeView class]])
    {
        return NO;
    }
    if ( [touch.view isKindOfClass:[UILabel class]])
    {
        return NO;
    }
    
    return YES;
}

- (void)handleSingleFingerEvent
{
    if([self isNavDisplay] || [self isSelectViewDisplay] )
    {
        [self navPushBack];
    }
}


#pragma mark --- 判断
- (BOOL)isNavDisplay
{
    if(self.cornerButton.frame.origin.x == SCREEN_WIDTH - self.cornerButton.height)
        return NO;
    else
        return YES;
}

- (BOOL)isSelectViewDisplay
{
    if(self.cornerLeftButton.frame.origin.x == 0)
        return NO;
    else
        return YES;
}

- (NSInteger)getScreenHeight
{
    if(IOS_VERSION >= 7.0)
        return SCREEN_HEIGHT;
    else
        return APPLICATION_FRAME.size.height;
}

#pragma mark --- scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.goodsListView)
    {
        int currentIndex = self.goodsListView.contentOffset.x/SCREEN_WIDTH;
        UIButton *currentButton = [self.typeButtonsArray objectAtIndex:currentIndex];
        [self selectType:currentButton];
    }
}

#pragma mark --- 标签
- (CGSize)makeLabelWithLabelsArray:(NSArray *)labelsArray fromView:(UIScrollView *)fromView withDWTagList:(DWTagList *) dWTagList withFromViewType:(FromViewType)fromViewType
{
    for(id view in [fromView subviews])
    {
        [view removeFromSuperview];
    }
    
    dWTagList = [[DWTagList alloc] initWithFrame:CGRectMake(15.0f, 25.0f, 280.0f, 900.0f) withDelegate:self withFromViewType:fromViewType];
    [dWTagList setTags:labelsArray];
    
    [fromView addSubview:dWTagList];
    
    CGSize contentSize = [dWTagList fittedSize];
    contentSize.width = SCREEN_WIDTH;
    [fromView setContentSize:contentSize];
    [fromView setPagingEnabled:NO];
    [fromView setShowsVerticalScrollIndicator:YES];
    [dWTagList setSize:contentSize];
    return  contentSize;
}

#pragma mark --- DWTagList Delegate

- (void)itemMoving:(FromViewType)fromViewType
{
    if(self.titleNav.frame.origin.y >= 0)
    {
        return;
    }
    [self titleNavPopIn];
}

- (void)itemOnOrderView:(FromViewType)fromViewType
{
    if(fromViewType == FromViewTypeOrder)
    {
        return;
    }
    
    if(!self.blockTopView)
    {
        //timer
        if(!self.orderTimer)
        {
            self.orderTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(blockFiliker) userInfo:nil repeats:YES];
        }
        
        self.blockTopView =  [[UIView alloc] init];
        [self.blockTopView setBounds:self.order.frame];
        [self.blockTopView setOrigin:CGPointZero];
        [self.blockTopView setBackgroundColor:[UIColor grayColor]];
        [self.blockTopView setAlpha:0.9];
        
        UIFont *font =[UIFont systemFontOfSize:20];
        NSString *addToOrderString = @"添加到清单";
        CGSize sizeOfAddToOrderString = [addToOrderString sizeWithFont:font];
        self.addToOrderLabel = [[UILabel alloc] init];
        [self.addToOrderLabel setTextColor:[UIColor whiteColor]];
        [self.addToOrderLabel setFont:font];
        [self.addToOrderLabel setSize:sizeOfAddToOrderString];
        [self.addToOrderLabel setOrigin:CGPointMake((SCREEN_WIDTH-self.addToOrderLabel.width)/2, self.order.height-self.addToOrderLabel.height)];
        [self.addToOrderLabel setText:addToOrderString];
        [self.addToOrderLabel setTextAlignment:NSTextAlignmentCenter];
        [self.addToOrderLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.blockTopView addSubview:self.addToOrderLabel];
        [self.view addSubview:self.blockTopView];
    }

}

- (void)itemOnBagView:(FromViewType)fromViewType
{
    if(fromViewType == FromViewTypeBag)
    {
        return;
    }
    
    
    if(self.selectView.frame.origin.x < 0)
    {
        if(!self.blockBottomView)
        {
            //timer
            if(!self.orderTimer)
            {
                self.orderTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(blockFiliker) userInfo:nil repeats:YES];
            }
            
            self.blockBottomView =  [[UIView alloc] init];
            [self.blockBottomView setBounds:CGRectMake(0, 0, self.bag.width, self.bag.height-5)];
            [self.blockBottomView setOrigin:CGPointMake(0, self.bag.frame.origin.y+5)];
            [self.blockBottomView setBackgroundColor:[UIColor grayColor]];
            [self.blockBottomView setAlpha:0.9];
            
            UIFont *font =[UIFont systemFontOfSize:20];
            NSString *addToBagString = @"添加到背包";
            CGSize sizeOfAddToBagString = [addToBagString sizeWithFont:font];
            self.addToBagLabel = [[UILabel alloc] init];
            [self.addToBagLabel setTextColor:[UIColor whiteColor]];
            [self.addToBagLabel setFont:font];
            [self.addToBagLabel setSize:sizeOfAddToBagString];
            [self.addToBagLabel setOrigin:CGPointMake((SCREEN_WIDTH - sizeOfAddToBagString.width)/2, self.blockBottomView.center.y - ([self getScreenHeight]/2))];
            [self.addToBagLabel setText:addToBagString];
            [self.addToBagLabel setTextAlignment:NSTextAlignmentCenter];
            [self.addToBagLabel setBackgroundColor:[UIColor clearColor]];
            
            [self.blockBottomView addSubview:self.addToBagLabel];
            [self.view addSubview:self.blockBottomView];
        }
        
        //core data

    }
    else
    {
    
    }
}

- (void)itemOnTaobao:(FromViewType)fromViewType
{
    [self.bigTaobaoView setBackgroundColor:DARK_GRAY_COLOR];
}

- (void)itemOnDelete:(FromViewType)fromViewType
{
    [self.bigDeleteView setBackgroundColor:DARK_GRAY_COLOR];
}

- (void)itemOverOrderView:(FromViewType)fromViewType
{
    [self.addToOrderLabel removeFromSuperview];
    [self.blockTopView removeFromSuperview];
    self.addToOrderLabel = nil;
    self.blockTopView = nil;
}

- (void)itemOverTaobao:(FromViewType)fromViewType
{
    [self.bigTaobaoView setBackgroundColor:DARK_BLUE_COLOR];
}

- (void)itemOverDelete:(FromViewType)fromViewType
{
    [self.bigDeleteView setBackgroundColor:DARK_BLUE_COLOR];
}

- (void)itemEndInDeleteWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType
{
    [self removeObject:goods];
    if(fromViewType == FromViewTypeOrder)
    {
        [self refreshOrderDWTagList];
        
        if(self.orderArray.count <= 0)
        {
            [self finish];
        }
    }
    else if(fromViewType == FromViewTypeBag)
    {
        [self refreshBagDWTagList];
    }
    
}

- (FromViewType)itemEndInBagWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType
{
    //core data
    if(fromViewType == FromViewTypeOrder && self.cornerLeftButton.origin.x == 0)
    {
        [goods setStatus:[NSNumber numberWithInt:GoodsStatusBag]];
        [goods setCreate:[NSDate date]];
        [self updateObjectWithGoods:goods];
        [self refreshOrderAndBagDWTagList];
        float offsetY = self.bag.contentSize.height-self.bag.height;
        [self.bag setContentOffset:CGPointMake(0, (offsetY > 0)?offsetY:0) animated:YES];
        
        if(self.orderArray.count <= 0)
        {
            [self finish];
        }
        
        return FromViewTypeBag;
    }
    
    return FromViewTypeList;
}


- (void)itemEndInOrderViewWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType
{
    if(fromViewType == FromViewTypeOrder)
    {
        return;
    }
    
    //core data
    if(fromViewType == FromViewTypeList)
    {
        [goods setStatus:[NSNumber numberWithInt:GoodsStatusOrder]];
        [goods setCreate:[NSDate date]];
        [self addObjectWithGoods:goods];
        [self refreshOrderDWTagList];
    }
    else if(fromViewType == FromViewTypeBag)
    {
        [goods setStatus:[NSNumber numberWithInt:GoodsStatusOrder]];
        [goods setCreate:[NSDate date]];
        [self updateObjectWithGoods:goods];
        [self refreshOrderAndBagDWTagList];
    }
    float offsetY = self.order.contentSize.height-self.order.height;
    [self.order setContentOffset:CGPointMake(0, (offsetY > 0)?offsetY:0) animated:YES];
}

- (void)itemEndInTaobaoWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType
{
    NSString *name = goods.name;
    NSString *colorString = goods.color;
    if([colorString isEqualToString:@"7023b1"] || [colorString isEqualToString:@"9161ce"])
    {
        if(![[NSString stringWithFormat: @"%C",[name characterAtIndex:0],nil] isEqualToString:@"女"])
        {
            name = [NSString stringWithFormat:@"女士%@",name,nil];
        }
    }
    else if ([colorString isEqualToString:@"0f4bc7"] || [colorString isEqualToString:@"1b8ef8"])
    {
        if(![[NSString stringWithFormat: @"%C",[name characterAtIndex:0],nil] isEqualToString:@"男"])
        {
            name = [NSString stringWithFormat:@"男士%@",name,nil];
        }
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://r.m.taobao.com/s?p=mm_47140496_4244575_14406489&q=%@",name,nil];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:webStringURL];
    
    self.webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:URL];
    self.webBrowser.showProgress = YES;
    self.webBrowser.allowSharing = YES;
    
    UINavigationController *webBrowserNC = [[UINavigationController alloc] initWithRootViewController:self.webBrowser];
    
    [self presentViewController:webBrowserNC animated:YES completion:NULL];
}

- (void)itemEnded:(FromViewType)fromViewType
{
    [self titleNavHidden];
    [self.blockTopView removeFromSuperview];
    [self.blockBottomView removeFromSuperview];
    self.blockTopView = nil;
    self.blockBottomView = nil;
    [self.orderTimer invalidate];
}

#pragma mark --- title nav
-(void)titleNavHidden
{
    //屏幕顶部 nav
    if(self.titleNav.center.y == 0)
    {
        [KEY_WINDOW bringSubviewToFront:self.titleNav];
        [UIView animateWithDuration:0.2 animations:^{
            
            if(IOS_VERSION >= 7.0)
            {
                [self.titleNav.layer setPosition:CGPointMake(0, -(TITLE_NAV_HEIGHT+20))];
            }
            else
            {
                [self.titleNav.layer setPosition:CGPointMake(0, -TITLE_NAV_HEIGHT)];
            }
            [self.order.layer setPosition:CGPointZero];
        } completion:^(BOOL done){}];
    }
}

//屏幕顶部 nav 显示
-(void)titleNavPopIn
{
    //屏幕顶部 nav
    if(self.titleNav.center.y < 0)
    {
        [KEY_WINDOW bringSubviewToFront:self.titleNav];
        [UIView animateWithDuration:0.2 animations:^{
            [self.titleNav.layer setPosition:CGPointMake(0, 0)];
            if(IOS_VERSION >= 7.0)
                [self.order.layer setPosition:CGPointMake(0, TITLE_NAV_HEIGHT+20)];
            else
                [self.order.layer setPosition:CGPointMake(0, TITLE_NAV_HEIGHT-20)];
        } completion:^(BOOL done){}];
    }
}

#pragma mark -- core data

- (NSDate *) dateFromString: (NSString *) aString
{
	// Return a date from a string
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSDate *date = [formatter dateFromString:aString];
	return date;
}

- (Goods *) addObjectWithSuitcase:(Suitcase *) suitcase withName:(NSString *)name withColor:(NSString *)color
{
	Goods *goods = (Goods *)[NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:self.coreData.context];
    [goods setSuitcase:suitcase];
    [goods setName:name];
    [goods setStatus:[NSNumber numberWithInt:GoodsStatusOrder]];
    [goods setType:suitcase.typeId];
    [goods setUseWeb:[NSNumber numberWithInt:UsedWebNo]];
    [goods setPutIn:nil];
    [goods setCreate:[NSDate date]];
    [goods setImageUrl:nil];
    [goods setColor:color];
    
    [self.suitcase setOutsideNumber:[NSNumber numberWithInt:([self.suitcase.outsideNumber intValue]+1)]];
    
    // Save the data
	NSError *error;
	if (![self.coreData.context save:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        return goods;
    }
    return  nil;
}

- (Goods *) updateObjectWithGoods:(Goods *)goods
{
    NSError *error = nil;
    
    
    if(goods.status == [NSNumber numberWithInt:GoodsStatusOrder])
    {
        [self.suitcase setOutsideNumber:[NSNumber numberWithInt:([self.suitcase.outsideNumber intValue]+1)]];
        [self.suitcase setInsideNumber:[NSNumber numberWithInt:([self.suitcase.insideNumber intValue]-1)]];
    }
    else if (goods.status == [NSNumber numberWithInt:GoodsStatusBag])
    {
        [self.suitcase setInsideNumber:[NSNumber numberWithInt:([self.suitcase.insideNumber intValue]+1)]];
        [self.suitcase setOutsideNumber:[NSNumber numberWithInt:([self.suitcase.outsideNumber intValue]-1)]];
    }
    
    if (![self.coreData.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSLog(@"update success");
    return  goods;
}

- (Goods *) addObjectWithGoods:(Goods *)goods
{
	Goods *newgoods = (Goods *)[NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:self.coreData.context];

    [newgoods setSuitcase:self.suitcase];
    [newgoods setName:goods.name];
    [newgoods setStatus:goods.status];
    [newgoods setType:goods.suitcase.typeId];
    [newgoods setUseWeb:goods.useWeb];
    [newgoods setPutIn:nil];
    [newgoods setCreate:goods.create];
    [newgoods setImageUrl:nil];
    [newgoods setColor:goods.color];
    
    if(newgoods.status == [NSNumber numberWithInt:GoodsStatusOrder])
    {
        [self.suitcase setOutsideNumber:[NSNumber numberWithInt:([self.suitcase.outsideNumber intValue]+1)]];
    }
    else if (newgoods.status == [NSNumber numberWithInt:GoodsStatusBag])
    {
        [self.suitcase setInsideNumber:[NSNumber numberWithInt:([self.suitcase.insideNumber intValue]+1)]];
    }

    // Save the data
	NSError *error;
	if (![self.coreData.context save:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        return goods;
    }
    return  nil;
}


- (void) fetchOrderObjects
{
	// Create a basic fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Goods" inManagedObjectContext:self.coreData.context]];
	
	// Add a sort descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create" ascending:YES selector:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suitcase=%@ && status=%@",self.suitcase,[NSNumber numberWithInt:GoodsStatusOrder]];//查询条件
    
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	[fetchRequest setPredicate:predicate];
	// Init the fetched results controller
	NSError *error;
	self.orderArray = [NSMutableArray arrayWithArray:[self.coreData.context executeFetchRequest:fetchRequest error:&error]];
	if (!self.orderArray)
        NSLog(@"Error: %@", [error localizedDescription]);
}

- (void) fetchBagObjects
{
	// Create a basic fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Goods" inManagedObjectContext:self.coreData.context]];
	
	// Add a sort descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create" ascending:YES selector:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suitcase=%@ && status=%@",self.suitcase,[NSNumber numberWithInt:GoodsStatusBag]];//查询条件
    
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	[fetchRequest setPredicate:predicate];
	
	// Init the fetched results controller
	NSError *error;
    self.bagArray = [NSMutableArray arrayWithArray:[self.coreData.context executeFetchRequest:fetchRequest error:&error]];
	if (!self.bagArray)
        NSLog(@"Error: %@", [error localizedDescription]);
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"Controller content did change");
}

- (void) removeObject:(Goods *)goods
{
    
    if(goods.status == [NSNumber numberWithInt:GoodsStatusOrder])
    {
        [self.suitcase setOutsideNumber:[NSNumber numberWithInt:([self.suitcase.outsideNumber intValue]-1)]];
    }
    else if (goods.status == [NSNumber numberWithInt:GoodsStatusBag])
    {
        [self.suitcase setInsideNumber:[NSNumber numberWithInt:([self.suitcase.insideNumber intValue]-1)]];
    }
    
	NSError *error = nil;
	[self.coreData.context deleteObject:goods];
	// save
	if (![self.coreData.context save:&error]) NSLog(@"Error: %@ (%@)", [error localizedDescription], [error userInfo]);
	[self fetchOrderObjects];
    [self fetchBagObjects];
}


#pragma mark ---- 加载数据
- (void)loadData
{
    [self fetchOrderObjects];
    [self fetchBagObjects];
}

#pragma mark ---- DWTagList 刷新

- (void)refreshOrderAndBagDWTagList
{
    //DWTagList order
    [self fetchOrderObjects];
    [self makeLabelWithLabelsArray:self.orderArray fromView:self.order withDWTagList:self.tagListOrder  withFromViewType:FromViewTypeOrder];
    
    //DWTagList bag
    [self fetchBagObjects];
    [self makeLabelWithLabelsArray:self.bagArray fromView:self.bag withDWTagList:self.tagListBag  withFromViewType:FromViewTypeBag];
}

- (CGSize)refreshOrderDWTagList
{
    //DWTagList order
    [self fetchOrderObjects];
    return [self makeLabelWithLabelsArray:self.orderArray fromView:self.order withDWTagList:self.tagListOrder  withFromViewType:FromViewTypeOrder];
}

- (void)refreshBagDWTagList
{
    //DWTagList bag
    [self fetchBagObjects];
    [self makeLabelWithLabelsArray:self.bagArray fromView:self.bag withDWTagList:self.tagListBag  withFromViewType:FromViewTypeBag];
}

#pragma mark --- 菜单按钮
- (void)commonUse
{
    NSArray *commonArray = [[TypesUtil shareTypesUtil] getCommonGoods];
    
    if(!self.commonAlert)
    {
        self.commonAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"将%d项常用物品添加到准备清单？",commonArray.count,nil] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    [self.commonAlert show];
}

- (void)addType
{
    NSString *urlString = @"http://lvyou.baidu.com";
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:webStringURL];
    
    self.webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:URL];
    self.webBrowser.showProgress = YES;
    self.webBrowser.allowSharing = YES;
    
    UINavigationController *webBrowserNC = [[UINavigationController alloc] initWithRootViewController:self.webBrowser];
    
    [self presentViewController:webBrowserNC animated:YES completion:NULL];
}

- (void)alert
{
    int closeButtonHeight = 60;
    if(!self.alertView)
    {
        self.alertView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        [self.alertView setBackgroundColor:[UIColor clearColor]];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundColor:GREEN_COLOR];
        [closeButton setFrame:CGRectMake(0, [self getScreenHeight]-closeButtonHeight, SCREEN_WIDTH, closeButtonHeight)];
        [closeButton addTarget:self action:@selector(closeAlertText) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:@"确定" forState:UIControlStateNormal];
        [closeButton setAlpha:1.0];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.alertView addSubview:closeButton];
    }
    [self.alertView setHidden:NO];
    if(!self.alertScroll)
    {
        self.alertScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,[self getScreenHeight]-closeButtonHeight)];
        [self.alertScroll setAlpha:0.8];
        [self.alertView setBackgroundColor:[UIColor blackColor]];
    }
    [self.alertView addSubview:self.alertScroll];
    [self.view addSubview:self.alertView];
    
    for(id text in [self.alertScroll subviews])
    {
        [text removeFromSuperview];
    }
    
    UITextView *text = [[UITextView alloc] initWithFrame:self.alertScroll.frame];
    [text setOrigin:CGPointZero];
    [text setAlpha:0.8];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setFont:[UIFont systemFontOfSize:20]];
    [text setTextColor:[UIColor whiteColor]];
    [text setTextAlignment:NSTextAlignmentLeft];
    [text setAutoresizesSubviews:YES];
    [text setEditable:NO];
    NSString *typeName = (NSString *)[[[TypesUtil shareTypesUtil] getAllTypes] objectAtIndex:[self.suitcase.typeId intValue]];
    NSString *textContent = (NSString *)[[TypesUtil shareTypesUtil] getTextWithKey:typeName];
    [text setText:textContent];
    [self.alertScroll addSubview:text];
    [self.alertView setAlpha:0.0];
    [self.alertView setTransform:CGAffineTransformMakeScale(1.8, 1.8)];
    [self.alertView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.alertView setAlpha:1.0];
        [self.alertView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }];
}

- (void)closeAlertText
{
    [UIView animateWithDuration:1.0 animations:^{
        [self.alertView setAlpha:0.0];
        [self.alertView setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
    } completion:^(BOOL done){
        [self.alertView setHidden:YES];
    }];
}

- (void)taobao
{
    NSString *urlString = @"http://r.m.taobao.com/s?p=mm_47140496_4244575_14406489&q=";
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:webStringURL];
    
    self.webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:URL];
    self.webBrowser.showProgress = YES;
    self.webBrowser.allowSharing = YES;
    
    UINavigationController *webBrowserNC = [[UINavigationController alloc] initWithRootViewController:self.webBrowser];
    
    [self presentViewController:webBrowserNC animated:YES completion:NULL];
}


- (void)score
{
    int scoreHeight = SCREEN_HEIGHT - 180;
    int scoreWeidth = SCREEN_WIDTH - 60;
    int closeButtonHeight = 50;
    if(!self.scoreBlockButton)
    {
        self.scoreBlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scoreBlockButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.4]];
        [self.scoreBlockButton setFrame:self.bigBlock.frame];
        [self.scoreBlockButton addTarget:self action:@selector(closeScoreView) forControlEvents:UIControlEventTouchUpInside];
        [self.scoreView setUserInteractionEnabled:NO];
        [self.view addSubview:self.scoreBlockButton];
        
        self.scoreView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-scoreWeidth)/2, ([self getScreenHeight]-scoreHeight)/2, scoreWeidth, scoreHeight)];
        [self.scoreView setBackgroundColor:LIGHT_GRAY_COLOR];
        [self.scoreView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.scoreView.layer setCornerRadius:10];
        [self.scoreView setClipsToBounds:YES];
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, scoreWeidth, 40)];
        [field setTextAlignment:NSTextAlignmentCenter];
        [field setEnabled:NO];
        [field setTextColor:[UIColor blackColor]];
        [field setText:@"您的准备清单得分"];
        [field setFont:[UIFont systemFontOfSize:20]];
        [self.scoreView addSubview:field];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(0, scoreHeight - closeButtonHeight, scoreWeidth, closeButtonHeight)];
        [closeButton setBackgroundColor:GREEN_COLOR];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setTitle:@"确定" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeScoreView) forControlEvents:UIControlEventTouchUpInside];
        [self.scoreView addSubview:closeButton];
        
        [self.scoreBlockButton addSubview:self.scoreView];
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, field.origin.y+field.height, self.scoreView.width, 20)];;
        [self.summaryLabel setText:@""];
        [self.summaryLabel setTextAlignment:NSTextAlignmentCenter];
        [self.summaryLabel setFont:[UIFont systemFontOfSize:12]];
        [self.summaryLabel setTextColor:GREEN_COLOR];
        [self.summaryLabel setBackgroundColor:[UIColor clearColor]];
        [self.scoreView addSubview:self.summaryLabel];
    }
    [self.summaryLabel setText:@""];
    
    if(self.scoreText)
    {
        [self.scoreText removeFromSuperview];
        self.scoreText = nil;
    };
    
    NSString *scoreString = @"0";
    UIFont *scoreFont = [UIFont systemFontOfSize:50];
    CGSize scoreSize = [scoreString sizeWithFont:scoreFont constrainedToSize:CGSizeMake(scoreWeidth, scoreHeight) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect scoreRect = CGRectMake(0, (scoreHeight - scoreSize.height)/2, scoreWeidth, scoreSize.height);
    self.scoreText = [[UITextField alloc] initWithFrame:scoreRect];
    [self.scoreText setText:scoreString];
    [self.scoreText setFont:scoreFont];
    [self.scoreText setEnabled:NO];
    [self.scoreText setTextColor:GREEN_COLOR];
    [self.scoreText setTextAlignment:NSTextAlignmentCenter];
    [self.scoreText setBackgroundColor:[UIColor clearColor]];
    [self.scoreText setTag:TAG_SCORE];
    
    [self.scoreBlockButton setHidden:NO];
    [self.scoreView setAlpha:0.0];
    [self.scoreView setTransform:CGAffineTransformMakeScale(1.8, 1.8)];
    
    [UIView animateWithDuration:1.0 animations:^(){
        [self.scoreView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        [self.scoreView setAlpha:1.0];
        [self.scoreView addSubview:self.scoreText];
        [NSThread detachNewThreadSelector:@selector(calculateScore) toTarget:self withObject:nil];
    } completion:^(BOOL done){
        
        NSString *summary = @"";
        if(self.scoreInt >= 0 && self.scoreInt <=200)
        {
            summary = @"行李箱好饿 ~.~";
        }
        else if(self.scoreInt <= 400 && self.scoreInt >200)
        {
            summary = @"行李箱饱了 ^_^";
        }
        else
        {
            summary = @"行李箱撑爆了 @_@";
        }
        [self.summaryLabel setText:summary];
    }];
}

- (void)calculateScore
{
    @autoreleasepool {
        
        int score = 0;
        score = (self.orderArray.count*2)+(self.bagArray.count*2);
        
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        for(Goods *goods in self.orderArray)
        {
            BOOL isContained = [colors containsObject:goods.color];
            if(isContained)
            {
                
            }
            else
            {
                [colors addObject:goods.color];
                score += 10;
            }
        }
        for(Goods *goods in self.bagArray)
        {
            BOOL isContained = [colors containsObject:goods.color];
            if(isContained)
            {
                
            }
            else
            {
                [colors addObject:goods.color];
                score += 10;
            }
        }
        self.scoreInt = score;
        for (int i = 0 ; i <= score; i++) {
            sleep(0.9);
            [self performSelectorOnMainThread:@selector(changeScore:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
            sleep(0.9);
        }
    }
}

- (void)changeScore:(NSNumber *) i
{
    @synchronized(i){
        [UIView animateWithDuration:0.45 animations:^{
            [self.scoreText setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
            
        } completion:^(BOOL done){
            [UIView animateWithDuration:0.45 animations:^{
                [self.scoreText setText:[NSString stringWithFormat:@"%d",[i intValue]]];
                [self.scoreText setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            }];
        }];
    }
}

- (void)closeScoreView
{
    [UIView animateWithDuration:0.8 animations:^(){
        [self.scoreView setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
        [self.scoreView setAlpha:0.0];
        [self.scoreBlockButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.0]];
    } completion:^(BOOL done){
        [self.scoreBlockButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.4]];
        [self.scoreBlockButton setHidden:YES];
    }];
}

- (void)deleteAll
{
    if(!self.deleteAllAlert)
    {
        self.deleteAllAlert = [[UIAlertView alloc] initWithTitle:@"将背包中的所有物品移回清单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    [self.deleteAllAlert show];
}

- (void)goBack
{
    [self.delegate goBack];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark --- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView == self.commonAlert)
    {
        if(self.bagArray && buttonIndex == 1)
        {
            NSArray *commonArray = [[TypesUtil shareTypesUtil] getCommonGoods];
            for(NSString *name in commonArray)
            {
                [self addObjectWithSuitcase:self.suitcase withName:name withColor:@"09E6FF"];
            }
            [self refreshOrderDWTagList];
        }
        [self navPushBack];
    }
    
    if(alertView == self.deleteAllAlert)
    {
        if(self.bagArray && buttonIndex == 1)
        {
            for(id goods in self.bagArray)
            {
                [goods setStatus:[NSNumber numberWithInteger:GoodsStatusOrder]];
                [self updateObjectWithGoods:goods];
            }
            [self refreshOrderAndBagDWTagList];
        }
        [self navPushBack];
    }
}

@end
