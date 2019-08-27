//
//  EditAnswerContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct EditAnswerContext: Encodable {
    let title = "Редактировать ответ"
    let answer: Future<Answer>
}
