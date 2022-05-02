import Vapor
import PostgresKit
import PostgresNIO

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    //app.routes.defaultMaxBodySize = "500kb"
    //app.routes.caseInsensitive = true
    jsonDecoding()
    connectDB(app)
    try routes(app)
}


private func jsonDecoding() {
    // create a new JSON encoder that uses unix-timestamp dates
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    
    // override the global encoder used for the `.json` media type
    ContentConfiguration.global.use(encoder: encoder, for: .json)
}

private func connectDB(_ app: Application) {
    if let dbUrlString = Environment.get("DATABASE_URL"){
        print("Database Url is : \(dbUrlString)")
        var postgresConfiguration = PostgresConfiguration(url: dbUrlString)!
        postgresConfiguration.tlsConfiguration = .makeClientConfiguration()
        postgresConfiguration.tlsConfiguration?.certificateVerification = .none
//        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
        
        let pool = EventLoopGroupConnectionPool(
            source: PostgresConnectionSource(configuration: postgresConfiguration),
            on: app.eventLoopGroup
        )
        
        
        
        
        
        let dbService = DatabaseService(pool: pool)
        app.databaseService = dbService
        app.lifecycle.use(dbService)
        
        let db = dbService.pool.database(logger: app.logger)
//        let dbClient = DBClient(database: db)
        app.logger.info("Will run migrate on DB")
//        _ = try dbClient.migrate().wait()
        app.logger.info("DB migration done")
        
    } else {
        let configuration = PostgresConfiguration(
            hostname: "localhost",
            username: "postgres",
            password: "root",
            database: "postgres"
        )
        
        let eventLoopGroup1: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        //    defer { try! eventLoopGroup.syncShutdownGracefully() }
        //
        let pool = EventLoopGroupConnectionPool(
            source: PostgresConnectionSource(configuration: configuration),
            on: eventLoopGroup1
        )
        
        let dbService = DatabaseService(pool: pool)
        app.databaseService = dbService
        app.lifecycle.use(dbService)
        
        let db = dbService.pool.database(logger: app.logger)
//        let dbClient = DBClient(database: db)
        app.logger.info("Will run migrate on DB")
//        _ = try dbClient.migrate().wait()
        app.logger.info("DB migration done")
    }
}

/*
public func configure(_ app: Application) throws {
    guard let dbUrlString = Environment.get("DATABASE_URL") else {
        preconditionFailure("Missing DBURL")
    }
    
    let postgresConfiguration = PostgresConfiguration(url: dbUrlString)!
    let pool = EventLoopGroupConnectionPool(
        source: PostgresConnectionSource(configuration: postgresConfiguration),
        on: app.eventLoopGroup
    )
    
    let dbService = DatabaseService(pool: pool)
    app.databaseService = dbService
    app.lifecycle.use(dbService)
 
    let db = dbService.pool.database(logger: app.logger)
    let dbClient = DBClient(database: db)
    app.logger.info("Will run migrate on DB")
    _ = try dbClient.migrate().wait()
    app.logger.info("DB migration done")
    
    // register routes
    try routes(app)
}
*/
