//
//  AnswersContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct AnswersContext: Encodable {
    let title: String
    let answers: Future<[Answer]>
}

