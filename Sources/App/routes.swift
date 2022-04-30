import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works! Now Check again"
    }

    app.get("hello") { req -> String in //route
        return "Hello, world! Get"
    }
    
    app.get("hello", ":name") { req -> String in //Route/name Route param dynamic
        let name = req.parameters.get("name")!
        return "Hello, world! \(name)"
    }
    
    app.get("foo", "bar", "baz") { req in // Route/foo/bar/baz Route param Static
        return "Hello, world! \(req.url)"
    }
    
    app.get("books") { req -> String in
        return "Hello, world! Nayan"
    }
}
