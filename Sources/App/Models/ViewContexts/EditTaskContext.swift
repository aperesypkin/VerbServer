//
//  EditTaskContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct EditTaskContext: Encodable {
    let title = "Редактировать таску"
    let task: Future<Task>
}
