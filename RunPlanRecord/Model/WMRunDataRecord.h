//
//  WMRunDataRecord.h
//  WMTempRunDataManager
//
//  Created by Windy on 2017/7/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMRunDataRecord : NSObject

@property(nonatomic, copy)NSString *month;   //年月

@property(nonatomic, copy)NSString *userId;   //用户id

@property(assign, nonatomic) long creatTimeStamp; //创建时间戳

@property(nonatomic, copy)NSString *creatTime;   //创建日期(年月）

@property(nonatomic, copy)NSString *startTime;   //开始日期字符串

@property(nonatomic, copy)NSString *endTime;      //结束日期字符串

@property(nonatomic, copy)NSString *startTimeStamp;    //开始时间戳

@property(nonatomic, copy)NSString *endTimeStamp;      //结束时间戳

@property(nonatomic, assign)NSUInteger day;             //计划跑步天数

@property(nonatomic, assign)NSUInteger count;            //计划跑步次数

@property(nonatomic, assign)NSUInteger finshedCount;      //完成跑步次数

@property(nonatomic, assign)NSUInteger isMil;      //是否公里

#warning 调试小数---------------------
@property(nonatomic, assign)NSUInteger number;      //计划公里数或小时数
//@property(nonatomic, assign)double number;      //计划公里数或小时数


@property(nonatomic, assign)NSUInteger isFinished;   //是否完成 0:进行中; 1:成功； 2:完成  3:失败

@property(nonatomic, assign)double finishNumber;      //完成公里数或小时数

@property(nonatomic, assign)double progress;          //完成进度




@end
