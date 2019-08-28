//
//  VerbWithAnswersResponse.swift
//  App
//
//  Created by Alexander Peresypkin on 28/08/2019.
//

import Vapor

struct VerbWithAnswersResponse: Content {
    let id: Int?
    let infinitive: String
    let language: Language
    let transcription: String?
    let createdAt: Date?
    let updatedAt: Date?
    let answers: [Answer]?
}

