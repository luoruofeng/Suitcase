//
//  Goods.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-29.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Suitcase;
typedef NS_ENUM(NSInteger,GoodsStatus){
    GoodsStatusOrder,
    GoodsStatusBag
};

typedef NS_ENUM(NSInteger,UsedWeb){
    UsedWebNo,
    UsedWebYes
};
@interface Goods : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSDate * create;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * putIn;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * useWeb;
@property (nonatomic, retain) Suitcase *suitcase;

@end
