//
//  VerbViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import Fluent
import Leaf
import Authentication

final class VerbViewController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let redirectMiddleware = RedirectMiddleware<User>(path: "/login")
        let verbsRouter = router.grouped("verbs")
        let authRouter = verbsRouter.grouped(authSessionsMiddleware, redirectMiddleware)
        
        authRouter.get(use: verbsHandler)
        
        authRouter.post(Verb.parameter, "deleteVerb", use: deleteVerbHandler)
        
        authRouter.get("createVerb", use: createVerbHandler)
        authRouter.post(Verb.self, at: "createVerb", use: createVerbPostHandler)
        
        authRouter.get(Verb.parameter, "editVerb", use: editVerbHandler)
        authRouter.post(Verb.self, at: Verb.parameter, "editVerb", use: editVerbPostHandler)
        
        authRouter.get(Verb.parameter, "info", use: infoHandler)
        authRouter.post(Verb.parameter, "detach", Task.parameter, use: detachTaskHandler)
        
        authRouter.get(Verb.parameter, "attachTask", use: attachTaskHandler)
        authRouter.post(Verb.parameter, "attachTask", Task.parameter, use: attachTaskPostHandler)
        
        authRouter.get(Verb.parameter, "createAnswer", use: createAnswerHandler)
        authRouter.post(Answer.self, at: Verb.parameter, "createAnswer", use: createAnswerPostHandler)
    }
    
    // MARK: - Private
    
    private func verbsHandler(req: Request) throws -> Future<View> {
        
        let verbs = Verb.query(on: req).sort(\.updatedAt, .descending).all()
        let context = VerbsContext(title: "Verbs", verbs: verbs)
        return try req.view().render("verbs", context)
    }
    
    private func createVerbHandler(req: Request) throws -> Future<View> {
        
        let context = CreateVerbContext()
        return try req.view().render("createVerb", context)
    }
    
    private func createVerbPostHandler(req: Request, verb: Verb) throws -> Future<Response> {
        
        try verb.validate()
        return verb.save(on: req).transform(to: req.redirect(to: "/verbs"))
    }
    
    private func deleteVerbHandler(req: Request) throws -> Future<Response> {
        
        return try req.parameters.next(Verb.self).delete(on: req).transform(to: req.redirect(to: "/verbs"))
    }
    
    private func editVerbHandler(req: Request) throws -> Future<View> {
        
        let verb = try req.parameters.next(Verb.self)
        let context = EditVerbContext(verb: verb)
        return try req.view().render("editVerb", context)
    }
    
    private func editVerbPostHandler(req: Request, newVerb: Verb) throws -> Future<Response> {
        
        return try req.parameters.next(Verb.self).flatMap { verb in
            verb.infinitive = newVerb.infinitive
            verb.language = newVerb.language
            verb.transcription = newVerb.transcription
            
            try verb.validate()
            
            return verb.save(on: req).transform(to: req.redirect(to: "/verbs"))
        }
    }
    
    private func infoHandler(req: Request) throws -> Future<View> {
        
        return try req.parameters.next(Verb.self).flatMap { verb in
            let tasks = try verb.tasks.query(on: req).all()
            let answers = try verb.answers.query(on: req).all()
            let context = InfoVerbContext(verb: verb, tasks: tasks, answers: answers)
            return try req.view().render("verbInfo", context)
        }
    }
    
    private func detachTaskHandler(req: Request) throws -> Future<Response> {
        
        return try flatMap(req.parameters.next(Verb.self), req.parameters.next(Task.self)) { verb, task in
            guard let verbId = verb.id else { throw Abort(.badRequest) }
            return verb.tasks.detach(task, on: req).transform(to: req.redirect(to: "/verbs/\(verbId)/info"))
        }
    }
    
    private func attachTaskHandler(req: Request) throws -> Future<View> {
        
        return try req.parameters.next(Verb.self).flatMap { verb in
            let tasks = Task.query(on: req).sort(\.id, .ascending).all()
            let context = AttachTaskContext(verb: verb, tasks: tasks)
            return try req.view().render("attachTask", context)
        }
    }
    
    private func attachTaskPostHandler(req: Request) throws -> Future<Response> {
        
        return try flatMap(req.parameters.next(Verb.self), req.parameters.next(Task.self)) { verb, task in
            guard let verbId = verb.id else { throw Abort(.badRequest) }
            return verb.tasks.attach(task, on: req).transform(to: req.redirect(to: "/verbs/\(verbId)/info"))
        }
    }
    
    private func createAnswerHandler(req: Request) throws -> Future<View> {
        
        return try req.parameters.next(Verb.self).flatMap { verb in
            let context = CreateAnswerContext(verb: verb)
            return try req.view().render("createAnswer", context)
        }
    }
    
    private func createAnswerPostHandler(req: Request, answer: Answer) throws -> Future<Response> {
        
        try answer.validate()
        return try req.parameters.next(Verb.self).flatMap { verb in
            guard let verbId = verb.id else { throw Abort(.badRequest) }
            return answer.save(on: req).transform(to: req.redirect(to: "/verbs/\(verbId)/info"))
        }
    }
}
