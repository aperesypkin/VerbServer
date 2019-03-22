//
//  TaskResponse.swift
//  App
//
//  Created by Alexander Peresypkin on 22/03/2019.
//

import Vapor

struct TaskResponse: Content {
    let tasks: [Task]
    let count: Int
}
