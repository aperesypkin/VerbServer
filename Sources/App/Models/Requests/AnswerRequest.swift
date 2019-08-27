//
//  AnswerRequest.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct AnswerRequest: Content {
    var value: String?
    var isRight: Bool?
    var verbID: Int?
}

