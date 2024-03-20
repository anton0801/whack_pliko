//
//  WhackSlot.swift
//  Whack Pliko
//
//  Created by Anton on 19/3/24.
//

import Foundation
import SpriteKit

class WhackSlot: SKNode {
    
    var viewModel = WhackSlotViewModel()
    
    init(at position: CGPoint) {
        super.init()
        self.position = position
        viewModel.configure(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
