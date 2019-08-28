//
//  InfoVerbContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct InfoVerbContext: Encodable {
    let title = "Инфо (Verb)"
    let verb: Verb
    let tasks: Future<[Task]>
    let answers: Future<[Answer]>
}
