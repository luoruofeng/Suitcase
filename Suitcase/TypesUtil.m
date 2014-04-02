//
//  TypesUtil.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-14.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "TypesUtil.h"

@implementation TypesUtil

static TypesUtil *typesUtil = nil;
static NSArray *types = nil;
static NSDictionary *colors = nil;
static NSArray *typesArray = nil;
static NSMutableDictionary *goodsTypes = nil;
static NSMutableDictionary *typeTexts = nil;
static NSArray *commonArray = nil;

+ (id)shareTypesUtil
{
    @synchronized(self)
    {
        if(!typesUtil)
        {
            typesUtil = [[TypesUtil alloc] init];
        }
        return typesUtil;
    }
}

- (NSArray *)getAllTypes
{
    if(!types || types.count < 1){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Types" ofType:@"plist"];
        types = [NSArray arrayWithContentsOfFile:path];
    }
    return types;
}

- (NSArray *)getTypesArray
{
    if(!typesArray || typesArray.count < 1){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TypesArray" ofType:@"plist"];
        typesArray = [NSArray arrayWithContentsOfFile:path];
    }
    return typesArray;
}
    
- (NSMutableDictionary *)getAllGoodsTypes
    {
        if(!goodsTypes)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"GoodsTypes" ofType:@"plist"];
            goodsTypes = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
        return goodsTypes;
    }
    
- (NSArray *)getGoodsWithType:(NSString *)type
    {
        [self getAllGoodsTypes];
        return [goodsTypes objectForKey:type];
    }

- (NSString *)getColorWithKey:(NSString *)key
{
    if(!colors)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
        colors = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    NSString *colorString = [colors objectForKey:key];
    return colorString;
}

- (NSMutableDictionary *)getAllTexts
{
    if(!typeTexts)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Alert" ofType:@"plist"];
        typeTexts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    return typeTexts;
}

- (NSString *)getTextWithKey:(NSString *)key
{
    if(!colors)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Alert" ofType:@"plist"];
        typeTexts = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    [self getAllTexts];
    NSString *text = [typeTexts objectForKey:key];
    return text;
}

- (NSArray *)getCommonGoods
{
    if(!commonArray)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CommonGoods" ofType:@"plist"];
        commonArray = [NSArray arrayWithContentsOfFile:path];
    }
    return commonArray;
}

@end
