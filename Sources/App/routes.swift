import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.post("greeting") { req -> HTTPStatus in
        let greeting = try req.content.decode(Greeting.self)
        print(greeting.hello) // "world"
        return HTTPStatus.ok
    }
    
    app.get("hello") { req -> String in
        let hello = try req.query.decode(Hello.self) //let name: String? = req.query["name"]
        return "Hello, \(hello.name ?? "Anonymous")"
    }
    
    app.post("users") { req -> CreateUser in
        try CreateUser.validate(content: req)
        let user = try req.content.decode(CreateUser.self)
        // Do something with user.
        return user
    }
}
