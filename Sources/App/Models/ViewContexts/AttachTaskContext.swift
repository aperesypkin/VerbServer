//
//  AttachTaskContext.swift
//  App
//
//  Created by Alexander Peresypkin on 28/08/2019.
//

import Vapor

struct AttachTaskContext: Encodable {
    let title = "Привязать таску"
    let verb: Verb
    let tasks: Future<[Task]>
}

