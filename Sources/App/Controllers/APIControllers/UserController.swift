//
//  UserController.swift
//  App
//
//  Created by Alexander Peresypkin on 21/03/2019.
//

import Vapor
import Fluent
import Authentication

final class UserController: RouteCollection {
    
    func boot(router: Router) throws {
        let userRoute = router.grouped("api", "v1", "user")
        userRoute.get("info", use: getAllHandler)
    }
    
    private func getAllHandler(req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
}
