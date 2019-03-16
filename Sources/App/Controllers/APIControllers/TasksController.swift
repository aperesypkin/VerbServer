//
//  TasksController.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import Fluent

final class TasksController: RouteCollection {
    
    func boot(router: Router) throws {
        let tasksRoute = router.grouped("api", "v1", "tasks")
        tasksRoute.get(use: getAllHandler)
        tasksRoute.post(Task.self, use: createHandler)
        tasksRoute.delete(Task.parameter, use: deleteHandler)
        tasksRoute.put(Task.parameter, use: updateHandler)
    }
    
    private func getAllHandler(req: Request) throws -> Future<[Task]> {
        return Task.query(on: req).all()
    }
    
    private func createHandler(req: Request, task: Task) throws -> Future<Task> {
        try task.validate()
        return task.save(on: req)
    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Task.self).delete(on: req).transform(to: .noContent)
    }
    
    private func updateHandler(req: Request) throws -> Future<Task> {
        return try flatMap(to: Task.self, req.parameters.next(Task.self), req.content.decode(TaskRequest.self)) { task, taskRequest in
            if let title = taskRequest.title { task.title = title }
            if let description = taskRequest.description { task.description = description }
            
            try task.validate()
            
            return task.save(on: req)
        }
    }
    
}
