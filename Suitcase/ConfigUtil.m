//
//  ConfigUtil.m
//  Suitcase
//
//  Created by 罗若峰 on 13-11-8.
//  Copyright (c) 2013年 若峰. All rights reserved.
//

#import "ConfigUtil.h"

@implementation ConfigUtil

static ConfigUtil *configUtil = nil;
static NSMutableDictionary *dict = nil;
static NSString *FILE_PATH = nil;
#define FILE_NAME @"InitConfig"

+ (id)shareConfigUtil
{
    @synchronized(self)
    {
        if(!configUtil)
        {
            configUtil = [[ConfigUtil alloc] init];
        }
        return configUtil;
    }
}

- (void)createDict
{
    if(!dict)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        FILE_PATH = [[documentsDirectory stringByAppendingPathComponent:FILE_NAME] stringByAppendingPathExtension:@"plist"];
        BOOL isDocumentFileExists = [[NSFileManager defaultManager] fileExistsAtPath:FILE_PATH];
        
        if (!isDocumentFileExists) {
            NSString *file = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:@"plist"];
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtPath:file toPath:FILE_PATH error:&error];
        }
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:FILE_PATH];
    }
}

- (Boolean)getBoolValueWithKey:(NSString *)key
{
    [self createDict];
    id obj = [dict objectForKey:key];
    if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *numberValue = (NSNumber *)obj;
        return [numberValue boolValue];
    }
    return (Boolean)obj;
}

- (void)changeBoolValue:(BOOL)value WithKey:(NSString *)key
{
    [self createDict];
    [dict setObject:[NSNumber numberWithBool:value] forKey:key];
    [dict writeToFile:FILE_PATH atomically:YES];
}



@end
