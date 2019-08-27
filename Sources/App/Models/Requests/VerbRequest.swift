//
//  VerbRequest.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct VerbRequest: Content {
    var infinitive: String?
    var language: Language?
    var transcription: String?
}
