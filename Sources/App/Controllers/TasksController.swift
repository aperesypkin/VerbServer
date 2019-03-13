//
//  TasksController.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import Fluent

struct TasksController: RouteCollection {
    
    func boot(router: Router) throws {
        let tasksRoute = router.grouped("api", "v1", "tasks")
        tasksRoute.get(use: getAllHandler)
        tasksRoute.post(Task.self, use: createHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Task]> {
        return Task.query(on: req).all()
    }
    
    func createHandler(_ req: Request, task: Task) throws -> Future<Task> {
        return task.save(on: req)
    }
}
