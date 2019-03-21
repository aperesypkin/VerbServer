//
//  TasksViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import Fluent
import Leaf
import Authentication

final class TasksViewController: RouteCollection {
    
    func boot(router: Router) throws {
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let redirectMiddleware = RedirectMiddleware<User>(path: "/login")
        let authRoute = router.grouped(authSessionsMiddleware, redirectMiddleware)
        authRoute.get(use: getAllHandler)
    }
    
    private func getAllHandler(req: Request) throws -> Future<View> {
        let tasks = Task.query(on: req).all()
        let context = TasksContext(title: "All Tasks", tasks: tasks)
        return try req.view().render("tasks", context)
    }
    
}
