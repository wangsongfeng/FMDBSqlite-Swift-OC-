//
//  XiaoZhuManager.m
//  Swif-FMDB(数据库)
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "XiaoZhuManager.h"
#import "FMDB.h"
#import "SqliteModel.h"
@interface XiaoZhuManager()
{
    FMDatabase * database;
}
@property(nonatomic,copy)NSString * filePath;
@property(nonatomic,strong)NSMutableArray<SqliteModel*> * sqliteModelArray;

@end
@implementation XiaoZhuManager
+(XiaoZhuManager*)shareManager{
    
    static XiaoZhuManager * manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XiaoZhuManager alloc]init];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        // 获得Documents目录路径
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 文件路径
        self.filePath = [documentsPath stringByAppendingPathComponent:@"xiaozhu.sqlite"];
        NSLog(@"%@",self.filePath);
    }
    return self;
}
//创建表
-(BOOL)creatDataBase{
    
    BOOL creat = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSLog(@"文件夹存在");
    }else{
        NSLog(@"文件不存在");
        database = [FMDatabase databaseWithPath:self.filePath];
        if (database != nil) {
            if ([database open]) {
               BOOL success =  [database executeUpdate:@"create table if not exists XiaoZhu (imageName text NOT NULL, leftWidth integer NOT NULL, leftHeight integer NOT NULL)"];
                if (success) {
                    creat = YES;
                    NSLog(@"创建表成功");
                }
            }
        }
    }
    
    return creat;
}
-(BOOL)openDataBase{
    if (database == nil) {
        if ([[NSFileManager defaultManager]fileExistsAtPath:self.filePath]) {
            database = [FMDatabase databaseWithPath:self.filePath];
        }
    }
    if (database!=nil) {
        if ([database open]) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)insertModelwith:(NSString*)name withLeftW:(NSInteger)leftW withTopH:(NSInteger)topH{
    BOOL insert = NO;
    if ([database open]) {
        [database beginTransaction];
        BOOL isRollBack = NO;
        @try {
            [database executeUpdateWithFormat:@"insert into XiaoZhu(imageName,leftWidth,leftHeight) values(%@,%ld,%ld)",name,leftW,topH];
            insert = YES;
        }
        @catch(NSException * exception) {
            isRollBack = YES;
            [database rollback];
        }@finally {
            if (!isRollBack) {
                [database commit];
            }
        }
    }
    return insert;
    [database close];
}

//获取所有数据库数据
-(NSMutableArray *)getAllNews{
    self.sqliteModelArray = [NSMutableArray array];
    if ([database open]) {
        FMResultSet * results = [database executeQuery:@"SELECT * FROM XiaoZhu"];
        while ([results next]) {
            SqliteModel * model = [[SqliteModel alloc]init];
            model.imageName = [results stringForColumn:@"imageName"];
            model.leftW = [[results stringForColumn:@"leftWidth"] integerValue];
            model.topH = [[results stringForColumn:@"leftHeight"]integerValue];
            [self.sqliteModelArray addObject:model];
            NSLog(@"搜索成功");
        }
        NSLog(@"搜索失败");
    }else{
        NSLog(@"没打开");
    }
    [database close];
    return self.sqliteModelArray;
}

//根据某条数据查询
-(SqliteModel*)searchImageNameWith:(NSString*)imageName{
    SqliteModel * model;

    if ([database open]) {
        NSString * query=[NSString stringWithFormat:@"select * from XiaoZhu where imageName= '%@'",imageName];
        FMResultSet *result = [database executeQuery:query];
        while ([result next]) {
            model =[[SqliteModel alloc]init];
            model.imageName = [result stringForColumn:@"imageName"];
            model.leftW = [[result stringForColumn:@"leftWidth"]integerValue];
            model.topH = [[result stringForColumn:@"leftHeight"]integerValue];
            
        }
    }
    return  model;

}



@end
