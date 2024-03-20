//
//  GameData.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation

class GameData: ObservableObject {
    
    @Published var score: Int = UserDefaults.standard.integer(forKey: "score")
    @Published var progressItems: [String] = []
    
    let progressStartPoints: [Int: String] = [
        500: "progress_1",
        1500: "progress_2",
        10000: "progress_3"
    ]
    
    init() {
        let savedProgressItems = UserDefaults.standard.string(forKey: "progress_items")?.components(separatedBy: ",")
        if let savedProgressItems = savedProgressItems {
            for savedProgressItem in savedProgressItems {
                progressItems.append(savedProgressItem)
            }
        }
    }
    
    func addScore(_ score: Int) {
        self.score += score
        UserDefaults.standard.set(self.score, forKey: "score")
        for (startScore, name) in progressStartPoints {
            if self.score >= startScore {
                var savedProgressItems = UserDefaults.standard.string(forKey: "progress_items")?.components(separatedBy: ",") ?? []
                savedProgressItems.append(name)
                UserDefaults.standard.set(savedProgressItems.joined(separator: ","), forKey: "progress_items")
                progressItems.append(name)
            }
        }
    }
    
}
