//
//  ViewController.swift
//  Swif-FMDB(数据库)
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 yangchao. All rights reserved.
//

/*
 FMDB有三个主要的类
 
 FMDatabase
 一个FMDatabase对象就代表一个单独的SQLite数据库用来执行SQL语句
 
 FMResultSet
 使用FMDatabase执行查询后的结果集
 
 FMDatabaseQueue
 用于在多线程中执行多个查询或更新，它是线程安全的
 
 **/

import UIKit

struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}
class ViewController: UIViewController {

    var movies : [MovieInfo]!
    var sqliteModel = [SqliteModel]!.self
    var array : NSMutableArray?
    var model : SqliteModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        movies = SqliteManager.shareInstance.loadmovies()
        print(movies[3].title)
        
        let manager = XiaoZhuManager.share()
        if (manager?.creatDataBase())! {
            manager?.insertModelwith("first", withLeftW: 100, withTopH: 200)
            manager?.insertModelwith("two", withLeftW: 300, withTopH: 136)
            manager?.insertModelwith("three", withLeftW: 234, withTopH: 999)
        
         }
        array = NSMutableArray()
        if XiaoZhuManager.share().openDataBase() {
            array = XiaoZhuManager.share().getAllNews()
            print(array!.count)
            
            model = SqliteModel()
            model =  XiaoZhuManager.share().searchImageName(with: "first")
            print(model.leftW)

        }
       
    }
    override func viewWillAppear(_ animated: Bool) {

    }
}

