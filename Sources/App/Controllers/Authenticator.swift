//
//  Authenticator.swift
//  
//
//  Created by Nayan Bhut on 2/19/23.
//

import Vapor
import Fluent
import JWT

struct UserAuthenticator : BearerAuthenticator {
    func authenticate(bearer: Vapor.BearerAuthorization, for request: Vapor.Request) -> NIOCore.EventLoopFuture<Void> {
        if let tokenPayload = try? request.jwt.verify(as: TokenPayload.self), let userId =  UUID(tokenPayload.userId) {
            let userData =  UsersData.query(on: request.db).filter(\.$id == userId).first().flatMapThrowing { userData in
                guard let user = userData else { return }
                return request.auth.login(user)
            }
            return userData
        }
        return request.eventLoop.makeSucceededVoidFuture()
    }
}

struct UserAuthenticatorBasic: BasicAuthenticator {
    typealias User = App.User
    
    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) -> EventLoopFuture<Void> {
        if basic.username == "test" && basic.password == "secret" {
            request.auth.login(User(name: "Vapor123"))
        }
        return request.eventLoop.makeSucceededFuture(())
    }
}

/*
struct UserAuthenticator: BearerAuthenticator {
    func authenticate(bearer: Vapor.BearerAuthorization, for request: Vapor.Request) -> NIOCore.EventLoopFuture<Void> {
        let db = request.db
        guard let tokenPayload = try? request.jwt.verify(as: TokenPayload.self), let userId =  UUID(tokenPayload.userId) else {
            return request.eventLoop.makeSucceededFuture(())
        }
        return UsersData.query(on: db)
            .filter(\.$id == userId )
            .first()
            .flatMap { userData -> EventLoopFuture<Void> in
                guard let userData = userData else {
                    return request.eventLoop.makeSucceededFuture(())
                }
                
                request.auth.login(userData)
                return request.eventLoop.makeSucceededFuture(())
            }
    }
}
*/
