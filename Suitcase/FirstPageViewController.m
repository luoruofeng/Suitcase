//
//  FirstPageViewController.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-12.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SelectTypeViewController.h"
#import "WXApiObject.h"
#import "DZWebBrowser.h"
#import "ConfigUtil.h"

typedef NS_ENUM (NSInteger, ButtonType) {
    share,
    add,
    about,
    set
};

@interface UIFirstView : UIView
@property (nonatomic,assign) ButtonType buttonType;
@property (nonatomic, strong) UIScrollView *scroll;
@end

@implementation UIFirstView
@synthesize buttonType;
- (id)init
{
    self = [super init];
        if(self)
        {
            [self setBackgroundColor:[UIColor colorWithString:@"18a69a"]];
            [self.layer setBorderColor:[UIColor colorWithString:@"007863"].CGColor];
            if(IOS_VERSION >= 7.0)
            {
                [self.layer setBorderWidth:0.3];
            }
            else
            {
                [self.layer setBorderWidth:1];
            }
            [self setAlpha:0.6];
    }
    return self;
}

@end

@interface FirstPageViewController ()
@property (nonatomic ,strong) NSArray *types;
@property (nonatomic ,strong) UIFirstView *addView;
@property (nonatomic ,strong) UIFirstView *aboutView;
@property (nonatomic ,strong) UIFirstView *shareView;
@property (nonatomic ,strong) UIFirstView *setView;
@property (nonatomic ,strong) UIImageView *addImageView;
@property (nonatomic ,strong) UIScrollView *scroll;
@property (nonatomic ,strong) UIButton *addButton;
@property (nonatomic ,strong) UIButton *shareButton;
@property (nonatomic ,strong) UIButton *setButton;
@property (nonatomic ,strong) UIButton *aboutButton;

@property (nonatomic) BOOL flag;

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation FirstPageViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithScroll:(UIScrollView *)scroll
{
    self = [self init];
    if (self) {
        self.scroll = scroll;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Types" ofType:@"plist"];
    self.types = [NSArray arrayWithContentsOfFile:path];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(flickerAddView) userInfo:nil repeats:YES];
    
    self.flag = false;


    
    self.addView = [[UIFirstView alloc] init];
    self.shareView = [[UIFirstView alloc] init];
    self.setView = [[UIFirstView alloc] init];
    self.aboutView = [[UIFirstView alloc] init];
    
    [self.addView setButtonType:add];
    [self.shareView setButtonType:share];
    [self.setView setButtonType:set];
    [self.aboutView setButtonType:about];
    
    [self.addView setScroll:self.scroll];
    [self.shareView setScroll:self.scroll];
    [self.setView setScroll:self.scroll];
    [self.aboutView setScroll:self.scroll];
    
    CGFloat viewWidth = 240;
    CGFloat viewHeight = 240;
    CGFloat smallViewWidth = viewWidth / 3;
    CGFloat smallViewHeight = viewHeight / 3;
    CGFloat totleViewWidth = viewWidth;
    CGFloat totleViewHeight = viewHeight + smallViewHeight;
    
    if(SCREEN_HEIGHT == 480)
    {
        viewWidth = 210;
        viewHeight = 210;
        smallViewWidth = viewWidth / 3;
        smallViewHeight = viewHeight / 3;
        totleViewWidth = viewWidth;
        totleViewHeight = viewHeight + smallViewHeight;
    }
    
    [self.addView setFrame:CGRectMake((SCREEN_WIDTH - totleViewWidth)/2, (APPLICATION_FRAME.size.height - NAV_HEIGHT - totleViewHeight)/2,viewWidth, viewHeight)];
    
    [self.aboutView setFrame:CGRectMake((SCREEN_WIDTH - totleViewWidth)/2, (APPLICATION_FRAME.size.height - NAV_HEIGHT - totleViewHeight)/2 + viewHeight, smallViewWidth, smallViewHeight)];
    
    [self.shareView setFrame:CGRectMake((SCREEN_WIDTH - totleViewWidth)/2 + smallViewWidth, (APPLICATION_FRAME.size.height - NAV_HEIGHT - totleViewHeight)/2 + viewHeight, smallViewWidth, smallViewHeight)];
    
    [self.setView setFrame:CGRectMake((SCREEN_WIDTH - totleViewWidth)/2 + smallViewWidth*2, (APPLICATION_FRAME.size.height - NAV_HEIGHT - totleViewHeight)/2 + viewHeight, smallViewWidth, smallViewHeight)];
    
    
    [self.view addSubview:self.addView];
    [self.view addSubview:self.aboutView];
    [self.view addSubview:self.shareView];
    [self.view addSubview:self.setView];
    
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setFrame:self.addView.frame];
    [self.addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setFrame:self.shareView.frame];
    [self.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    self.aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aboutButton setFrame:self.aboutView.frame];
    [self.aboutButton addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    
    self.setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setButton setFrame:self.setView.frame];
    [self.setButton addTarget:self action:@selector(set) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.setButton];
    
    CGFloat imageHeight = 100;
    CGFloat imageWeidth = 100;
    CGFloat smallImageHeight = 23;
    CGFloat smallImageWeidth = 23;
    
    UIImage *addImage = [UIImage imageNamed:@"add"];
    self.addImageView = [[UIImageView alloc] initWithImage:addImage];
    [self.addImageView setFrame:CGRectMake((self.addView.frame.size.width - imageWeidth)/2, (self.addView.frame.size.height - imageHeight)/2, imageWeidth, imageHeight)];
    [self.addView addSubview:self.addImageView];
    
    UIImage *aboutImage = [UIImage imageNamed:@"about"];
    UIImageView *aboutImageView = [[UIImageView alloc] initWithImage:aboutImage];
    [aboutImageView setFrame:CGRectMake((self.aboutView.frame.size.width - smallImageWeidth)/2, (self.aboutView.frame.size.height - smallImageHeight)/2, smallImageWeidth, smallImageHeight)];
    [self.aboutView addSubview:aboutImageView];
 
    UIImage *shareImage = [UIImage imageNamed:@"share"];
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:shareImage];
    [shareImageView setFrame:CGRectMake((self.shareView.frame.size.width - smallImageWeidth)/2, (self.shareView.frame.size.height - smallImageHeight)/2, smallImageWeidth, smallImageHeight)];
    [self.shareView addSubview:shareImageView];
    
    Boolean soundsValue = [[ConfigUtil shareConfigUtil] getBoolValueWithKey:SOUNDS_VALUES];
    UIImage *setImage = nil;
    if(soundsValue)
    {
        setImage = [UIImage imageNamed:@"sounds"];
        
    }
    else
    {
        setImage = [UIImage imageNamed:@"nosounds"];
    }
    UIImageView *setImageView = [[UIImageView alloc] initWithImage:setImage];
    [setImageView setFrame:CGRectMake((self.setView.frame.size.width - smallImageWeidth)/2, (self.setView.frame.size.height - smallImageHeight)/2, smallImageWeidth, smallImageHeight)];
    [self.setView addSubview:setImageView];
    
    
    [self.setView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.shareView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.aboutView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.addView setTransform:CGAffineTransformMakeScale(0.4, 0.4)];
    [self.setView setTransform:CGAffineTransformMakeScale(2.4, 0.4)];
    [self.shareView setTransform:CGAffineTransformMakeScale(2.4, 0.4)];
    [self.aboutView setTransform:CGAffineTransformMakeScale(2.4, 0.4)];
    [self.setView setAlpha:0.0];
    [self.shareView setAlpha:0.0];
    [self.aboutView setAlpha:0.0];
    [self performSelector:@selector(beginAnimation) withObject:nil afterDelay:0.5];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)beginAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.addView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    } completion:^(BOOL done){
        [UIView animateWithDuration:0.3 animations:^{
            [self.setView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [self.shareView setTransform:CGAffineTransformMakeScale(1.0,1.0)];
            [self.aboutView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [self.setView setAlpha:0.9];
            [self.shareView setAlpha:0.9];
            [self.aboutView setAlpha:0.9];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{    
    [self changeImage];
}

#pragma mark --- 图片变化

- (void)flickerAddView
{
    //按钮闪烁
    [UIView animateWithDuration:0.3 animations:^{
        [self.addView setAlpha:1.0];
    } completion:^(BOOL done){
        [UIView beginAnimations:@"" context:nil];
        [self.addView setAlpha:0.8];
        [UIView setAnimationDelay:0.7];
        [UIView commitAnimations];
    }];
}

- (void)changeImage
{
    //背景图片
    int randomNumber = random() % self.types.count;
    NSString *imageName = [self.types objectAtIndex:randomNumber];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setSize:self.view.bounds.size];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imageView];
    [imageView setAlpha:0.0];
    [UIView animateWithDuration:8.4
                     animations:^{
                         [imageView setAlpha:1.0];
                         [UIView setAnimationDuration:8];
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                         if(self.flag)
                         {
                             imageView.layer.position =  CGPointMake(imageView.layer.position.x-40, imageView.layer.position.y);
                         }
                         else
                         {
                             if(SCREEN_HEIGHT == 480){
                                 imageView.layer.position =  CGPointMake(imageView.layer.position.x+60, imageView.layer.position.y);
                             }
                             else
                             {
                                 imageView.layer.position =  CGPointMake(imageView.layer.position.x-60, imageView.layer.position.y);
                             }
                         }
                     }
					 completion:^(BOOL done){
                         [UIView animateWithDuration:2
                                          animations:^{
                                              [imageView setAlpha:0.0];
                                          }
                                          completion:^(BOOL done){
                                               [imageView removeFromSuperview];
                                                self.flag = !self.flag;
                                            }];
					 }];
    
    [self.view sendSubviewToBack:imageView];
}


#pragma  mark ---- 按钮事件

- (void)add
{
    if(self.delegate)
        [self.delegate firstPageModelViewShow];
    
    SelectTypeViewController *selectTypeViewcontroller = [[SelectTypeViewController alloc] init];
    selectTypeViewcontroller.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectTypeViewcontroller];
    nav.navigationBar.tintColor = [[UIColor alloc] initWithString:@"#00b690"];
    nav.navigationBar.translucent = NO;
    selectTypeViewcontroller.title = @"旅程类型";
    
    [self presentModalViewController:nav animated:YES];
}

- (void)set
{
     Boolean soundsValue = ![[ConfigUtil shareConfigUtil] getBoolValueWithKey:SOUNDS_VALUES];
    [[ConfigUtil shareConfigUtil] changeBoolValue:soundsValue WithKey:SOUNDS_VALUES];
    
    
    for(id subView in [self.setView subviews])
    {
        [subView removeFromSuperview];
    }
    
    UIImage *setImage = nil;
    if(soundsValue)
    {
        setImage = [UIImage imageNamed:@"sounds"];
        
    }
    else
    {
        setImage = [UIImage imageNamed:@"nosounds"];
    }
    UIImageView *setImageView = [[UIImageView alloc] initWithImage:setImage];
    CGFloat smallImageHeight = 23;
    CGFloat smallImageWeidth = 23;
    [setImageView setFrame:CGRectMake((self.setView.frame.size.width - smallImageWeidth)/2, (self.setView.frame.size.height - smallImageHeight)/2, smallImageWeidth, smallImageHeight)];
    [self.setView addSubview:setImageView];
}

- (void)share
{

    
    if(!self.shareActionSheet)
    {
        self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"分享'准备'给给好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信朋友圈",@"分享给微信好友",@"收藏到微信",@"分享给微博好友", nil];
    }
    [self.shareActionSheet showInView:KEY_WINDOW];
}

- (void)about
{
    NSString *urlString = @"http://v.youku.com/v_show/id_XNjMzNjkyMzYw.html?firsttime=85";
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:webStringURL];
    
    [[UIApplication sharedApplication] openURL:URL];
}


#pragma mark ---delegate

- (void)didSelectedWithType:(NSInteger)type
{
    [self.delegate firstPageModelViewDismiss];
    [self.delegate createSuitcaseWithType:type];
}

#pragma mark --- action sheet 

#define PENG_YOU_QUAN 0
#define WEI_XIN 1
#define WEI_XIN_SHOU_CHANG 2
#define WEI_BO 3

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.shareActionSheet == actionSheet)
    {
        if(PENG_YOU_QUAN == buttonIndex)
        {
            [self sendTextContent:WXSceneTimeline];
        }
        else if(WEI_XIN == buttonIndex)
        {
            [self sendTextContent:WXSceneSession];
        }
        else if(WEI_XIN_SHOU_CHANG == buttonIndex)
        {
            [self sendTextContent:WXSceneFavorite];
        }
        else if(WEI_BO == buttonIndex)
        {
//            [self ssoButtonPressed];
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            
            [WeiboSDK sendRequest:request];
        }
    }
}

- (void) sendTextContent:(NSInteger) wXScene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"Iphone下载免费APP";
    message.description = @"我在iphone上发现了一个不错的免费应用--‘准备’。可以在行程前列出准备清单，这样就不会忘带重要的物品了！";
    [message setThumbImage:[UIImage imageNamed:@"Icon-72@2x.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.likepeak.com";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = wXScene;
    
    [WXApi sendReq:req];
}

#pragma mark --- weibo

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.likepeak.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboRequest:(WBBaseResponse *) response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
        {
            NSString *title = @"认证结果";
            NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@", response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        }
}

- (void)shareWeiboButtonPressed
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    //文字
        message.text = @"iphone上一个不错的免费应用‘准备’。可以在行程前列出准备清单，这样就不会忘带重要的物品了";
    //图片
//        WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon-72@2x" ofType:@"png"]];
//        message.imageObject = image;
    //多媒体
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"app视频";
    webpage.description = [NSString stringWithFormat:@""];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon-72@2x" ofType:@"png"]];
    webpage.webpageUrl = @"http://v.youku.com/v_show/id_XNjMzNjkyMzYw.html?firsttime=85";
    message.mediaObject = webpage;
    
    return message;
}


@end
