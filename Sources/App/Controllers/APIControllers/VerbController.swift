//
//  VerbController.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import Fluent
import Authentication

final class VerbController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let verbRouter = router.grouped("api", "v1", "verb")
        verbRouter.get("info", use: getAllHandler)
        
        let authRouter = verbRouter.grouped(User.tokenAuthMiddleware(), User.guardAuthMiddleware())
        authRouter.post(Verb.self, use: createHandler)
        authRouter.delete(Verb.parameter, use: deleteHandler)
        authRouter.put(Verb.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[Verb]> {
        
        return Verb.query(on: req).sort(\.id, .ascending).all()
    }
    
    private func createHandler(req: Request, verb: Verb) throws -> Future<Verb> {
        
        try verb.validate()
        return verb.save(on: req)
    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameters.next(Verb.self).delete(on: req).transform(to: .noContent)
    }
    
    private func updateHandler(req: Request) throws -> Future<Verb> {
        
        return try flatMap(req.parameters.next(Verb.self), req.content.decode(VerbRequest.self)) { verb, verbRequest in
            if let infinitive = verbRequest.infinitive { verb.infinitive = infinitive }
            if let language = verbRequest.language { verb.language = language }
            if let transcription = verbRequest.transcription { verb.transcription = transcription }
            
            try verb.validate()
            
            return verb.save(on: req)
        }
    }
}
