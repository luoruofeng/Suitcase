//
//  Suitcase.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-29.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goods;

@interface Suitcase : NSManagedObject

@property (nonatomic, retain) NSDate * create;
@property (nonatomic, retain) NSDate * dateOfDeparture;
@property (nonatomic, retain) NSNumber * insideNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * outsideNumber;
@property (nonatomic, retain) NSNumber * typeId;
@property (nonatomic, retain) NSOrderedSet *goodss;
@end

@interface Suitcase (CoreDataGeneratedAccessors)

- (void)insertObject:(Goods *)value inGoodssAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGoodssAtIndex:(NSUInteger)idx;
- (void)insertGoodss:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGoodssAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGoodssAtIndex:(NSUInteger)idx withObject:(Goods *)value;
- (void)replaceGoodssAtIndexes:(NSIndexSet *)indexes withGoodss:(NSArray *)values;
- (void)addGoodssObject:(Goods *)value;
- (void)removeGoodssObject:(Goods *)value;
- (void)addGoodss:(NSOrderedSet *)values;
- (void)removeGoodss:(NSOrderedSet *)values;
@end
