//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goods;

typedef NS_ENUM(NSInteger, DragLabelType) {
    DragLabelTypeFromListToOrder,
    DragLabelTypeFromListToTaobao,
    DragLabelTypeFromListToDelete,
    DragLabelTypeFromListToList,
    DragLabelTypeFromOrderToTaobao,
    DragLabelTypeFromOrderToDelete,
    DragLabelTypeFromOrderToOrder,
    DragLabelTypeFromOrderToList,
    DragLabelTypeFromOrderToBag,
    DragLabelTypeFromBagToTaobao,
    DragLabelTypeFromBagToDelete,
    DragLabelTypeFromBagToOrder,
    DragLabelTypeFromBagToBag
};

typedef NS_ENUM(NSInteger, FromViewType) {
    FromViewTypeOrder,
    FromViewTypeBag,
    FromViewTypeList
};

@protocol DWTagListDelegate <NSObject>

- (void)itemEnded:(FromViewType)fromViewType;
- (void)itemMoving:(FromViewType)fromViewType;
- (void)itemOnOrderView:(FromViewType)fromViewType;
- (void)itemOnBagView:(FromViewType)fromViewType;
- (void)itemOnTaobao:(FromViewType)fromViewType;
- (void)itemOnDelete:(FromViewType)fromViewType;
- (void)itemOverDelete:(FromViewType)fromViewType;
- (void)itemOverOrderView:(FromViewType)fromViewType;
- (void)itemOverTaobao:(FromViewType)fromViewType;
- (void)itemEndInDeleteWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType;
- (FromViewType)itemEndInBagWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType;
- (void)itemEndInOrderViewWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType;
- (void)itemEndInTaobaoWithGoods:(Goods *)goods withFromViewType:(FromViewType) fromViewType;

@end

@interface DWTagList : UIView
{
    UIView *view;
    NSArray *textArray;
    NSMutableDictionary *textDictionary;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, assign) id<DWTagListDelegate> delegate;
@property (nonatomic, assign) FromViewType fromViewType;

- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<DWTagListDelegate>) delegate;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<DWTagListDelegate>) delegate withFromViewType:(FromViewType)fromView;

@end
