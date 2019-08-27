//
//  InfoAnswerContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct InfoAnswerContext: Encodable {
    let title = "Инфо (Answer)"
    let answer: Answer
    let verb: Future<Verb>
}
