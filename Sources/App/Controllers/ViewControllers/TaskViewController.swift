//
//  TaskViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import Fluent
import Leaf
import Authentication

final class TaskViewController: RouteCollection {
    
    func boot(router: Router) throws {
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let redirectMiddleware = RedirectMiddleware<User>(path: "/login")
        let authRoute = router.grouped(authSessionsMiddleware, redirectMiddleware)
        authRoute.get(use: tasksHandler)
        authRoute.get("createTask", use: createTaskHandler)
        authRoute.post(Task.self, at: "createTask", use: createTaskPostHandler)
        authRoute.post(Task.parameter, "delete", use: deleteTaskHandler)
    }
    
    private func tasksHandler(req: Request) throws -> Future<View> {
        let tasks = Task.query(on: req).all()
        let context = TasksContext(title: "All Tasks", tasks: tasks)
        return try req.view().render("tasks", context)
    }
    
    private func createTaskHandler(req: Request) throws -> Future<View> {
        let context = CreateTaskContext()
        return try req.view().render("createTask", context)
    }
    
    private func createTaskPostHandler(req: Request, task: Task) throws -> Future<Response> {
        try task.validate()
        return task.save(on: req).transform(to: req.redirect(to: "/"))
    }
    
    private func deleteTaskHandler(req: Request) throws -> Future<Response> {
        return try req.parameters.next(Task.self).delete(on: req).transform(to: req.redirect(to: "/"))
    }
    
}
