//
//  UIMenuItemView.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-10.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Suitcase.h"

@protocol MenuItemViewControllerDelegate <NSObject>
@required
- (void)deleteItem;

- (void)didInputName:(NSString *)name;

- (void)didSelectDateOfDeparture:(NSDate *)date;

- (void)showDetail;

@end

@interface MenuItemViewController : UIViewController<UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,retain)UIScrollView *scrollView;

@property (nonatomic, retain) Suitcase *suitcase;

@property (nonatomic,strong) UITextField *nameText;
@property (nonatomic,strong) UITextField *dateText;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIView *deleteBar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) UIView *pastDueView;
@property (nonatomic, assign) id<MenuItemViewControllerDelegate> delegate;

- (id)initWithScroll:(UIScrollView *)scrollView;

- (void)handleSwipeUp;

- (void)handleSwipeDown;

@end
