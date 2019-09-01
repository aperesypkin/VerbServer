//
//  CreateAnswerContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct CreateAnswerContext: Encodable {
    let title = "Создать ответ"
    let verb: Verb?
}
