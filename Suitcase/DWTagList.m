//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>
#import "Goods.h"
#import "SoundsUtil.h"

#define CORNER_RADIUS 7.0f
#define LABEL_MARGIN 20.0f
#define BOTTOM_MARGIN 15.0f
#define FONT_SIZE 14.0f
#define HORIZONTAL_PADDING 10.0f
#define VERTICAL_PADDING 6.0f
#define TEXT_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_COLOR [UIColor blackColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 3.0f

#define ADD_ORDER_IMAGE_HEIGHT 30

@interface DWTLabel : UILabel

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,strong) UIView *prototypeSuperView;
@property (nonatomic,assign) CGPoint prototypeCenterBeforePutinWindow;
@property (nonatomic, assign) id<DWTagListDelegate> delegate;
@property (nonatomic, assign) FromViewType fromViewType;
@property (nonatomic, strong) Goods *goods;

@end

@implementation DWTLabel

#define keywindow [UIApplication sharedApplication].keyWindow

-(id)initWithFrame:(CGRect)frame withDelegate:(id<DWTagListDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self){
        self.delegate = delegate;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabel:)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void) moveLabel: (UIPanGestureRecognizer *)gestureRecognizer{
    
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self panBegan:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self panMoved:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self panEnded:gestureRecognizer];
            break;
        default:
            break;
    }
}

- (void)panBegan: (UIPanGestureRecognizer *)gestureRecognizer
{
    [[SoundsUtil shareSoundsUtil] playSounds:@"press"];
    
    int prototypeX = self.origin.x;
    int prototypeY = self.origin.y;
    self.prototypeSuperView = [self superview];
    self.prototypeCenterBeforePutinWindow = [self center];
    CGPoint newPoint = [self convertPoint:self.center toView:nil];
    self.center = CGPointMake(newPoint.x - prototypeX, newPoint.y - prototypeY);
    [keywindow addSubview:self];
    [keywindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
}

- (void)panMoved: (UIPanGestureRecognizer *)gestureRecognizer
{
    [self.delegate itemMoving:self.fromViewType];
    
    float halfX = CGRectGetMidX(self.bounds);
    float halfY = CGRectGetMidY(self.bounds);
    
    CGPoint point = [gestureRecognizer translationInView:keywindow];
    
    float newX = gestureRecognizer.view.center.x + point.x;
    float newY = gestureRecognizer.view.center.y + point.y;
    
    newX = MAX(halfX, newX);
    newX = MIN(SCREEN_WIDTH - halfX, newX);
    newY = MAX(halfY, newY);
    newY = MIN(SCREEN_HEIGHT - halfY, newY);
    
    gestureRecognizer.view.center = CGPointMake(newX,newY);
    [gestureRecognizer setTranslation:CGPointZero inView:keywindow];
    
    
    CGPoint center = [self center];

    if(CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT), center))
    {
        [self.delegate itemOverOrderView:self.fromViewType];
        [self.delegate itemOverDelete:self.fromViewType];
        [self.delegate itemOnTaobao:self.fromViewType];
    }
    else if(CGRectContainsPoint(CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT), center))
    {
        [self.delegate itemOverOrderView:self.fromViewType];
        [self.delegate itemOverTaobao:self.fromViewType];
        [self.delegate itemOnDelete:self.fromViewType];
    }
    else if(CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2), center))
    {
        [self.delegate itemOverTaobao:self.fromViewType];
        [self.delegate itemOverDelete:self.fromViewType];
        
        
        [self.delegate itemOnOrderView:self.fromViewType];
        [keywindow bringSubviewToFront:self];
    }
    else if(CGRectContainsPoint(CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2), center))
    {
        [self.delegate itemOnBagView:self.fromViewType];
        [self.delegate itemOverOrderView:self.fromViewType];
        [self.delegate itemOverTaobao:self.fromViewType];
        [self.delegate itemOverDelete:self.fromViewType];
    }
    else{
        
    }
}

- (void)panEnded: (UIPanGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    CGPoint toCenter = [self.prototypeSuperView convertPoint:self.prototypeCenterBeforePutinWindow toView:nil];
    CGPoint center = [self center];

    if(CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT), center))
    {
        //淘宝
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setCenter:toCenter];
        } completion:^(BOOL done){
            [self setCenter:self.prototypeCenterBeforePutinWindow];
            [self.prototypeSuperView addSubview:self];
        }];
        
        [self.delegate itemOverTaobao:self.fromViewType];
        [self.delegate itemEndInTaobaoWithGoods:self.goods withFromViewType:self.fromViewType];
        [[SoundsUtil shareSoundsUtil] playSounds:@"up"];
    }
    else if(CGRectContainsPoint(CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, TITLE_NAV_HEIGHT), center))
    {
        //删除
        
        if(self.fromViewType == FromViewTypeList)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self setCenter:toCenter];
            } completion:^(BOOL done){
                [self setCenter:self.prototypeCenterBeforePutinWindow];
                [self.prototypeSuperView addSubview:self];
            }];
            [self.delegate itemEnded:self.fromViewType];
            return;
        }
        
        [UIView animateWithDuration:0.7 animations:^{
            [self setAlpha:0.0];
        } completion:^(BOOL done){}];
        [self removeFromSuperview];
        
        [self.delegate itemOverDelete:self.fromViewType];
        [self.delegate itemEndInDeleteWithGoods:self.goods withFromViewType:self.fromViewType];
        [[SoundsUtil shareSoundsUtil] playSounds:@"delete"];
    }
    else if(CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2), center))
    {
        //order
        
        //order DWTaglist
        [self.delegate itemEndInOrderViewWithGoods:self.goods withFromViewType:self.fromViewType];
        
        //view
        [self setCenter:toCenter];
        [self setCenter:self.prototypeCenterBeforePutinWindow];
        [self.prototypeSuperView addSubview:self];
        [[SoundsUtil shareSoundsUtil] playSounds:@"up"];
    }
    else if(CGRectContainsPoint(CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2), center))
    {
        //bag or list
        
        FromViewType toViewType = [self.delegate itemEndInBagWithGoods:self.goods withFromViewType:self.fromViewType];
        
        //view
        if(toViewType == FromViewTypeBag)
        {
            [self setCenter:toCenter];
            [self setCenter:self.prototypeCenterBeforePutinWindow];
            [self.prototypeSuperView addSubview:self];
        }
        else if (toViewType == FromViewTypeList)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self setCenter:toCenter];
            } completion:^(BOOL done){
                [self setCenter:self.prototypeCenterBeforePutinWindow];
                [self.prototypeSuperView addSubview:self];
            }];
        }
        [[SoundsUtil shareSoundsUtil] playSounds:@"up"];
    }
    else{

    }
    [self.delegate itemEnded:self.fromViewType];
}

@end


@interface DWTagList()
@property(nonatomic, strong) DWTagList *cloneOne;
@end

@implementation DWTagList

@synthesize view, goodsArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addSubview:view];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id<DWTagListDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self setUserInteractionEnabled:YES];
        [self addSubview:view];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id<DWTagListDelegate>) delegate withFromViewType:(FromViewType)fromView
{
    self = [self initWithFrame:frame withDelegate:delegate];
    if(self)
    {
        self.fromViewType = fromView;
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    self.goodsArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
}

- (void)display
{
    for (DWTLabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
        for (Goods *goods in self.goodsArray) {
        CGSize textSize = [goods.name sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:NSLineBreakByWordWrapping];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        DWTLabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[DWTLabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height) withDelegate:self.delegate];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[DWTLabel alloc] initWithFrame:newRect withDelegate:self.delegate];
        }
        [[label superview] bringSubviewToFront:label];
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:DARK_GRAY_COLOR];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        [label setTextColor:TEXT_COLOR];
        [label setText:goods.name];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:[UIColor colorWithString:goods.color].CGColor];
        [label setGoods:goods];
        [label.layer setBorderWidth: BORDER_WIDTH];
        [label setFromViewType:self.fromViewType];
        [self addSubview:label];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 40.0f);
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end
