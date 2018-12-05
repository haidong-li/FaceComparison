//
//  DataBaseManager.m
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import "DataBaseManager.h"
#import <FMDB/FMDB.h>
#import <objc/runtime.h>
#import "UserModel.h"
#import "HistoryModel.h"
@interface DataBaseManager ()


@property (nonatomic,copy) NSArray *works;
@property (nonatomic,copy) NSArray *features;

@end

@implementation DataBaseManager

+ (instancetype)shareInstance
{
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docuPath stringByAppendingPathComponent:@"workers.db"];
        NSString *historyPath = [docuPath stringByAppendingPathComponent:@"history"];
        
        _user = [FMDatabase databaseWithPath:dbPath];
        [_user open];
        if (![_user open]) {
            NSLog(@"db open fail");
        }
        NSLog(@"%@",docuPath);
        //4.数据库中创建表（可创建多张）
        NSString *sql = @"create table if not exists Users ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT  NULL, 'workNum' TEXT UNIQUE NOT NULL ,'department' TEXT  NULL, 'phone' TEXT  NULL,'company' TEXT  NULL,'idCard' TEXT  NULL,'typeOfWork' TEXT  NULL,'startTime' DATETIME  NULL,'endTime' DATETIME  NULL,'role' TEXT  NULL,'riskLevel' TEXT  NULL,'feature0' TEXT NOT NULL,'feature1' TEXT NOT NULL,'feature2' TEXT NOT NULL,'feature3' TEXT NOT NULL,'feature4' TEXT NOT NULL,'feature5' TEXT NOT NULL,'feature6' TEXT NOT NULL,'feature7' TEXT NOT NULL,'feature8' TEXT NOT NULL,'headImage' TEXT  NULL,'createTime' DATETIME  NULL,'updateTime' DATETIME  NULL)";
        BOOL result = [_user executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
            
        }
        [_user close];
        
        //顺便创建个头像的路径
        NSString *imagePath = [docuPath stringByAppendingPathComponent:@"userImages"];
        _imagePath = imagePath;
        BOOL isDir = NO;
        BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:&isDir];
        if (!(isDir && existed)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *historyImagePath = [historyPath stringByAppendingPathComponent:@"historyImages"];
        _historyImagePath = historyImagePath;
        BOOL ok = [[NSFileManager defaultManager] fileExistsAtPath:historyImagePath isDirectory:&isDir];
        if (!(isDir && ok)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:historyImagePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [self craeteHistoryDB];
    }
    return self;
}

- (BOOL)craeteHistoryDB
{
    
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *historyPath = [docuPath stringByAppendingPathComponent:@"history"];
    
    BOOL isDir = NO;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:[historyPath stringByAppendingPathComponent:@""] isDirectory:&isDir];
    if (!(isDir && existed)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:historyPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *dbPath = [historyPath stringByAppendingPathComponent:@"history.db"];
    _history = [FMDatabase databaseWithPath:dbPath];
    [_history open];
    if (![_history open]) {
        NSLog(@"db open fail");
    }
    NSLog(@"%@",docuPath);
    //4.数据库中创建表（可创建多张）
    //获取当前时间并格式化 2018-01
    NSString *currentTime = [[self getCurrentTimes] substringToIndex:7];
    _currentHistoryTable = [NSString stringWithFormat:@"history_%@",currentTime];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'workNum' TEXT NOT NULL ,'typeOfWork' TEXT NOT NULL,'score' TEXT NOT NULL,'facePostion' TEXT NOT NULL,'clockTime' DATETIME UNIQUE NOT NULL)",_currentHistoryTable];
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [_history executeUpdate:sql];
    [_history close];

    if (result) {
        NSLog(@"create history table success");
        
    }else
    {
        return NO;
    }
    
    NSString *imagePath = [_historyImagePath stringByAppendingPathComponent:_currentHistoryTable];
    BOOL ok = [[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:&isDir];
    if (!(isDir && ok)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}


- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY_MM_dd_HH_mm"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    
    return currentTimeString;
    
}

- (NSArray *)getPersonalFilteredClockTimeWithTableName:(NSString *)tableName
{
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:0];
    if ([_history open]) {
        NSString *sql = [NSString stringWithFormat:@"select *, min(clockTime) minClockTime,max(clockTime) maxClockTime ,max(score) maxScore from %@ group by workNum date(clockTime)",tableName];
        
        FMResultSet *rs = [_history executeQuery:sql];
        
        while ([rs next]) {
            
            HistoryModel *historyCell = [[HistoryModel alloc] init];
            historyCell.tableName = tableName;
            unsigned int count;
            objc_property_t *propertyList = class_copyPropertyList([HistoryModel class], &count);
            for (unsigned int i = 0; i<count; i++) {
                const char *propertyName = property_getName(propertyList[i]);
                
                NSString *property = [NSString stringWithUTF8String:propertyName];
                if ([property isEqualToString:@"imageSrc"] || [property isEqualToString:@"historyImage"] || [property isEqualToString:@"tableName"] || [property isEqualToString:@"minClockTime"] || [property isEqualToString:@"minClockTime"] || [property isEqualToString:@"maxScore"]) {
                    continue;
                }
                NSString *sqlValue = [rs stringForColumn:property];
                
                [historyCell setValue:sqlValue forKey:property];
                
            }
            [users addObject:historyCell];

        }
    }
    [_history close];
    return users;
}


- (void)insertModel:(id)model toTable:(NSString *)tableName db:(FMDatabase *)db finish:(void(^)(BOOL ret))finish
{
    __weak typeof(self) weakSelf = self;
    __block NSString *blockTableName = tableName;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        
        if (db == weakSelf.history) {
            NSString *currentTime = [[self getCurrentTimes] substringToIndex:7];
            NSString *currentHistoryTable = [NSString stringWithFormat:@"history_%@",currentTime];
            if (![currentHistoryTable isEqualToString:self.currentHistoryTable]) {
                
                NSArray *historyList = [self historyList];
                if (![historyList containsObject:currentTime]) {
                    [self craeteHistoryDB];
                    blockTableName = weakSelf.currentHistoryTable;
                }
            }
        }
        
        if (![db open]) {
            NSLog(@"db open fail");
        }
        unsigned int count;
        // 获取属性列表
        NSMutableString *property = [NSMutableString string];
        NSMutableString *countStr = [NSMutableString string];
        NSMutableArray *arguments = [NSMutableArray array];
        
        objc_property_t *propertyList = class_copyPropertyList([model class], &count);
        for (unsigned int i = 0; i<count; i++) {
            const char *propertyName = property_getName(propertyList[i]);
            
            id value = [model valueForKey:[NSString stringWithUTF8String:propertyName]];
            
            if (value && [value isKindOfClass:[NSString class]]) {
                [arguments addObject:value];
                [property appendString:[NSString stringWithFormat:@"%@,",[NSString stringWithUTF8String:propertyName]]];
                [countStr appendString:@"?,"];
            }
        }
        
        //删除最后一个逗号
        
        NSString *pStr = [property substringToIndex:([property length]-1)];
        NSString *cStr = [countStr substringToIndex:([countStr length]-1)];
        //    NSString *arguments = [userModel allPropertyValue];
        BOOL ret = [db executeUpdate:[NSString stringWithFormat:@"insert into '%@'(%@) values(%@)",blockTableName,pStr,cStr] withArgumentsInArray:arguments];
        [db close];
        if (finish) {
            finish(ret);
        }
    });
}


//-(NSInteger)getAllDataCount{
//    NSString *sql = [NSString stringWithFormat:@"select count(*) count from workTable"];
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    FMResultSet *rs = [_user executeQuery:sql];
//
//}

- (NSArray *)selecetUserWithKey:(NSString *)key value:(NSString *)value fromTable:(NSString *)tableName className:(NSString *)className
{
    if ([_user open]) {
        FMResultSet *rs = [_user executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'",tableName,key,value]];
        NSMutableArray *users = [NSMutableArray arrayWithCapacity:0];
        while ([rs next]) {
            
            id user = [[NSClassFromString(className) alloc] init];
            unsigned int count;
            objc_property_t *propertyList = class_copyPropertyList(NSClassFromString(className) , &count);
            for (unsigned int i = 0; i<count; i++) {
                const char *propertyName = property_getName(propertyList[i]);
                NSString *property = [NSString stringWithUTF8String:propertyName];
                if ([property isEqualToString:@"imageSrc"]) {
                    continue;
                }
                
                
                NSString *sqlValue = [rs stringForColumn:property];
                
                [user setValue:sqlValue forKey:property];
            }
            
            [users addObject:user];
        }
        return users;
    }
    
    return nil;
}

- (NSArray <UserModel *>*)allUsers
{
    [_user open];
    FMResultSet *rs = [_user executeQuery:@"SELECT * FROM Users ORDER BY workNum ASC"];
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:0];
    [self.currentFeature0 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature1 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature2 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature3 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature4 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature5 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature6 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature7 removeAllObjects]; //>? 移除内存中的特征
    [self.currentFeature8 removeAllObjects]; //>? 移除内存中的特征
    
    while ([rs next]) {
        
        UserModel *user = [[UserModel alloc] init];
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([UserModel class], &count);
        for (unsigned int i = 0; i<count; i++) {
            const char *propertyName = property_getName(propertyList[i]);
            
            NSString *property = [NSString stringWithUTF8String:propertyName];
            if ([property isEqualToString:@"imageSrc"]) {
                continue;
            }
            NSString *sqlValue = [rs stringForColumn:property];
            
            [user setValue:sqlValue forKey:property];
            
            if ([property isEqualToString:@"feature0"]) {
                NSArray *fea0 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature0 addObject:fea0 ?: @""];
            }
            
            if ([property isEqualToString:@"feature1"]) {
                NSArray *fea1 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature1 addObject:fea1 ?: @""];
            }
            
            if ([property isEqualToString:@"feature2"]) {
                NSArray *fea2 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature2 addObject:fea2 ?: @""];
            }
            
            if ([property isEqualToString:@"feature3"]) {
                NSArray *fea3 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature3 addObject:fea3 ?: @""];
            }
            
            if ([property isEqualToString:@"feature4"]) {
                NSArray *fea4 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature4 addObject:fea4 ?: @""];
            }
            
            if ([property isEqualToString:@"feature5"]) {
                NSArray *fea5 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature5 addObject:fea5 ?: @""];
            }
            
            if ([property isEqualToString:@"feature6"]) {
                NSArray *fea6 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature6 addObject:fea6 ?: @""];
            }
            
            if ([property isEqualToString:@"feature7"]) {
                NSArray *fea7 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature7 addObject:fea7 ?: @""];
            }
            
            if ([property isEqualToString:@"feature8"]) {
                NSArray *fea8 = [sqlValue componentsSeparatedByString:@","];
                [self.currentFeature8 addObject:fea8 ?: @""];
            }
        }
        
        [users addObject:user];
    }
    [_user close];
    return users;
}

- (BOOL)deleteUser:(UserModel *)userModel
{
    [_user open];
    
    BOOL ret = [_user executeUpdate:@"DELETE FROM Users WHERE workNum = ?",userModel.workNum];
    
    [_user close];
    
    return ret;
}

- (NSArray *)historyList
{
    NSMutableArray *tables = [NSMutableArray arrayWithCapacity:0];
    if ([_history open]) {
        
        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        
        resultSet = [_history executeQuery:@"SELECT * FROM sqlite_master where type='table';"];
        // 遍历查询结果
        while (resultSet.next) {
            
            NSString *tableName = [resultSet stringForColumnIndex:1];
            if ([tableName isEqualToString:@"sqlite_sequence"]) {
                continue;
            }
            [tables addObject:tableName];
        }
    }
    [_history close];
    
    [tables sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int value1 = [[[obj1 stringByReplacingOccurrencesOfString:@"history" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@""] intValue];
        int value2 = [[[obj2 stringByReplacingOccurrencesOfString:@"history" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@""] intValue];
        if (value1 > value2) {
            return NSOrderedAscending;
        }else if (value1 == value2){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
        
    }];
    
    return [NSArray arrayWithArray:tables];
}


 - (NSArray<HistoryModel *> *)allHistoryWithTableName:(NSString *)tableName
{
    NSMutableArray *historyArr = [NSMutableArray arrayWithCapacity:0];
    if ([_history open]) {
        FMResultSet *rs = [_history executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY clockTime DESC",tableName]];
        
        while ([rs next]) {
            
            HistoryModel *historyCell = [[HistoryModel alloc] init];
            historyCell.tableName = tableName;
            unsigned int count;
            objc_property_t *propertyList = class_copyPropertyList([HistoryModel class], &count);
            for (unsigned int i = 0; i<count; i++) {
                const char *propertyName = property_getName(propertyList[i]);
                
                NSString *property = [NSString stringWithUTF8String:propertyName];
                if ([property isEqualToString:@"imageSrc"] || [property isEqualToString:@"historyImage"] || [property isEqualToString:@"tableName"] || [property isEqualToString:@"minClockTime"] || [property isEqualToString:@"maxClockTime"] || [property isEqualToString:@"maxScore"]) {
                    continue;
                }
                NSString *sqlValue = [rs stringForColumn:property];
                
                [historyCell setValue:sqlValue forKey:property];
                
            }
            
            [historyArr addObject:historyCell];
        }
    };
    
    [_history close];
    return historyArr;
}


// 删除表
- (BOOL) deleteHistoryTable:(NSString *)tableName
{
    if ([_history open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        if (![_history executeUpdate:sqlstr])
        {
            return NO;
        }
        
        
        NSString *imagePath = [_historyImagePath stringByAppendingPathComponent:tableName];
        BOOL fileRet = [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        if (!fileRet) {
            return NO;
        }
        [_history close];
        return YES;
    }else
    {
        return NO;
    }
    
}

- (NSMutableArray *)currentFeature0
{
    if (!_currentFeature0) {
        _currentFeature0 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature0;
}

- (NSMutableArray *)currentFeature1
{
    if (!_currentFeature1) {
        _currentFeature1 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature1;
}

- (NSMutableArray *)currentFeature2
{
    if (!_currentFeature2) {
        _currentFeature2 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature2;
}

- (NSMutableArray *)currentFeature3
{
    if (!_currentFeature3) {
        _currentFeature3 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature3;
}

- (NSMutableArray *)currentFeature4
{
    if (!_currentFeature4) {
        _currentFeature4 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature4;
}

- (NSMutableArray *)currentFeature5
{
    if (!_currentFeature5) {
        _currentFeature5 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature5;
}

- (NSMutableArray *)currentFeature6
{
    if (!_currentFeature6) {
        _currentFeature6 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature6;
}
- (NSMutableArray *)currentFeature7
{
    if (!_currentFeature7) {
        _currentFeature7 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature7;
}
- (NSMutableArray *)currentFeature8
{
    if (!_currentFeature8) {
        _currentFeature8 = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentFeature8;
}
@end
