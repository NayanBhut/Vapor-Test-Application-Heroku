import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
//import CryptorECC


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
     app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    app.migrations.add(UsersTableAdd())
    app.migrations.add(UsersTableAdd())
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

/*
func checkSHAKey() {
    do {
        let p256PrivateKey = try ECPrivateKey.make(for: .prime256v1)
        let privateKeyPEM = p256PrivateKey.pemString
        
        print(privateKeyPEM)
    }catch {
        
    }
}

func createClientSecret() {
    var config: ServerConfiguration.AppleSignIn = ServerConfiguration.AppleSignIn()
    let secret = AppleSignInCreds().createClientSecret(config: config)
    print("Client Secret is \n",secret)
}

func checkECKeyCreate() {
    let privateKey =
"""
-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQglf7ztYnsaHX2yiHJ
meHFl5dg05y4a/hD7wwuB7hSRpmhRANCAASKRzmboLbG0NZ54B5PXxYSU7fvO8U7
PyniQCWG+Agc3bdcgKU0RKApWYuBJKrZqyqLB2tTlgdtwcWSB0AEzVI8
-----END PRIVATE KEY-----
"""
    
    
}
*/

























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
