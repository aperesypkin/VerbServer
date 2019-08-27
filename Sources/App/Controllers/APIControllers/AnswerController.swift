//
//  AnswerController.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import Fluent
import Authentication

final class AnswerController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let answerRouter = router.grouped("api", "v1", "answer")
        answerRouter.get("info", use: getAllHandler)
        
        let authRouter = answerRouter.grouped(User.tokenAuthMiddleware(), User.guardAuthMiddleware())
        authRouter.post(Answer.self, use: createHandler)
        authRouter.delete(Answer.parameter, use: deleteHandler)
        authRouter.put(Answer.parameter, use: updateHandler)
    }
    
    // MARK: - Private
    
    private func getAllHandler(req: Request) throws -> Future<[Answer]> {
        
        return Answer.query(on: req).sort(\.id, .ascending).all()
    }
    
    private func createHandler(req: Request, answer: Answer) throws -> Future<Answer> {
        
        try answer.validate()
        return answer.save(on: req)
    }
    
    private func deleteHandler(req: Request) throws -> Future<HTTPStatus> {
        
        return try req.parameters.next(Answer.self).delete(on: req).transform(to: .noContent)
    }
    
    private func updateHandler(req: Request) throws -> Future<Answer> {
        
        return try flatMap(to: Answer.self, req.parameters.next(Answer.self), req.content.decode(AnswerRequest.self)) { answer, answerRequest in
            if let value = answerRequest.value { answer.value = value }
            if let isRight = answerRequest.isRight { answer.isRight = isRight }
            if let verbID = answerRequest.verbID { answer.verbID = verbID }
            
            try answer.validate()
            
            return answer.save(on: req)
        }
    }
}

