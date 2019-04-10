//
//  DataBaseManager.h
//  FaceComparison
//
//  Created by hfjk on 2018/11/13.
//  Copyright © 2018 Huafu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UserModel;
@class HistotyModel;
@class FMDatabase;

@interface DataBaseManager : NSObject

@property (nonatomic,strong) FMDatabase *user;
@property (nonatomic,strong) FMDatabase *history;

@property (nonatomic,copy) NSMutableArray *currentFeature0; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature1; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature2; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature3; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature4; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature5; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature6; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature7; //>?
@property (nonatomic,copy) NSMutableArray *currentFeature8; //>?

@property (nonatomic,copy) NSString *imagePath; //>? 图片存储路径
@property (nonatomic,copy) NSString *historyImagePath;
@property (nonatomic,copy) NSString *currentHistoryTable;

+ (instancetype)shareInstance;
- (NSArray *)getPersonalFilteredClockTimeWithTableName:(NSString *)tableName;
- (void)insertModel:(id)model toTable:(NSString *)tableName db:(FMDatabase *)db finish:(void(^)(BOOL ret))finish;
- (NSArray <UserModel *>*)allUsers;
- (NSArray *)selecetUserWithKey:(NSString *)key value:(NSString *)value fromTable:(NSString *)tableName className:(NSString *)className;
- (BOOL)deleteUser:(UserModel *)userModel;
- (BOOL)deleteHistoryTable:(NSString *)tableName;
- (NSArray *)historyList;
- (NSArray <HistotyModel *>*)allHistoryWithTableName:(NSString *)tableName;
- (void)open:(FMDatabase *)db;
- (void)close:(FMDatabase *)db;
@end
