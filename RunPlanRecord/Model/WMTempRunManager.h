//
//  WMTempRunManager.h
//  WMTempRunDataManager
//
//  Created by Windy on 2017/7/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TempRunMannger [WMTempRunManager sharedDefault]

@class WMRunDataRecord;

@interface WMTempRunManager : NSObject

@property (nonatomic, copy) NSString *key;//密匙唯一标识

+(WMTempRunManager *)sharedDefault;


-(void)archivedRunDataRecord:(WMRunDataRecord *)dataRecord;

-(WMRunDataRecord *)unarchiveRunDataRecord;

@end
