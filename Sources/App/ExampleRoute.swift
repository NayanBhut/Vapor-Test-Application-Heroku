//
//  File.swift
//  
//
//  Created by Nayan Bhut on 4/30/22.
//

import Vapor

func testRoutes(_ app: Application) throws {
    app.get { req in
        return "It works! Now Check again"
    }
    
    app.get("hello") { req -> String in //route
        return "Hello, world! Get"
    }
    
    app.get("hello", ":name") { req -> String in //Route/name Route param dynamic
        let name = req.parameters.get("name")!
        let paramName = req.content
        return "Hello, world! \(name) \(paramName)"
    }
    
    app.get("foo", "bar", "baz") { req in // Route/foo/bar/baz Route param Static
        return "Hello, world! \(req.url)"
    }
    
    app.get("books") { req -> String in
        return "Hello, world! Nayan"
    }
    
    app.get("foo", ":bar", "baz") { req in //foo/qux/baz & foo/qux/baz Dynamic param
        return "Hello, world! \(req.url)"
    }
    
    app.get("foo", "**") { req in //foo/qux & foo/qux/baz & foo/qux/baz/bat
        return "Hello, world! \(req.url)"
    }
    
    app.get("number", ":x") { req -> String in
        guard let int = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "\(int) is a great number"
    }
    
    app.get("hello", "**") { req -> String in
        let name = req.parameters.getCatchall().joined(separator: " ")
        //        req.redirect(to: "/hello")
        return "Hello, \(name)!"
    }
    
    // Collects streaming bodies (up to 1mb in size) before calling this route.
    app.on(.POST, "listings", body: .collect(maxSize: "1mb")) { req -> String in
        print("1 MB Data Max")
        print(app.routes.all)
        return "Hello, \(req.body.data)!"
    }
    
    // Request body will not be collected into a buffer.
    app.on(.POST, "upload", body: .stream) {  req -> String in
        //req.body.data will be nil. You must use req.body.drain to handle each chunk as it is sent to your route.
        print("1 MB Data Max")
        print(app.routes.all)
        return "Hello, \(req.body.drain)"
    }
    
    app.group("users") { users in
        users.get { req in
            return "users, get"
        }
        // POST /users
        users.post { req in
            return "users, post"
        }
        // GET /users/:id
        users.group(":id") { user in
            // GET /users/:id
            user.get {  req -> String in
                let id = req.parameters.get("id")!
                return "users, \(id)"
            }
            
            // PATCH /users/:id
            user.patch { req -> String in
                print("Patch")
                return "Patch"
            }
            // PUT /users/:id
            user.put { req -> String in
                print("Put")
                return "PUT"
            }
        }
    }
}
