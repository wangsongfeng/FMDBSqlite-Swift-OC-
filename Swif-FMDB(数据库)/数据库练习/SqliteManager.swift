//
//  SqliteManager.swift
//  Swif-FMDB(数据库)
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 yangchao. All rights reserved.
//

import UIKit

class SqliteManager: NSObject {

    let file_MovieID = "movieID"
    let field_MovieTitle = "title"
    let field_MovieCategory = "category"
    let field_MovieYear = "year"
    let field_MovieURL = "movieURL"
    let field_MovieCoverURL = "coverURL"
    let field_MovieWatched = "watched"
    let field_MovieLikes = "likes"
    
    //单例
    static let shareInstance : SqliteManager = SqliteManager()
    var pathToDataBase: String!
    var database: FMDatabase!
    
    override init() {
        super.init()
        let  documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDataBase = documentDirectory.appending("/wang.sqlite")
        print(pathToDataBase)
        
    }
    
    func createDatabase() -> Bool {
        var create = false
        //判断是否为文件夹
        if !FileManager.default.fileExists(atPath: pathToDataBase!) {
            database = FMDatabase.init(path: pathToDataBase)
            
            if database != nil {
                if database.open() {
                    let creatTableMovie = "create table movies (\(file_MovieID) integer primary key autoincrement not null, \(field_MovieTitle) text not null, \(field_MovieCategory) text not null, \(field_MovieYear) integer not null, \(field_MovieURL) text, \(field_MovieCoverURL) text not null, \(field_MovieWatched) bool not null default 0, \(field_MovieLikes) integer not null)"
                    do {
                        try
                         database.executeUpdate(creatTableMovie, values: nil)
                        create = true
                    }
                    catch {
                        print("创建表失败")
                    }
                    database.close()
                }else {
                    print("打开表失败")
                }
            }
        }
        return create
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDataBase) {
                database = FMDatabase.init(path: pathToDataBase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    
    //插入数据
    func insertMovieData() -> Void {
        if openDatabase() {
            
            if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
                do {
                    let moviesFileContents = try String.init(contentsOfFile: pathToMoviesFile)
                    print(moviesFileContents)
                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
//                    print(moviesData)
                    var query = ""
                    
                    for movie in moviesData {
                        let moviePats = movie.components(separatedBy: "\t")
                        if moviePats.count == 5 {
                            let movieTitle = moviePats[0]
                            let movieCategory = moviePats[1]
                            let movieYear = moviePats[2]
                            let movieURL = moviePats[3]
                            let movieCoverURL = moviePats[4]
                            
                            query += "insert into movies (\(file_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null ,'\(movieTitle)', '\(movieCategory)', '\(movieYear)', '\(movieURL)', '\(movieCoverURL)', 0, 0);"
                        }
                    }
                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                    
                }
                  catch {
                    print("插入失败")

                  }
            }
           database.close()
        }
    }
    
    
//加载数据库全部数据
    func loadmovies() -> [MovieInfo]! {
        var  movies: [MovieInfo]!
        if openDatabase() {
            let query = "select * from movies order by \(field_MovieYear) asc"
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let  movie  = MovieInfo(movieID: Int(results.int(forColumn: file_MovieID)),
                        title: results.string(forColumn: field_MovieTitle),
                        category: results.string(forColumn: field_MovieCategory),
                        year: Int(results.int(forColumn: field_MovieYear)),
                        movieURL: results.string(forColumn: field_MovieURL),
                        coverURL: results.string(forColumn: field_MovieCoverURL),
                        watched: results.bool(forColumn: field_MovieWatched),
                        likes: Int(results.int(forColumn: field_MovieLikes)))
                    
                    if movies == nil {
                        movies = [MovieInfo]()
                    }
                    movies.append(movie)
                    
                }
            }
            catch {
                
            }
            
            database.close()
        }
        return movies
    }
    
    
    //根据 某个 数据去搜索
    func loadMovie(withID: Int, callBack:(_ movieInfo: MovieInfo?) -> ()) -> Void {
        
        var movieInfo : MovieInfo!
        
        if openDatabase() {
            let query = "select * from movies where \(file_MovieID)=?"
            do {
                let results = try database.executeQuery(query, values: [withID])
                if results.next() {
                    movieInfo = MovieInfo(movieID : Int(results.int(forColumn: file_MovieID)),
                    title: results.string(forColumn: field_MovieTitle),
                    category: results.string(forColumn: field_MovieCategory),
                    year: Int(results.int(forColumn: field_MovieYear)),
                    movieURL: results.string(forColumn: field_MovieURL),
                    coverURL: results.string(forColumn: field_MovieCoverURL),
                    watched: results.bool(forColumn: field_MovieWatched),
                     likes: Int(results.int(forColumn: field_MovieLikes)))
                }
            }
            catch {
                
            }
            database.close()
        }
        callBack(movieInfo)
    }
    
    
    //更新数据
    func updateMovie(withID : Int, watched : Bool, likes: Int) -> Void {
        if openDatabase() {
            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(file_MovieID)=?"
            do {
                try database.executeUpdate(query, values: [watched,likes,withID])
            }
            catch {
                
            }
            database.close()
        }
    }
    
    //删除数据
    func deleteMovie(withID: Int) -> Bool {
        var deleted = false
        if openDatabase() {
            let query = "delete from movies where \(file_MovieID)=?"
            do {
                try database.executeUpdate(query, values: [withID])
                deleted = true
            }
            catch {
                
            }
            database.close()
        }
        return deleted
    }
}
