import Fluent
import Vapor

final class Users: Model, Content {
    static let schema = "Users"
    
   @ID(key: .id)
   var id: UUID?
    
    // @ID(custom: "id")
    // var id: Int?

    @Field(key: "name")
    var name: String
    
    @Field(key: "age")
    var age: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "first_Name")
    var first_Name: String

    init() { }

    init(id: UUID = UUID(), age: String, name: String, username: String, email: String, first_Name: String) {
        self.id = id
        self.age = age
        self.name = name
        self.username = username
        self.email = email
        self.first_Name = first_Name
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
