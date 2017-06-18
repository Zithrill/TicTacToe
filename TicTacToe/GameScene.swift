//
//  GameScene.swift
//  Demo
//
//  Created by Jake on 6/17/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var refnode : SKLabelNode?
    private var playSpaces : Array<Square> = []
    private var players : Array<Player> = []
    private var game : GameBoard?
    
    override func sceneDidLoad() {
        
        let player1 = Player(icon: "X")
        let player2 = Player(icon: "O")
        players.append(player1)
        players.append(player2)
        
        // Locating all of our game squares
        for child in self.children where (child.name?.hasPrefix("square_"))! {
            guard let refnode = child as? SKReferenceNode else {
                fatalError("Invalid Square")
            }
            // We create a new class for each square to track its state
            let square = Square(with: refnode)
            self.playSpaces.append(square)
        }
        
        // Creating the actual gameboard
         self.game = GameBoard(with: playSpaces, and: players)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let positionInScene = t.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.parent?.parent?.name
            {
                self.game?.claim(node: name)
            }
        }
    }
}
