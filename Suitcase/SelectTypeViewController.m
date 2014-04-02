//
//  SelectTypeViewController.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "TypesUtil.h"

@interface SelectTypeViewController ()

@property (nonatomic,strong) UIScrollView *scroll;
@property (nonatomic, strong) NSArray *types;
@end

@implementation SelectTypeViewController

NSInteger typeHeight = 140;
NSInteger titleHeight = 35;
NSInteger titleLeft = 10;

- (id)init
{
    self = [super init];
    if (self) {
        if(!self.types || self.types.count < 1)
        {
            self.types = [[TypesUtil shareTypesUtil] getAllTypes];
        }
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToFirst)];
    
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-image"]];
    [self.view addSubview:backgroundImageView];
    
    UIView *titleView = nil;
    UIImageView *imageView = nil;
    UIImage *image = nil;
    UIFont *font = [UIFont systemFontOfSize:19];
    UILabel *titleLabel = nil;
    UIButton *button = nil;
    self.scroll = [[UIScrollView alloc] initWithFrame:SCREEN_FRAME];
    
    int scrollContentHeight = 0;
    for(int i = 0;i < self.types.count;i++)
    {
        image = [UIImage imageNamed:[self.types objectAtIndex:i]];
        imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setClipsToBounds:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setCornerRadius:14.0];
        [imageView setFrame:CGRectMake(0, typeHeight*i - (i*22), SCREEN_WIDTH, typeHeight)];
        imageView.userInteractionEnabled = YES;
        
        scrollContentHeight = (typeHeight*i - (i*22));
        
        titleView = [[UIView alloc] init];
        [titleView setBackgroundColor:[UIColor blackColor]];
        [titleView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
        [titleView setAlpha:0.7];
        [imageView addSubview:titleView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
        [titleLabel setFont:font];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:[self.types objectAtIndex:i]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [imageView bringSubviewToFront:titleLabel];
        [imageView addSubview:titleLabel];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, typeHeight)];
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:100+i];
        [imageView addSubview:button];
        [imageView bringSubviewToFront:button];
        
        [self.scroll addSubview:imageView];
    
    }
    [self.scroll setContentSize:CGSizeMake(320, scrollContentHeight+typeHeight+44)];
    [self.view addSubview:self.scroll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{}

#pragma  mark --- 选择
- (void)selectType:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int typeId = button.tag - 100;
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate didSelectedWithType:typeId];
}

- (void)backToFirst
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
