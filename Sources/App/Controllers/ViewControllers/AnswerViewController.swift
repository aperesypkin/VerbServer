//
//  AnswerViewController.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import Fluent
import Leaf
import Authentication

final class AnswerViewController: RouteCollection {
    
    // MARK: - RouteCollection
    
    func boot(router: Router) throws {
        
        let authSessionsMiddleware = User.authSessionsMiddleware()
        let redirectMiddleware = RedirectMiddleware<User>(path: "/login")
        let answersRouter = router.grouped("answers")
        let authRouter = answersRouter.grouped(authSessionsMiddleware, redirectMiddleware)
        
        authRouter.get(use: answersHandler)
        
        authRouter.post(Answer.parameter, "deleteAnswer", use: deleteAnswerHandler)
        
        authRouter.get("createAnswer", use: createAnswerHandler)
        authRouter.post(Answer.self, at: "createAnswer", use: createAnswerPostHandler)
        
        authRouter.get(Answer.parameter, "editAnswer", use: editAnswerHandler)
        authRouter.post(Answer.self, at: Answer.parameter, "editAnswer", use: editAnswerPostHandler)
        
        authRouter.get(Answer.parameter, "info", use: infoHandler)
    }
    
    // MARK: - Private
    
    private func answersHandler(req: Request) throws -> Future<View> {
        
        let answers = Answer.query(on: req).sort(\.updatedAt, .descending).all()
        let context = AnswersContext(title: "Answers", answers: answers)
        return try req.view().render("answers", context)
    }
    
    private func createAnswerHandler(req: Request) throws -> Future<View> {
        
        let context = CreateAnswerContext()
        return try req.view().render("createAnswer", context)
    }
    
    private func createAnswerPostHandler(req: Request, answer: Answer) throws -> Future<Response> {
        
        try answer.validate()
        return answer.save(on: req).transform(to: req.redirect(to: "/answers"))
    }
    
    private func deleteAnswerHandler(req: Request) throws -> Future<Response> {
        
        return try req.parameters.next(Answer.self).delete(on: req).transform(to: req.redirect(to: "/answers"))
    }
    
    private func editAnswerHandler(req: Request) throws -> Future<View> {
        
        let answer = try req.parameters.next(Answer.self)
        let context = EditAnswerContext(answer: answer)
        return try req.view().render("editAnswer", context)
    }
    
    private func editAnswerPostHandler(req: Request, newAnswer: Answer) throws -> Future<Response> {
        
        return try req.parameters.next(Answer.self).flatMap { answer in
            answer.value = newAnswer.value
            answer.isRight = newAnswer.isRight
            answer.verbID = newAnswer.verbID
            
            try answer.validate()
            
            return answer.save(on: req).transform(to: req.redirect(to: "/answers"))
        }
    }
    
    private func infoHandler(req: Request) throws -> Future<View> {
        
        return try req.parameters.next(Answer.self).flatMap { answer in
            let verb = answer.verb.get(on: req)
            let context = InfoAnswerContext(answer: answer, verb: verb)
            return try req.view().render("answerInfo", context)
        }
    }
}
