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
        
        authRouter.get(Task.parameter, "verb", "info", use: getVerbsHandler)
        authRouter.post(Task.parameter, "verb", Verb.parameter, use: addVerbHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<TaskResponse> {
        
        let tasksFuture = Task.query(on: req).sort(\.id, .ascending).all()
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
        
        return try flatMap(req.parameters.next(Task.self), req.content.decode(TaskRequest.self)) { task, taskRequest in
            if let title = taskRequest.title { task.title = title }
            if let description = taskRequest.description { task.description = description }
            if let type = taskRequest.type { task.type = type }
            
            try task.validate()
            
            return task.save(on: req)
        }
    }
    
    private func addVerbHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try flatMap(req.parameters.next(Task.self), req.parameters.next(Verb.self)) { task, verb in
            return task.verbs.attach(verb, on: req).transform(to: .created)
        }
    }
    
    private func getVerbsHandler(req: Request) throws -> Future<[VerbWithAnswersResponse]> {
        
        return try req.parameters.next(Task.self).flatMap { task in
            return try task.verbs.query(on: req).all().flatMap { verbs in
                try verbs.map { verb in
                    try verb.answers.query(on: req).all().map { answers in
                        VerbWithAnswersResponse(id: verb.id,
                                                infinitive: verb.infinitive,
                                                pastSimple: verb.pastSimple,
                                                pastParticiple: verb.pastParticiple,
                                                translation: verb.translation,
                                                language: verb.language,
                                                transcription: verb.transcription,
                                                createdAt: verb.createdAt,
                                                updatedAt: verb.updatedAt,
                                                answers: answers.isEmpty ? nil : answers)
                    }
                }.flatten(on: req)
            }
        }
    }
}
