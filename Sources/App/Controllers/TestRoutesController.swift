//
//  TestRoutesController.swift
//  
//
//  Created by Nayan Bhut on 5/2/22.
//

import Vapor
import PostgresKit


struct TestRoutesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("users", use: getAllUsers)
        routes.post("addusers", use: addUser)
    }
    
    
//    func getAllHandler(_ req: Request)
//    -> EventLoopFuture<[Acronym]> {
//        Acronym.query(on: req.db).all()
//    }
    
    
    func getAllUsers(_ req: Request) async throws -> [CreateUser] {
        guard let dbService = req.application.databaseService else {
            fatalError("Missing DatabaseService")
        }
        
        let db = dbService.pool.database(logger: req.logger)
        let sql = db.sql()
        
        return try await sql.select().columns("*").from("Users").all(decoding: CreateUser.self)
            
    }
    
    
    func addUser(_ req: Request) async throws -> CreateUser {
        try CreateUser.validate(content: req)
        let user = try req.content.decode(CreateUser.self)
        
        guard let dbService = req.application.databaseService else {
            fatalError("Missing DatabaseService")
        }
        
        let db = dbService.pool.database(logger: req.logger)
        let sql = db.sql()
        
        try await sql.insert(into: "Users")
            .columns("id", "name","username","age")
            .values(SQLLiteral.default, SQLBind(user.name),SQLBind(user.username),SQLBind(Int(user.age)))
            .run()
            
        return user
            
        
        
        
        
        
        
//        return try await sql.select().columns("*").from("Users").all().compactMap { arrRows -> CreateUser in
//            print(arrRows)
//            print(try arrRows.decode(model: CreateUser.self))
//            let data = try arrRows.decode(model: CreateUser.self)
//            return data
//        }
    }
}



//app.post("api") {
//    req -> EventLoopFuture<[SQLRaw]> in
//    // 2
//    let user = try req.content.decode(CreateUser.self)
//
//    guard let dbService = req.application.databaseService else {
//        fatalError("Missing DatabaseService")
//    }
//    let db = dbService.pool.database(logger: req.logger)
//    let sql = db.sql()
//
//    return sql.select().columns("*").from("Users").all()
//    }
