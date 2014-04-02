//
//  BaseViewController.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-10.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemViewController.h"
#import "FirstPageViewController.h"
#import "Suitcase.h"
#import "SuitcaseViewController.h"


#define SCROLL_WIDTH self.scrollView.contentSize.width
#define SCROLL_HEIGHT self.scrollView.contentSize.height

@interface MenuViewController ()
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) NSMutableArray *menuItemControllers;
@property (nonatomic, strong) MenuItemViewController *menuItemController;

@property (nonatomic, assign) CGRect prototypeRect;

@property (nonatomic, assign) CGRect changedRect;

@property (nonatomic, retain) CoreDataUtil *coreData;

@end

@implementation MenuViewController

- (id) init
{
    self = [super init];
    if(self)
    {
        self = [super init];
        //core data
        if(!self.coreData)
        {
            self.coreData =[CoreDataUtil shareTypesUtil];
        }
        [[CoreDataUtil shareTypesUtil] initCoreData];
        [self loadData];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    [self.view setFrame:SCREEN_FRAME];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //scroll
    self.scrollView = [[UIScrollView alloc] initWithFrame:SCREEN_FRAME];
    [self.scrollView setClipsToBounds:YES];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];

    [self.scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, APPLICATION_FRAME.size.height - NAV_HEIGHT)];
    
    FirstPageViewController *firstViewController = [[FirstPageViewController alloc] initWithScroll:self.scrollView];
    [firstViewController setDelegate:self];
    [self.scrollView addSubview:firstViewController.view];

    self.scrollView.delegate = self;
    [self.scrollView setBackgroundColor:DARK_GRAY_COLOR];
    [self.view addSubview:self.scrollView];
    
    //suitcase  data
    if(self.suitcases)
    {
        
        for(Suitcase *suitcase in self.suitcases)
        {
            [self addSuitcaseToScrollWithType:suitcase];
        }
    }
    //nav
    if(IOS_VERSION >= 7.0)
    {
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAV_HEIGHT, SCREEN_HEIGHT, NAV_HEIGHT)];
    }
    else
    {
        self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_FRAME.size.height-NAV_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT)];
    }
    [self.navView setAlpha:0.7];
    
    [self.navView setBackgroundColor:[UIColor clearColor]];
    [self.navView setTag:NAV_TAG];
    [self.view addSubview:self.navView];
    
    self.curentItemIndex = -1;
    [self loadPageControllerWithCount:self.suitcases.count];
    
    //arrows
    UIImage *leftImage = [UIImage imageNamed:@"leftArrows"];
    UIImage *rightImage = [UIImage imageNamed:@"rightArrows"];
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
    [leftImageView setContentMode:UIViewContentModeScaleAspectFit];
    [rightImageView setContentMode:UIViewContentModeScaleAspectFit];
    [leftImageView setFrame:CGRectMake(5, NAV_HEIGHT/2/2, NAV_HEIGHT/2,NAV_HEIGHT/2)];
    [rightImageView setFrame:CGRectMake(SCREEN_WIDTH - NAV_HEIGHT/2-5, NAV_HEIGHT/2/2, NAV_HEIGHT/2,NAV_HEIGHT/2)];
    [self.navView addSubview:leftImageView];
    [self.navView addSubview:rightImageView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(IOS_VERSION >= 7.0)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
}

#pragma mark ---- 手指

- (void)handleSwipeDown
{
    [self.menuItemController handleSwipeDown];
}

- (void)handleSwipeUp
{
    [self.menuItemController handleSwipeUp];
}

#pragma mark ---scroll

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.menuItemController handleSwipeUp];
    
    if(self.menuItemController)
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.menuItemController.contentView setAlpha:0.8];
            [self.menuItemController.contentView setTransform:CGAffineTransformMakeScale(0.96, 0.96)];
            [self.menuItemController.pastDueView setTransform:CGAffineTransformMakeScale(0.96, 0.96)];
        } completion:^(BOOL done){
        }];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(self.menuItemController)
    {
        [UIView animateWithDuration:0.7 animations:^{
            [self.menuItemController.contentView setAlpha:1.0];
            [self.menuItemController.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [self.menuItemController.pastDueView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        } completion:^(BOOL done){
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.curentItemIndex = (self.scrollView.contentOffset.x / SCREEN_WIDTH) - 1;
    
    if(self.curentItemIndex >= 0){
        self.menuItemController = (MenuItemViewController *)[self.menuItemControllers objectAtIndex:self.curentItemIndex];
        
        [UIView beginAnimations:@"" context:nil];
        [self.menuItemController.contentView setAlpha:1.0];
        [self.menuItemController.contentView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [self.menuItemController.pastDueView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        [UIView commitAnimations];
        [self setAllContentViewToPrototype];
    }
    else
    {
        self.menuItemController = nil;
    }
    
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;
}


#pragma mark ----firstPageDelegate

- (void)firstPageModelViewDidLoad
{
}

- (void)firstPageModelViewShow
{
    [self.navView setHidden:YES];
}

- (void)firstPageModelViewDismiss
{
    [self.navView setHidden:NO];
}

- (void)createSuitcaseWithType:(NSInteger)typeId
{
    if(self.childViewControllers.count >= 15)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能新建更多的背包" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    self.menuItemController = [[MenuItemViewController alloc] initWithScroll:self.scrollView];
    [self.menuItemController setDelegate:self];
    Suitcase *suitcase = [self addObjects:typeId];
    if(!suitcase)
    {
        return;
    }
    self.menuItemController.suitcase = suitcase;
    if(!self.menuItemControllers)
    {
        self.menuItemControllers = [[NSMutableArray alloc] init];
    }
    
    [self.menuItemControllers addObject:self.menuItemController];
    [self setCurentItemIndex:self.menuItemControllers.count-1];
    MenuItemViewController *lastObject = [self.menuItemControllers lastObject];
    [self addChildViewController:lastObject];
    [self.scrollView addSubview:lastObject.view];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width+SCREEN_WIDTH, self.scrollView.bounds.size.height)];
    
    self.prototypeRect = lastObject.contentView.frame;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.6];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - SCREEN_WIDTH, 0)];
    [UIView commitAnimations];
    
    [self loadData];
    [self loadPageControllerWithCount:self.suitcases.count];
}

- (void)addSuitcaseToScrollWithType:(Suitcase *)suitcase
{
    MenuItemViewController *currentItem = [[MenuItemViewController alloc] initWithScroll:self.scrollView];
    [currentItem setDelegate:self];
    
    currentItem.suitcase = suitcase;
    
    if(!self.menuItemControllers)
    {
        self.menuItemControllers = [[NSMutableArray alloc] init];
    }
    
    [self.menuItemControllers addObject:currentItem];
    MenuItemViewController *lastObject = [self.menuItemControllers lastObject];
    [self addChildViewController:lastObject];
    [self.scrollView addSubview:lastObject.view];
    [lastObject.view setClipsToBounds:NO];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width+SCREEN_WIDTH, self.scrollView.bounds.size.height)];
    
    self.prototypeRect = currentItem.contentView.frame;
}

#pragma mark ----MenuItemViewControllerDelegate

- (void)showDetail
{
    SuitcaseViewController *suitcaseViewController = [[SuitcaseViewController alloc] initWithSuitcase:[self.suitcases objectAtIndex:self.curentItemIndex]];
    [suitcaseViewController setDelegate:self];
    [self presentModalViewController:suitcaseViewController animated:YES];
}

- (void)didInputName:(NSString *)name
{
    Suitcase *suitcase = [self.suitcases objectAtIndex:self.curentItemIndex];
    suitcase.name = name;
    // Save the data
	NSError *error;
	if (![self.coreData.context save:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    [self loadData];
}

- (void)didSelectDateOfDeparture:(NSDate *)date
{
    Suitcase *suitcase = [self.suitcases objectAtIndex:self.curentItemIndex];
    suitcase.dateOfDeparture = date;
    // Save the data
	NSError *error;
	if (![self.coreData.context save:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    [self loadData];
}

- (void)setAllContentViewToPrototype
{
    if(self.menuItemControllers)
    {
        for(MenuItemViewController *item in self.menuItemControllers)
        {
            if(item.contentView.height != self.menuItemController.contentView.height)
            {
                [item.contentView setAlpha:1.0];
                [item.contentView setBounds:self.menuItemController.contentView.bounds];
            }
        }
    }
}

- (void)deleteItem
{
    
    if(self.menuItemController)
    {
        [self setAllContentViewToPrototype];
        
        [UIView animateWithDuration:0.4 animations:^{
            for(int i = self.curentItemIndex + 1; i < self.menuItemControllers.count; i++)
            {
                MenuItemViewController *item = [self.menuItemControllers objectAtIndex:i];
                [item.view setCenter:CGPointMake(item.view.center.x-SCREEN_WIDTH, item.view.center.y)];
            }
        } completion:^(BOOL done){
            [self removeObject:self.menuItemController.suitcase];
            [self.suitcases removeObject:self.menuItemController.suitcase];
            [self.menuItemControllers removeObject:self.menuItemController];
            [[self.childViewControllers objectAtIndex:self.curentItemIndex] removeFromParentViewController];
            [self.menuItemController.view removeFromSuperview];
            [self.menuItemController removeFromParentViewController];
            
            if(self.curentItemIndex > (self.menuItemControllers.count - 1))
            {
                self.curentItemIndex --;
            }
            if(self.menuItemControllers.count > 0)
            {
                self.menuItemController = [self.menuItemControllers objectAtIndex:self.curentItemIndex];
            }else
            {
                self.menuItemController = nil;
            }
            [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * (self.menuItemControllers.count + 1), SCROLL_HEIGHT)];
            
            [self loadPageControllerWithCount:self.suitcases.count];
        }];
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

- (Suitcase *) addObjects:(NSInteger) typeId
{
	Suitcase *suitcase = (Suitcase *)[NSEntityDescription insertNewObjectForEntityForName:@"Suitcase" inManagedObjectContext:self.coreData.context];
    suitcase.create = [NSDate date];
	suitcase.name = nil;
    suitcase.dateOfDeparture = nil;
    suitcase.insideNumber = 0;
    suitcase.outsideNumber = 0;
    suitcase.goodss = nil;
    suitcase.typeId = [NSNumber numberWithInt:typeId];
    // Save the data
	NSError *error;
	if (![self.coreData.context save:&error])
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        return suitcase;
    }
    return  nil;
}

- (void) fetchObjects
{
	// Create a basic fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"Suitcase" inManagedObjectContext:self.coreData.context]];
	
	// Add a sort descriptor
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create" ascending:YES selector:nil];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[fetchRequest setSortDescriptors:descriptors];
	
	// Init the fetched results controller
	NSError *error;

    self.suitcases = [NSMutableArray arrayWithArray: [self.coreData.context executeFetchRequest:fetchRequest error:&error]];

	if (![[self.coreData results] performFetch:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"Controller content did change");
}

- (void) listSuitcases
{
	[self fetchObjects];
}

- (void) removeObject:(Suitcase *)suitcase
{
	NSError *error = nil;
	
	// remove all people (if they exist)
	[self.coreData.context deleteObject:suitcase];
	// save
	if (![self.coreData.context save:&error]) NSLog(@"Error: %@ (%@)", [error localizedDescription], [error userInfo]);
	[self fetchObjects];
}



#pragma mark ---- 加载数据
- (void)loadData
{
    self.suitcases = [[NSMutableArray alloc] init];
    [self listSuitcases];
}

#pragma mark --- ui page controller
- (void)loadPageControllerWithCount:(NSInteger) count
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    _pageControl.alpha = 0.7;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = count+1;
    _pageControl.tag = TAG_PAGE_CONTROLLER;
    
    [[self.navView viewWithTag:TAG_PAGE_CONTROLLER] removeFromSuperview];
    int currentPage = (self.curentItemIndex < 0 ? 0 : self.curentItemIndex+1);
    _pageControl.currentPage = currentPage;
    [_pageControl addTarget:self action:@selector(startApp) forControlEvents:UIControlEventValueChanged];
    [self.navView addSubview:_pageControl];
}

-(void)startApp
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark --- SuitcaseDelegate

-(void)goBack
{
    Suitcase *suitcase = [self.suitcases objectAtIndex:self.curentItemIndex];
     UITextView *numberText = (UITextView *)[self.menuItemController.view viewWithTag:TAG_NUMBER];
    numberText.text = [NSString stringWithFormat:@"%d/%d",[suitcase.insideNumber intValue], [suitcase.outsideNumber intValue] + [suitcase.insideNumber intValue],nil];
}

@end


