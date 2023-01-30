import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("users")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":userID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> GetUser<[Users]> {
        let arrData = try await Users.query(on: req.db).all()
        if arrData.count == 0 {
            return GetUser(data: [], status: false, message: "No users found.")
        }else {
            let user = GetUser(data: arrData, status: true)
            return user
        }
    }

    func create(req: Request) async throws -> GetUser<Users> {
        let todo = try req.content.decode(Users.self)
        try await todo.save(on: req.db)
        let user = GetUser(data: todo, status: true,message: "Inserted Successfully")
        return user
    }

    func delete(req: Request) async throws -> GetUser<[String:String]> {
        guard let todo = try await Users.find(req.parameters.get("todoID"), on: req.db) else {
            return GetUser(data: nil, status: true,message: "Error in Deleting")
//            Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        let user = GetUser(data: ["message" : "Deleted Successfully"], status: true)
        return user
    }
}
