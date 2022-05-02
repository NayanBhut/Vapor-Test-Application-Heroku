//
//  File.swift
//  
//
//  Created by Nayan Bhut on 4/30/22.
//

import Foundation
import Vapor

struct Hello: Content {
    var name: String?
}

struct Greeting: Content {
    var hello: String
}

struct Profile: Content {
    var name: String
    var email: String
    var image: Data
}

enum Color: String, Codable {
    case red, blue, green
}

struct CreateUser: Content {
    var name: String
    var username: String
    var age: String
    var id: Int
}

extension CreateUser: Validatable {
    static func validations(_ validations: inout Validations) {
        // Validations go here.
        validations.add("username", as: String.self, is: .count(3...) && .alphanumeric)
        validations.add("age", as: Int.self, is: .range(13...))
        validations.add("name", as: String.self, is: !.empty, required: true)
    }
}



//app.post("users") { req -> EventLoopFuture<[CreateUser?]> in
//    let user = try req.content.decode(CreateUser.self)
//
//    guard let dbService = req.application.databaseService else {
//        fatalError("Missing DatabaseService")
//    }
//
//    let db = dbService.pool.database(logger: req.logger)
//    let sql = db.sql() // SQLDatabase
//
//    return try sql.select().column("*").from("Users").all().map({ arrUsers -> [CreateUser?] in
//        return arrUsers.map { row in
//            do {
//                return try row.decode(model: CreateUser.self)
//            }catch {
//                return nil
//            }
//        }
//    })
//    }


//app.get("users") { req -> EventLoopFuture<[CreateUser]> in
//    try CreateUser.validate(content: req)
//    let user = try req.content.decode(CreateUser.self)
//    
//    guard let dbService = req.application.databaseService else {
//        fatalError("Missing DatabaseService")
//    }
//    let db = dbService.pool.database(logger: req.logger)
//    let sql = db.sql() // SQLDatabase
//    let planets = try sql.select().column("*").from("Users").all()
//    
//    let data = planets.map { arrData -> [CreateUser] in
//        arrData.map { row -> CreateUser  in
//            try! row.decode(model: CreateUser.self)
//        }
//    }
//    
//    return data
//    //            .map({ arrUsers -> [CreateUser?] in
//    //            return arrUsers.map { row in
//    //                do {
//    //                    return try row.decode(model: CreateUser.self)
//    //                }catch {
//    //                    return nil
//    //                }
//    //            }
//    //        })
//    
//    
//    
//    //        return user
//    
//    
//    
//    
//    //        return user
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
