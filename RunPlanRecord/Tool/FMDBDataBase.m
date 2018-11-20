//
//  FMDBDataBase.m
//  WMTempRunDataManager
//
//  Created by Windy on 2017/7/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMDBDataBase.h"
#import "FMDB.h"
#import "Singleton.h"
#import "WMRunDataRecord.h"

@implementation FMDBDataBase
//singleton_implementation(FMDBDataBase)

//创建数据库对象
static FMDatabase *db = nil;


//获取单例对象
+ (FMDBDataBase *)sharedInstance;
{
    static FMDBDataBase *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[FMDBDataBase alloc] init];
    });
    return manager;
}


-(instancetype)init
{
    if(self=[super init])
    {
        //初始化数据库对象
        [self openDataBase];
    }
    return self;
}

//打开数据库
- (void)openDataBase{
    
    //创建文件路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    documentPath = [documentPath stringByAppendingString:@"/tb_runRecord.sqlite"];
    NSLog(@"%@",documentPath);
    //1.初始化数据库对象
    db = [FMDatabase databaseWithPath:documentPath];
    //打开数据库，并判断是否打开了数据库 open 的返回类型是BOOL
    if ([db open]) {
        NSLog(@"数据库打开成功");
        NSString *sql = @"CREATE TABLE IF NOT EXISTS tb_runRecord (record_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, userId TEXT NOT NULL, month TEXT NOT NULL, creatTimeStamp LONG NOT NULL, creatTime TEXT NOT NULL, startTime TEXT NOT NULL, endTime TEXT NOT NULL, startTimeStamp TEXT NOT NULL, endTimeStamp TEXT NOT NULL,day INT NOT NULL, count INT NOT NULL, finshedCount INT NOT NULL, isMil INT NOT NULL, number INT NOT NULL, isFinished INT NOT NULL, finishNumber DOUBLE NOT NULL, progress DOUBLE NOT NULL)";
#warning 调试小数---------------------
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            NSLog(@"创建数据表成功");
        }else{
            NSLog(@"创建数据表失败");
        }
    }else{
        NSLog(@"数据库打开失败");
    }
}

//关闭数据库
- (void)closeDataBase{
    //关闭数据库
    NSLog(@"关闭数据库");
    [db close];
}

//增
- (void)insertData:(WMRunDataRecord *)runDataRecord{
    [db open];
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [db executeQuery:@"select *from tb_runRecord"];
    while ([set next]) {
       long creatTimeStamp = [set longForColumn:@"creatTimeStamp"];
        NSLog(@"---------%ld", creatTimeStamp);
        [array addObject:@(creatTimeStamp)];
    }
    if ([array containsObject:@(runDataRecord.creatTimeStamp)]) {
        return;
    }else{
        [db executeUpdate:@"insert into tb_runRecord (month,creatTimeStamp,creatTime,startTime,endTime,day,count,number,isFinished,hours,progress) values(?,?,?,?,?,?,?,?,?,?)",runDataRecord.month, runDataRecord.creatTimeStamp, runDataRecord.startTime, runDataRecord.endTime,
         runDataRecord.day, runDataRecord.count, runDataRecord.isFinished, runDataRecord.finishNumber, runDataRecord.progress];
    }
    [db close];
}

// 加强版增加
- (void)insertData:(WMRunDataRecord * _Nonnull)runDataRecord
           success:(nullable void (^)(id _Nullable responseObject))success
           failure:(nullable void (^)(id _Nullable errorObject))failure
{
    BOOL openData = [db open];
    if (openData) {
        NSString *sql = @"insert into tb_runRecord (userId,month,creatTimeStamp,creatTime,startTime,endTime,startTimeStamp,endTimeStamp,day,count,finshedCount, isMil,number,isFinished,finishNumber,progress) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        BOOL suc =  [db executeUpdate:sql,runDataRecord.userId,runDataRecord.month, @(runDataRecord.creatTimeStamp), runDataRecord.creatTime, runDataRecord.startTime, runDataRecord.endTime,runDataRecord.startTimeStamp, runDataRecord.endTimeStamp, @(runDataRecord.day), @(runDataRecord.count), @(runDataRecord.finshedCount), @(runDataRecord.isMil), @(runDataRecord.number), @(runDataRecord.isFinished), @(runDataRecord.finishNumber), @(runDataRecord.progress)];
        if (suc) {
            if (success) {
                NSDictionary *dict = @{@"status":@"0",@"info":@"数据添加成功！"};
                success(dict);
            }
        }else{
            if (success) {
                NSDictionary *dict = @{@"status":@"1",@"msg":@"数据添加失败！"};
                success(dict);
            }
        }
    }
   else{
        if (failure) {
            failure(@"打开数据库失败！");
        }
    }
    [db close];
}

-(void)deleteRunRecordWithcreatTimeStamp:(long)timeStamp;
{
    [db open];
    NSString *deletesql = @"delete from tb_runRecord where creatTimeStamp=?";
    BOOL ret = [db executeUpdate:deletesql,@(timeStamp)];
    if(!ret)
    {
        NSLog(@"删除用户失败:%@",db.lastErrorMessage);
    }
    [db close];
}

- (void)deleteRunRecordWithcreatTimeStamp:(NSString *_Nonnull)timeStamp
                                  success:(nullable void (^)(id _Nullable responseObject))success
                                  failure:(nullable void (^)(id _Nullable errorObject))failure{
    BOOL openData = [db open];
    if (openData) {
        BOOL suc = [db executeUpdate:@"delete from tb_runRecord where creatTimeStamp= ?", timeStamp];
        if (suc) {
            if (success) {
                NSDictionary *dict = @{@"status":@"0",@"info":@"数据删除成功！"};
                success(dict);
              }
        }else{
            if (success) {
                NSDictionary *dict = @{@"status":@"1",@"msg":@"数据删除失败！"};
                success(dict);
            }
      }
    }else{
        if (failure) {
            failure(@"打开数据库失败！");
        }
    }
    [db close];
}

//查
- (NSArray *)queryData{
    [db open];
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [db executeQuery:@"select *from tb_runRecord"];
    while ([set next]) {
        WMRunDataRecord *dataRecord = [WMRunDataRecord new];
        dataRecord.month = [set stringForColumn:@"month"];
        dataRecord.creatTimeStamp = [set longForColumn:@"creatTimeStamp"];
        dataRecord.creatTime = [set stringForColumn:@"creatTime"];
        dataRecord.startTime = [set stringForColumn:@"startTime"];
        dataRecord.endTime = [set stringForColumn:@"endTime"];
        dataRecord.startTimeStamp = [set stringForColumn:@"startTimeStamp"];
        dataRecord.endTimeStamp = [set stringForColumn:@"endTimeStamp"];
        dataRecord.day = [set intForColumn:@"day"];
        dataRecord.count = [set intForColumn:@"count"];
        dataRecord.finshedCount = [set intForColumn:@"finshedCount"];
        dataRecord.isMil = [set doubleForColumn:@"isMil"];
        dataRecord.number = [set intForColumn:@"number"];
        dataRecord.isFinished = [set doubleForColumn:@"isFinished"];
        dataRecord.finishNumber = [set doubleForColumn:@"finishNumber"];
        dataRecord.progress = [set doubleForColumn:@"progress"];
        [array addObject:dataRecord];
    }
    [db close];
    return array;
    
}

- (void)queryDataWithWithPageSize:(NSUInteger)pageSize
                             page:(NSInteger)page
                           userId:(NSString *)userId
                          success:(void (^_Nullable)(NSArray * _Nullable array))success
                          failure:(nullable void (^)(id _Nullable errorObject))failure
{
    BOOL openData = [db open];
    if (openData) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSString *sql = [NSString stringWithFormat:@"select *from tb_runRecord where userId='%@' order by creatTimeStamp desc limit %lu offset %lu*%ld", userId, (unsigned long)pageSize, (unsigned long)pageSize, page];
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            WMRunDataRecord *dataRecord = [WMRunDataRecord new];
            dataRecord.userId = [set stringForColumn:@"userId"];
            dataRecord.month = [set stringForColumn:@"month"];
            dataRecord.creatTimeStamp = [set longForColumn:@"creatTimeStamp"];
            dataRecord.creatTime = [set stringForColumn:@"creatTime"];
            dataRecord.startTime = [set stringForColumn:@"startTime"];
            dataRecord.endTime = [set stringForColumn:@"endTime"];
            dataRecord.startTimeStamp = [set stringForColumn:@"startTimeStamp"];
            dataRecord.endTimeStamp = [set stringForColumn:@"endTimeStamp"];
            dataRecord.day = [set intForColumn:@"day"];
            dataRecord.count = [set intForColumn:@"count"];
            dataRecord.finshedCount = [set intForColumn:@"finshedCount"];
            dataRecord.isMil = [set intForColumn:@"isMil"];
            
#warning 调试小数---------------------
            dataRecord.number = [set intForColumn:@"number"];
      //      dataRecord.number = [set doubleForColumn:@"number"];
            
            dataRecord.isFinished = [set intForColumn:@"isFinished"];
            dataRecord.finishNumber = [set doubleForColumn:@"finishNumber"];
            dataRecord.progress = [set doubleForColumn:@"progress"];
            [tempArray addObject:dataRecord];
        }
        if (success) {
            success(tempArray);
        }
    }else{
        if (failure) {
             failure(@"打开数据库失败！");
        }
    }
    
    [db close];
}

//改
- (void)updateRunRecordProgress:(double)progress
                   finshedCount:(NSUInteger)finshedCount
                   finishNumber:(double)finishNumber
                     isFinished:(NSUInteger)isFinished
                 creatTimeStamp:(long)creatTimeStamp
                         userId:(NSString *_Nullable)userId{
    [db open];
    NSString *updatesql= @"update tb_runRecord set progress=?,finshedCount=?,finishNumber=?,isFinished=? where creatTimeStamp=? and userId=?";
    BOOL ret = [db executeUpdate:updatesql,@(progress),@(finshedCount),@(finishNumber), @(isFinished),@(creatTimeStamp),userId];
    if(!ret){
        NSLog(@"修改记录失败:%@",db.lastErrorMessage);
    }
    [db close];
}

+ (NSString *)transform:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}
@end
