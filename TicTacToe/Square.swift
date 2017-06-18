//
//  Square.swift
//  Demo
//
//  Created by Jake on 6/18/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation
import SpriteKit

class Square {
    let square : SKNode
    let labelNode : SKLabelNode
    let nextNode : SKNode
    let refNode : SKReferenceNode
    let name : String
    var owner : Player? {
        didSet {
            guard let owner = self.owner else {
                self.labelNode.text = ""
                return
            }
            self.labelNode.text = owner.label
        }
    }
    
    init(with refNode: SKReferenceNode) {
        self.refNode = refNode
        self.name = refNode.name!
        self.nextNode = refNode.children.first!
        self.square = nextNode.children.first!
        self.labelNode = square.children.first as! SKLabelNode
    }
    
    func reset() {
        self.owner = nil
    }
}
