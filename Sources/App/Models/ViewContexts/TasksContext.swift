//
//  TasksContext.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor

struct TasksContext: Encodable {
    let title: String
    let tasks: Future<[Task]>
}
