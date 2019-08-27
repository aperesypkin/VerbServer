//
//  InfoTaskContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct InfoTaskContext: Encodable {
    let title = "Инфо (Task)"
    let task: Task
    let verbs: Future<[Verb]>
}
