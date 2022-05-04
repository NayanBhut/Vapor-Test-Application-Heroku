import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.migrations.add(UsersTable())
    app.views.use(.leaf)
    // register routes
    setDatabase(app)
    try routes(app)
}


func setDatabase(_ app: Application) {
    if let url = Environment.get("DATABASE_URL") {
        var postgresConfiguration = PostgresConfiguration(url: url)!
        postgresConfiguration.tlsConfiguration = .makeClientConfiguration()
        postgresConfiguration.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: postgresConfiguration), as: .psql)
    }else {
        
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "postgres",
            password: Environment.get("DATABASE_PASSWORD") ?? "root",
            database: Environment.get("DATABASE_NAME") ?? "postgres"
        ), as: .psql)
    }
}



























//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .psql)
//    app.databases.use(.mysql(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .mysql)
//    try app.databases.use(.mongo(
//        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
//    ), as: .mongo)
//    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
