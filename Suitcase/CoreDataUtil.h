//
//  CoreDataUtil.h
//  Suitcase
//
//  Created by 罗若峰 on 13-10-18.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataUtil : NSObject

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *results;

+ (id)shareTypesUtil;
- (void) initCoreData;
@end
