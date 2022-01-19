import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works! Now Check again"
    }

    app.get("hello") { req -> String in
        return "Hello, world! Get"
    }
    
    app.get("helloNayan") { req -> String in
        return "Hello, world! Nayan"
    }
}
