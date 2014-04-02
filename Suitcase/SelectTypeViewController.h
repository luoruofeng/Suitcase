//
//  SelectTypeViewController.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTypeDelegate <NSObject>
@required
- (void)didSelectedWithType:(NSInteger)type;

@end

@interface SelectTypeViewController : UIViewController
@property (nonatomic,assign) id<SelectTypeDelegate> delegate;
@end
