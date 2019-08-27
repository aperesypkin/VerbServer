//
//  TaskController.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import Fluent
import Authentication

final class TaskController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let taskRouter = router.grouped("api", "v1", "task")
        taskRouter.get("info", use: getAllHandler)
        
        let authRouter = taskRouter.grouped(User.tokenAuthMiddleware(), User.guardAuthMiddleware())
        authRouter.post(Task.self, use: createHandler)
        authRouter.delete(Task.parameter, use: deleteHandler)
        authRouter.put(Task.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<TaskResponse> {
        
        let tasksFuture = Task.query(on: req).range(0..<10).all()
        let totalCountFuture = Task.query(on: req).count()
        return map(tasksFuture, totalCountFuture) { tasks, totalCount in
            return TaskResponse(tasks: tasks, totalCount: totalCount)
        }
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
