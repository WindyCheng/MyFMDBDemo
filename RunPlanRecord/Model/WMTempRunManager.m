//
//  WMTempRunManager.m
//  WMTempRunDataManager
//
//  Created by Windy on 2017/7/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "WMTempRunManager.h"
#import "WMRunDataRecord.h"

static  NSString *const kUserkey = @"key";
static  NSString *const kRunRecord = @"runRecord";
@implementation WMTempRunManager

+ (WMTempRunManager *)sharedDefault{
    static WMTempRunManager *runData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runData = [[self alloc] init];
    });
    return runData;
}

-(void)archivedRunDataRecord:(WMRunDataRecord *)dataRecord{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataRecord];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setObject:data forKey:kRunRecord];
    [userInfo synchronize];
}

-(WMRunDataRecord *)unarchiveRunDataRecord{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSData *data = [userInfo objectForKey:kRunRecord];
    WMRunDataRecord *record =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return record;
}


#pragma mark - set
-(void)setKey:(NSString *)key{
    if (key == nil||[key isKindOfClass:[NSNull class]]) {
        key = @"";
    }
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:kUserkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - get
- (NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserkey];
}

@end
