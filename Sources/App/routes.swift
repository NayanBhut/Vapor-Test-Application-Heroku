import Vapor
import Foundation
import SQLKit
import PostgresNIO

func routes(_ app: Application) throws {
    try app.register(collection: TestRoutesController())
    
    
    
    
//    app.post("addusers") { req -> CreateUser in
//        try CreateUser.validate(content: req)
//        let user = try req.content.decode(CreateUser.self)
//
//        guard let dbService = req.application.databaseService else {
//            fatalError("Missing DatabaseService")
//        }
//        let db = dbService.pool.database(logger: req.logger)
//        let rows = try db.simpleQuery("SELECT version();").map({ rowdata in
//            print(rowdata)
//        })
//
//        let sql = db.sql() // SQLDatabase
//        do {
//            try sql.insert(into: "Users")
//                .columns("id", "name","username","age")
//                .values(SQLLiteral.default, SQLBind(user.name),SQLBind(user.username),SQLBind(Int(user.age)))
//                .run()
//            //            .values(SQLLiteral.default, SQLBind("Andromeda"),SQLBind("Andromeda"),SQLBind(21))
//        }catch {
//            print(error.localizedDescription)
//        }
//        return user
//    }
    
//    app.get("users") { req -> CreateUser in
//        try CreateUser.validate(content: req)
//        let user = try req.content.decode(CreateUser.self)
//
//        guard let dbService = req.application.databaseService else {
//            fatalError("Missing DatabaseService")
//        }
//        let db = dbService.pool.database(logger: req.logger)
//        let sql = db.sql() // SQLDatabase
//        let planets = try sql.select().column("*").from("Users").all().map({ arrUsers -> [CreateUser?] in
//            return arrUsers.map { row in
//                do {
//                    return try row.decode(model: CreateUser.self)
//                }catch {
//                    return nil
//                }
//            }
//        })
//        return user
//    }
}


//let sql = postgres.sql() // SQLDatabase
//let planets = try sql.select().column("*").from("planets").all().wait()


//func insert(_ quote: CreateUser) -> EventLoopFuture<Void> {
//    // 1
//    let promise = eventLoop.newPromise(of: Void.self)
//    // 2
//    QuoteRepository.database.addEntity(quote, completing: promise)
//    // 3
//    return promise.futureResult
//}

//app.get("users") { req -> EventLoopFuture<[CreateUser?]> in
//    try CreateUser.validate(content: req)
//    let user = try req.content.decode(CreateUser.self)
//
//    guard let dbService = req.application.databaseService else {
//        fatalError("Missing DatabaseService")
//    }
//    let db = dbService.pool.database(logger: req.logger)
//    let sql = db.sql() // SQLDatabase
//    let planets = try sql.select().column("*").from("Users").all().map({ arrUsers -> [CreateUser?] in
//        return arrUsers.map { row in
//            do {
//                return try row.decode(model: CreateUser.self)
//            }catch {
//                return nil
//            }
//        }
//    })
//
//    return planets
//
//    //            .always({ result in
//    //            switch result {
//    //            case .success(let arruser):
//    //                return arruser
//    //            case .failure(let error):
//    //                return []
//    //            }
//    //        })
//    }
