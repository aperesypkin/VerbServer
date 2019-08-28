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
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let redirectMiddleware = RedirectMiddleware<User>(path: "/login")
        let authRouter = router.grouped(authSessionsMiddleware, redirectMiddleware)
        
        authRouter.get(use: tasksHandler)
        
        authRouter.post(Task.parameter, "deleteTask", use: deleteTaskHandler)
        
        authRouter.get("createTask", use: createTaskHandler)
        authRouter.post(Task.self, at: "createTask", use: createTaskPostHandler)
        
        authRouter.get(Task.parameter, "editTask", use: editTaskHandler)
        authRouter.post(Task.self, at: Task.parameter, "editTask", use: editTaskPostHandler)
        
        authRouter.get(Task.parameter, "info", use: infoHandler)
        authRouter.post(Task.parameter, "detach", Verb.parameter, use: detachVerbHandler)
    }
    
    // MARK: - Private
    
    private func tasksHandler(req: Request) throws -> Future<View> {
        
        let tasks = Task.query(on: req).sort(\.id, .ascending).all()
        let context = TasksContext(title: "Tasks", tasks: tasks)
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
    
    private func editTaskHandler(req: Request) throws -> Future<View> {
        
        let task = try req.parameters.next(Task.self)
        let context = EditTaskContext(task: task)
        return try req.view().render("editTask", context)
    }
    
    private func editTaskPostHandler(req: Request, newTask: Task) throws -> Future<Response> {

        return try req.parameters.next(Task.self).flatMap { task in
            task.title = newTask.title
            task.description = newTask.description
            task.type = newTask.type
            
            try task.validate()
            
            return task.save(on: req).transform(to: req.redirect(to: "/"))
        }
    }
    
    private func infoHandler(req: Request) throws -> Future<View> {
        
        return try req.parameters.next(Task.self).flatMap { task in
            let verbs = try task.verbs.query(on: req).all()
            let context = InfoTaskContext(task: task, verbs: verbs)
            return try req.view().render("taskInfo", context)
        }
    }
    
    private func detachVerbHandler(req: Request) throws -> Future<Response> {
        
        return try flatMap(req.parameters.next(Task.self), req.parameters.next(Verb.self)) { task, verb in
            let redirectUrl: String
            
            if let taskId = task.id {
                redirectUrl = "/\(taskId)/info"
            } else {
                redirectUrl = "/"
            }
            
            return task.verbs.detach(verb, on: req).transform(to: req.redirect(to: redirectUrl))
        }
    }
}
