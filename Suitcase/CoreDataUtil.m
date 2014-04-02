//
//  CoreDataUtil.m
//  Suitcase
//
//  Created by 罗若峰 on 13-10-18.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "CoreDataUtil.h"

@implementation CoreDataUtil

#define STOREPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/Model.sqlite"]

static CoreDataUtil *coreDataUtil = nil;

+ (id)shareTypesUtil
{
    @synchronized(self)
    {
        if(!coreDataUtil)
        {
            coreDataUtil = [[CoreDataUtil alloc] init];
            
        }
        return coreDataUtil;
    }
}


- (void) initCoreData
{
    if(!self.context)
    {
        NSError *error;
        NSURL *url = [NSURL fileURLWithPath:STOREPATH];
        
        // Init the model, coordinator, context
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
            NSLog(@"Error: %@", [error localizedDescription]);
        else
        {
            self.context = [[NSManagedObjectContext alloc] init];
            [self.context setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
}



@end
