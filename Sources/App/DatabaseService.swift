//
//  DatabaseService.swift
//  
//
//  Created by Nayan Bhut on 5/1/22.
//

import Foundation
import PostgresKit
import Vapor

struct DatabaseService {
    let pool: EventLoopGroupConnectionPool<PostgresConnectionSource>
}


struct DatabaseServiceKey: StorageKey {
    typealias Value = DatabaseService
}

extension DatabaseService: LifecycleHandler {
    func shutdown(_ application: Application) {
        self.pool.shutdown()
    }
}

//struct RequestEnvironment {
//    var makeFooService: () -> FooService
//
//    static func makeDefault(req: Request) -> RequestEnvironment {
//        guard let dbService = req.application.databaseService else {
//            fatalError("Missing DatabaseService")
//        }
//        let db = dbService.pool.database(logger: req.logger)
//        let dbClient = DBClient(database: db)
//        return RequestEnvironment(
//            makeFooService: { FooService(dbClient: dbClient, request: req) }
//        )
//    }
//}

//struct FooController {
//    func create(_ req: Request) -> EventLoopFuture<FooExternal> {
//        let newFoo = try req.content.decode(NewFooIncoming.self)
//        let env = RequestEnvironment.makeDefault(req: req)
//        return env.makeFooService().makeFoo(newFoo)
//    }
//}

extension Application {
    var databaseService: DatabaseService? {
        get { self.storage[DatabaseServiceKey.self] }
        set { self.storage[DatabaseServiceKey.self] = newValue }
    }
}



//    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
//    let logger = Logger(label: "postgres-logger")
//
//    let config = PostgresConnection.Configuration(
//        connection: .init(
//            host: "localhost",
//            port: 5432
//        ),
//        authentication: .init(
//            username: "postgres",
//            database: "postgres",
//            password: "root"
//        ),
//        tls: .disable
//    )
//    do {
//        let connection = try await PostgresConnection.connect(on: eventLoopGroup.next(), configuration: config, id: 1, logger: logger)
//
//        let rows = try await connection.query("SELECT id, username FROM users", logger: logger)
//    }catch {
//        print("Error is ",error.localizedDescription)
//    }


// Close your connection once done
//    try await connection.close()
//
//    // Shutdown the EventLoopGroup, once all connections are closed.
//    try eventLoopGroup.syncShutdownGracefully()
