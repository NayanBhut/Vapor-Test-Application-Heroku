import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.migrations.add(CreateTodo())
    app.views.use(.leaf)
    // register routes
    setDatabase(app)
    try routes(app)
}


func setDatabase(_ app: Application) {

    
//    do {
//        try app.databases.use(.postgres(url: "postgres://dqwutrojebehyw:5b349c3105b2c3eda4a8be8f75d11309cce22e816960edb9a25e05e5ec681339@ec2-3-224-164-189.compute-1.amazonaws.com:5432/de7pak0gtktq1p"), as: .psql)
//    }catch {
//        print("DataBase not connected ",error.localizedDescription)
//    }
    
    if let url = Environment.get("DATABASE_URL") {
        do {
            try app.databases.use(.postgres(url: url), as: .psql)
        }catch {
            print("DataBase not connected ",error.localizedDescription)
        }
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
