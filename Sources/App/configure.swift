import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
//    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    app.migrations.add(InitialMigration())
    
    setDatabase(app)
    app.jwt.signers.use(.hs256(key: "secret"))

    app.routes.defaultMaxBodySize = "100mb" // config max upload file size
    app.directory.publicDirectory = "/Users/nayanbhut/Documents/Public/"
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    app.http.server.configuration.port = 8081//Int(Environment.get("PORT") ?? "8080" ) ?? 8080

    addMigration(app)
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


func addMigration(_ app: Application) {
    app.migrations.add(InitialMigrations(), UsersData.LoginMigration(), OTPMigration(), UsersData.LoginMigration_AddProfileImage())
    app.autoMigrate()
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
