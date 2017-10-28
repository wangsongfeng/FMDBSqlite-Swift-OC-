//
//  XiaoZhuManager.h
//  Swif-FMDB(数据库)
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteModel.h"
@interface XiaoZhuManager : NSObject

+(XiaoZhuManager*)shareManager;

//创建表
-(BOOL)creatDataBase;
//打开DataBase
-(BOOL)openDataBase;
//插入数据，手写的数据
-(BOOL)insertModelwith:(NSString*)name withLeftW:(NSInteger)leftW withTopH:(NSInteger)topH;
//获取所有数据库数据
-(NSMutableArray *)getAllNews;
//根据某条数据查询
-(SqliteModel*)searchImageNameWith:(NSString*)imageName;

@end
