//
//  TypesUtil.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypesUtil : NSObject

+ (id)shareTypesUtil;

- (NSArray *)getAllTypes;
    
- (NSMutableDictionary *)getAllGoodsTypes;
    
- (NSArray *)getGoodsWithType:(NSString *)type;

- (NSArray *)getTypesArray;

- (NSString *)getColorWithKey:(NSString *)key;

- (NSString *)getTextWithKey:(NSString *)key;

- (NSArray *)getCommonGoods;

@end
