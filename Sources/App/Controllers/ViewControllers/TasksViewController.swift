//
//  TasksViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import Fluent
import Leaf

final class TasksViewController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: getAllHandler)
    }
    
    private func getAllHandler(req: Request) throws -> Future<View> {
        let tasks = Task.query(on: req).all()
        let context = TasksContext(title: "All Tasks", tasks: tasks)
        return try req.view().render("tasks", context)
    }
    
}
