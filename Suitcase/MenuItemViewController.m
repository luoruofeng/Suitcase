//
//  UIMenuItemView.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-10.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "MenuItemViewController.h"
#import "TypesUtil.h"
#import "Suitcase.h"

//luoruofeng 1234
#define VIEW_HEIGHT 
#define VIEW_WIDTH

@interface MenuItemViewController()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *deleteImageView;
@property (nonatomic, retain) CoreDataUtil *coreData;
@end

#define DATE_FORMATE @"yyyy-MM-dd"

@implementation MenuItemViewController
-(id) init
{
    self = [super init];
    if(self){
    }
    return self;
}

- (id)initWithScroll:(UIScrollView *)scrollView
{
    self.scrollView = scrollView;
    return [self init];
}

- (void)loadView
{
    [super loadView];

    CGRect  mainView = CGRectMake(self.scrollView.contentSize.width, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    int contentWidth = SCREEN_WIDTH - 60;
    int imageWidth = contentWidth;
    CGRect contentViewRect = CGRectZero;
    if(SCREEN_HEIGHT == 480)
    {
        if(IOS_VERSION >= 7.0)
        {
            contentViewRect = CGRectMake((SCREEN_WIDTH - imageWidth) / 2, 40, contentWidth, 380);
        }
        else
        {
            contentViewRect = CGRectMake((SCREEN_WIDTH - imageWidth) / 2, 30, contentWidth, 360);
        }
        
    }
    else
    {
        if(IOS_VERSION >= 7.0)
        {
            contentViewRect = CGRectMake((SCREEN_WIDTH - imageWidth) / 2, 40, contentWidth, 468);
        }
        else
        {
            contentViewRect = CGRectMake((SCREEN_WIDTH - imageWidth) / 2, 30, contentWidth, 448);
        }
    }
    

    
    [self.view setFrame:mainView];
    [self.view setBackgroundColor:DARK_GRAY_COLOR];
    
    if (self) {
        
        self.contentView = [[UIView alloc] init];
        self.contentView.layer.cornerRadius = 10;
        [self.contentView setClipsToBounds:YES];
        [self.contentView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
        [self.contentView setFrame:contentViewRect];
        [self.contentView setBackgroundColor:LIGHT_GRAY_COLOR];
        
        [self.view addSubview:self.contentView];
        
        NSString *imageName = (NSString *)[[[TypesUtil shareTypesUtil] getAllTypes] objectAtIndex:[self.suitcase.typeId intValue]];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, imageWidth, 100)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:imageView];
        
        self.nameText = [[UITextField alloc] initWithFrame:CGRectMake( 10, imageView.height + 50, contentWidth - 20, 28)];
        self.nameText.textColor = DARK_GRAY_COLOR;
        [self.nameText setTextAlignment:NSTextAlignmentCenter];
        [self.nameText setReturnKeyType:UIReturnKeyDone];
        self.nameText.font = [UIFont boldSystemFontOfSize:17];
        self.nameText.placeholder = @"行程名称";
        if(self.suitcase.name && ![self.suitcase.name isEqualToString:@""])
        {
            [self.nameText setText:self.suitcase.name];
        }
        self.nameText.delegate = self;
        
        
        UITextField *createText = [[UITextField alloc] initWithFrame:CGRectMake( 10, imageView.height + 100, contentWidth - 20, 28)];
        createText.textColor = DARK_GRAY_COLOR;
        [createText setTextAlignment:NSTextAlignmentCenter];
        createText.font = [UIFont boldSystemFontOfSize:17];
        if(self.suitcase.create && self.suitcase.create != nil)
        {
            [createText setText:[NSDate toStringWithDate:self.suitcase.create format:DATE_FORMATE]];
        }
        [createText setUserInteractionEnabled:NO];
        
        
        self.dateText = [[UITextField alloc] initWithFrame:CGRectMake( 10, imageView.height + 150, contentWidth - 20, 28)];
        self.dateText.textColor = DARK_GRAY_COLOR;
        [self.dateText setTextAlignment:NSTextAlignmentCenter];
        [self.dateText setReturnKeyType:UIReturnKeyDone];
        self.dateText.font = [UIFont boldSystemFontOfSize:17];
        self.dateText.placeholder = @"出发日期";
        self.dateText.userInteractionEnabled = NO;
        if(self.suitcase && self.suitcase.dateOfDeparture != nil)
        {
            NSString *dateString = [NSDate toStringWithDate:self.suitcase.dateOfDeparture format:DATE_FORMATE];
            [self.dateText setText:dateString];
        }
        self.dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dateButton setFrame:CGRectMake(10, imageView.height + 150, contentWidth - 20, 28)];
        [self.dateButton addTarget:self action:@selector(checkDate) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:createText];
        [self.contentView addSubview:self.nameText];
        [self.contentView addSubview:self.dateText];
        [self.contentView addSubview:self.dateButton];
        
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentView.height - 90, contentWidth - 20, 100)];
        [number setBackgroundColor:[UIColor clearColor]];
        UIFont *numberFont = [UIFont systemFontOfSize:44];
        number.textAlignment = UITextAlignmentCenter;
        number.font = numberFont;
        number.textColor = DARK_GRAY_COLOR;
        number.tag = TAG_NUMBER;
        number.text = [NSString stringWithFormat:@"%d/%d",[self.suitcase.insideNumber intValue], [self.suitcase.outsideNumber intValue] + [self.suitcase.insideNumber intValue],nil];
        [self.contentView addSubview:number];
        
        //单指单击
        UITapGestureRecognizer *singleFingerOne =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent)];
        singleFingerOne.delegate = self;
        singleFingerOne.numberOfTouchesRequired = 1;//手指数
        singleFingerOne.numberOfTapsRequired = 1;//tap次数
        [self.view addGestureRecognizer:singleFingerOne];
        
        [self isPastDue];
    }

}

- (void)viewDidLoad
{
    //下拉
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handleSwipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    //上拉
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleSwipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(deleteImageFlicker) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer  = nil;
}

#pragma mark --- cancel first responder

- (void)cancelFirstResponder
{
    if (![self.nameText isExclusiveTouch]) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
    [self handleSwipeUp];
}

#pragma mark --- 手指动作

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
    
    return YES;
}


- (void)handleSingleFingerEvent
{
        if((self.view.frame.origin.y != 0) || [self.nameText isFirstResponder])
        {
            [self cancelFirstResponder];
        }
        else
        {
            [self.delegate showDetail];
        }
}

- (void)handleSwipeDown
{
    
    if([self.nameText isFirstResponder])
    {
        return;
    }
    
    if(self.view.frame.origin.y == 0)
    {
        self.deleteBar = [[UIView alloc] init];
        [self.deleteBar setBounds:CGRectMake(0, 0, SCREEN_WIDTH, DELETE_BAR_HEIGHT)];
        [self.deleteBar.layer setAnchorPoint:CGPointZero];
        [self.deleteBar setBackgroundColor:[UIColor blackColor]];
        
        int imageHeight = 30;
        UIImage *deleteImage = [UIImage imageNamed:@"delete"];
        self.deleteImageView = [[UIImageView alloc] initWithImage:deleteImage];
        [self.deleteImageView setFrame:CGRectMake((SCREEN_WIDTH - imageHeight)/2, (DELETE_BAR_HEIGHT - imageHeight)/2, imageHeight, imageHeight)];
        
        UIFont *deleteFont = [UIFont systemFontOfSize:15];
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+imageHeight, SCREEN_WIDTH, DELETE_BAR_HEIGHT/2)];
        [deleteLabel setTextColor:LIGHT_GRAY_COLOR];
        [deleteLabel setFont:deleteFont];
        [deleteLabel setTextAlignment:NSTextAlignmentCenter];
        [deleteLabel setText:@"删除"];
        [deleteLabel setBackgroundColor:[UIColor clearColor]];
        
        UIButton *deleteButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, DELETE_BAR_HEIGHT)];
        [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        
        [self.deleteBar addSubview:deleteLabel];
        [self.deleteBar addSubview:self.deleteImageView];
        [self.deleteBar addSubview:deleteButton];
        [self.deleteBar bringSubviewToFront:deleteButton];
        
        if(IOS_VERSION >= 7.0)
        {
            self.deleteBar.layer.position = CGPointMake(0, -DELETE_BAR_HEIGHT);
        }
        else
        {
            self.deleteBar.layer.position = CGPointMake(0, 20-DELETE_BAR_HEIGHT);
        }
        [KEY_WINDOW addSubview:self.deleteBar];
                                              
        [UIView animateWithDuration:0.5 animations:^{
            if(IOS_VERSION >= 7.0)
            {
                self.deleteBar.layer.position = CGPointMake(0, 0);;
            }
            else
            {
                self.deleteBar.layer.position = CGPointMake(0, 20);
            }
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+DELETE_BAR_HEIGHT, SCREEN_HEIGHT,SCREEN_HEIGHT)];
        }];
        
        if(!self.timer)
        {
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(deleteImageFlicker) userInfo:nil repeats:YES];
        }
        else
        {
            [self.timer setFireDate:[NSDate date]];
        }
    }
}

- (void)handleSwipeUp
{
    if(self.view.frame.origin.y != 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            if(IOS_VERSION >= 7.0)
            {
                self.deleteBar.layer.position = CGPointMake(0, -DELETE_BAR_HEIGHT);
            }
            else
            {
                self.deleteBar.layer.position = CGPointMake(0, 20-DELETE_BAR_HEIGHT);
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-DELETE_BAR_HEIGHT, SCREEN_HEIGHT,SCREEN_HEIGHT)];
        } completion:^(BOOL done){
            [self.deleteBar removeFromSuperview];
        }];
        
        //删除闪烁定时器
        if(self.timer){
            [self.timer setFireDate:[NSDate distantFuture]];
        }
    }
}

#pragma mark ---操作

-  (void) delete
{
    //删除操作
    [self.timer invalidate];
    self.timer = nil;

    [self handleSwipeUp];
    [self.delegate deleteItem];
}


#pragma mark --- 按钮事件

- (void)checkDate
{
    [self cancelFirstResponder];
    
    //actionsheet
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定",nil];
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    
    self.pickerView = [[UIDatePicker alloc] init];
    [self.pickerView setDatePickerMode:UIDatePickerModeCountDownTimer];
    
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
    [self.pickerView setAlpha:0.7];
    
    if(IOS_VERSION >= 6.0)
    {
        [self.pickerView setMinimumDate:[NSDate date]];
    }
    [self.pickerView setDatePickerMode:UIDatePickerModeDate];
    [self.actionSheet addSubview:self.pickerView];
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:KEY_WINDOW];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        self.dateText.text = [NSDate toStringWithDate:[self.pickerView date] format:DATE_FORMATE];
        [self.delegate didSelectDateOfDeparture:[self.pickerView date]];
        [self isPastDue];
    }
    [actionSheet resignFirstResponder];
}


#pragma mark ---textfailed delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self handleSwipeUp];
    return YES;
}

#pragma  mark ---- 闪烁
- (void)deleteImageFlicker
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.deleteImageView setAlpha:0.5];
        [self.pastDueView setAlpha:0.0];
    } completion:^(BOOL done){
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [self.pastDueView setAlpha:0.3];
        [UIView setAnimationDuration:0.5];
        [self.deleteImageView setAlpha:1.0];
        [UIView commitAnimations];
    }];
}


#pragma mark --- text filed delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UIAlertView *alert = nil;
    if(textField.text == nil  || textField.text.length == 0)
    {
        alert  = [[UIAlertView alloc] initWithTitle:@"请输入行程名称" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    
    if(textField.text != nil  && textField.text.length > 15)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"行程名称不能超过15个字" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];

        [alert show];
        return NO;
    }
    
    [self.delegate didInputName:textField.text];
    return YES;
};


#pragma mark --- 判断是否过期

- (void)isPastDue
{
    if(self.pastDueView)
    {
        [self.pastDueView removeFromSuperview];
    }
    
    NSDate *pastDueDate = [NSDate dateWithString:self.dateText.text format:@"yyyy-MM-dd"];
    
    if(!self.dateText || self.dateText.text == nil || [self.dateText.text isEqualToString:@""] || [pastDueDate compare:[NSDate date]] == NSOrderedDescending)
    {
        [[self.view viewWithTag:TAG_PAST_DUE_VIEW] removeFromSuperview];
        return;
    }
    
    self.pastDueView = [[UIView alloc] initWithFrame:self.contentView.frame];
    [self.pastDueView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
    [self.pastDueView setCenter:self.contentView.center];
    [self.pastDueView setBackgroundColor:[UIColor redColor]];
    [self.pastDueView setAlpha:0.3];
    self.pastDueView.layer.cornerRadius = 10;
    [self.pastDueView setTag:TAG_PAST_DUE_VIEW];
    [self.pastDueView setUserInteractionEnabled:NO];
    UILabel *pastDueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pastDueView.width, 30)];
    [pastDueLabel setBackgroundColor:[UIColor clearColor]];
    [pastDueLabel setCenter:CGPointMake(self.pastDueView.width/2, self.pastDueView.height*0.8)];
    [pastDueLabel setTextAlignment:NSTextAlignmentCenter];
    [pastDueLabel setTextColor:[UIColor whiteColor]];
    [pastDueLabel setText:@"过期"];
    [self.pastDueView addSubview:pastDueLabel];
    [self.view addSubview:self.pastDueView];
    
}

@end
