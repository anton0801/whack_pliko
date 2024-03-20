//
//  ProgressGame.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation

protocol Scorable {
    var score: Int { get set }
}

struct ProgressGame: Scorable {
    var score: Int
}
