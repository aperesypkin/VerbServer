//
//  TaskRequest.swift
//  App
//
//  Created by Alexander Peresypkin on 15/03/2019.
//

import Vapor

struct TaskRequest: Content {
    let title: String?
    let description: String?
}
