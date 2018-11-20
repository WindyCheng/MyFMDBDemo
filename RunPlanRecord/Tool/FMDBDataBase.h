//
//  FMDBDataBase.h
//  WMTempRunDataManager
//
//  Created by Windy on 2017/7/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

#define kTb_runRecord @"tb_runRecord"

@class WMRunDataRecord;
@interface FMDBDataBase : NSObject
//singleton_interface(FMDBDataBase);


//获取单例对象
+(FMDBDataBase *_Nullable)sharedInstance;

//打开数据库
- (void)openDataBase;

//关闭数据库
- (void)closeDataBase;

//增
- (void)insertData:(WMRunDataRecord *_Nullable)runDataRecord;

// 加强版增加
- (void)insertData:(WMRunDataRecord * _Nonnull)runDataRecord
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure;


-(void)deleteRunRecordWithcreatTimeStamp:(long)timeStamp;

// 删除增强版
- (void)deleteRunRecordWithcreatTimeStamp:(NSString *_Nonnull)timeStamp
                                  success:(nullable void (^)(id _Nullable responseObject))success
                                  failure:(nullable void (^)(id _Nullable errorObject))failure;

//查
- (NSArray *_Nullable)queryData;

- (void)queryDataWithWithPageSize:(NSUInteger)pageSize
                             page:(NSInteger)page
                           userId:(NSString *_Nullable)userId
                          success:(void (^_Nullable)(NSArray * _Nullable array))success
                          failure:(nullable void (^)(id _Nullable errorObject))failure;

//改
- (void)updateRunRecordProgress:(double)progress
                   finshedCount:(NSUInteger)finshedCount
                   finishNumber:(double)finishNumber
                     isFinished:(NSUInteger)isFinished
                 creatTimeStamp:(long)creatTimeStamp
                         userId:(NSString *_Nullable)userId;

@end
