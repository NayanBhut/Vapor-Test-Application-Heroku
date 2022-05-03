import Fluent
import Vapor

final class Users: Model, Content {
    static let schema = "Users"
    
//    @ID(key: .id)
//    var id: UUID?
    
    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String
    
    @Field(key: "age")
    var age: Int
    
    @Field(key: "username")
    var username: String

    init() { }

    init(id: Int? = nil, age: Int, name: String, username: String) {
        self.id = id
        self.age = age
        self.name = name
        self.username = username
    }
}

struct GetUser<T:Content>: Content {
    var data: T?
    var status: Bool
    var message: String?
    
//    static func getObject<T: Codable>(data: T, status: Bool) -> GetUser {
//        let user = GetUser(data: data, status: true)
//    }
}
