//
//  Transation.swift
//  Swif-FMDB(数据库)
//
//  Created by apple on 2017/10/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

import UIKit

class Transation: NSObject {

}
/*    FMDB事务的使用
 *     首先，说一下事务是什么，比如说我们有一个学生表和一个学生成绩表，而且一个学生对应一个学生成绩。比如小明的成绩是100分，那么我们要写两个sql语句对不同的表进行插入数据。但是如果在这个过程中，小明这个学生成功的插入到数据库，而成绩插入时失败了，怎么办？这时事务就突出了它的作用。用事务可以对两个表进行同时插入，一旦一个表插入失败，那么就会进行事务回滚，就是让另一个表也不进行插入数据了。
 简单的说也就是，事务可以让多个表的数据同时插入，一旦有一个表操作失败，那么其他表也都会失败。当然这种说法是为了理解，不是严谨的。
 那么对一个表大量插入数据时也可以用事务。比如sqlite3。
 数据库 中 insert into 语句等操作是比较耗时的，假如我们一次性插入几百几千条数据就会造成主线程阻塞，以至于ui界面卡住。那么这时候我们就要开启一个事物来进行操作。
 原因就是它以文件的形式存在磁盘中，每次访问时都要打开一次文件，如果对数据库进行大量的操作，就很慢。可是如果我们用事物的形式提交，开始事务后，进行的大量操作语句都保存在内存中，当提交时才全部写入数据库，此时，数据库文件也只用打开一次。如果操作错误，还可以回滚事务。
 *
 *
 */


/* //事务
 -(void)shiwu
 {
       BOOL isSuccess=[_dataBase open];
       if (!isSuccess) {
          HSLog(@"打开数据库失败");
       }
         [_dataBase beginTransaction];
         BOOL isRollBack = NO;
         @try {
              for (int i = 0; i<500; i++) {
                  NSString *nId = [NSString stringWithFormat:@"%d",i];
                  NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
                  NSString *sql = @"INSERT INTO Student (id,student_name) VALUES (?,?)";
                  BOOL a = [_dataBase executeUpdate:sql,nId,strName];
            if (!a) {
               NSLog(@"插入失败1");
            }
          }
         }
           @catch (NSException *exception) {
                 isRollBack = YES;
                 [_dataBase rollback];
           }
             @finally {
                if (!isRollBack) {
                   [_dataBase commit];
                }
         }
               [_dataBase close];
 
 }
 *
 */
//FMDB多线程操作时：
//事务
//事务
//-(void)shiwu
//    {
//        [_dataBase inTransaction:^(FMDatabase *db, BOOL  *rollback) {
//            for (int i = 0; i<500; i++) {
//                NSString *nId = [NSString stringWithFormat:@"%d",i];
//            NSString *strName = [[NSString alloc] initWithFormat:@"student_%d",i];
//            NSString *sql = @"INSERT INTO Student (id,student_name) VALUES (?,?)";
//            BOOL a = [db executeUpdate:sql,nId,strName];
//            if (!a) {
//            *rollback = YES;
//            return;
//            }
//            }
//            }];
//
//}

