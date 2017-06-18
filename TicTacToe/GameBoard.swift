//
//  GameBoard.swift
//  Demo
//
//  Created by Jake on 6/18/17.
//  Copyright © 2017 Jake. All rights reserved.
//
import Foundation

class GameBoard {
    let playSpace : Array<Square>
    let rowLength : Int
    let setLength : Int
    let players : Array<Player>
    var currentTurn : Player?
    var nextTurn : Player?
    var winner : Player?
    var turnCounter : Int = 1 {
        didSet {
            guard let currentTurn = self.nextTurn else {
                self.currentTurn = players[0]
                return
            }
            self.currentTurn = currentTurn
            nextTurn = self.players[self.turnCounter % self.players.count ]
        }
    }
    
    init(with playSpace: Array<Square>, and players : Array<Player>) {
        self.playSpace = playSpace
        self.players = players
        self.currentTurn = players[0]
        self.nextTurn = players[1]
        self.rowLength = Int(sqrt(Double(playSpace.count)))
        self.setLength = rowLength - 1
    }
    
    func findWinner() -> Bool {
        if checkDiagonals() || checkVerticies() {
            self.winner = self.currentTurn
            return true
        }
        return false
    }
    
    func checkVerticies() -> Bool {
        for row in 0...setLength {
            if (checkHorizontal(rowNumber: row) || checkVertical(columnNumber: row)) {
                return true
            }
        }
        return false
    }
    
    func checkDiagonals() -> Bool {
        return (checkForwardDiagonal() || checkReverseDiagonal())
    }
    
    func checkVertical(columnNumber index: Int) -> Bool {
        // Grab the owner of the top most square on that column
        guard let owner = safelyGetSquare(by: index)?.owner else {
            // No owner means we don't need to check the rest of this column
            return false
        }
        
        for row in 1...setLength {
            let indexOfSquare = (row * rowLength) + index
            if !validateTheOwner(of: indexOfSquare, is: owner) {
                return false
            }
        }
        return true
    }
    
    func checkHorizontal(rowNumber startIndex: Int) -> Bool {
        let rowStart = startIndex * rowLength
        // Grab the owner of the left most square on that row
        guard let owner = safelyGetSquare(by: rowStart)?.owner else {
            // No owner means we don't need to check the rest of this row
            return false
        }
        
        for indexOfSquare in rowStart...(rowStart + setLength) {
            if !validateTheOwner(of: indexOfSquare, is: owner) {
                return false
            }
        }
        return true
    }
    
    func checkForwardDiagonal() -> Bool {
        // Grab the owner of the top left square
        guard let owner = safelyGetSquare(by: 0)?.owner else {
            // No owner means we don't need to check the rest of this set
            return false
        }
        
        for row in 1...setLength {
            let indexOfSquare = (row * rowLength ) + row
            print("Index FD: \(indexOfSquare)")
            if !validateTheOwner(of: indexOfSquare, is: owner) {
                return false
            }
        }
        return true
    }
    
    func checkReverseDiagonal() -> Bool {
        // Grab the owner of the top right square
        guard let owner = safelyGetSquare(by: setLength)?.owner else {
            // No owner means we don't need to check the rest of this set
            return false
        }
        
        for row in 2...rowLength {
            let indexOfSquare = (row * rowLength ) - row
            if !validateTheOwner(of: indexOfSquare, is: owner) {
                return false
            }
        }
        return true
    }
    
    func claim(node : String) {
        // We can't clame a new space if the game is won
        guard winner == nil else {
            return
        }
        
        // Attempt to locate the square that the user clicked
        guard let index = self.playSpace.index(where: { (square) -> Bool in
            square.name == node
        }) else {
            return
        }
        
        // Grab the square the the user clicked on
        guard let claimedSquare = safelyGetSquare(by: index) else {
            return
        }
        
        // Check that the space isn't clamed already
        if claimedSquare.owner == nil {
            // and clame it for the current player if it isn't
            claimedSquare.owner = self.currentTurn
            // we also want to increment the turn which will switch over to the new player
            self.turnCounter += 1
        }
        
        // Checks for and and prints the winner
        print("Winner: \(self.findWinner())")
    }
    
    func safelyGetSquare(by index: Int) -> Square? {
        // Gets the requested square if it exists else returns nil
        return Int(0) <= index && index < playSpace.count ? playSpace[index] : nil
    }
    
    func validateTheOwner(of index: Int, is owner :Player ) -> Bool {
        // First check that the requested square is in range
        guard let square = safelyGetSquare(by: index) else {
            return false
        }
        
        // Check that the owner of the square matches the owner that we were given
        // if no owner id present we can also fail
        guard square.owner?.label == owner.label else {
            return false
        }
        
        return true
    }
    
    func reset() {
        // Resets all the squares on the board
        for square in playSpace {
            square.reset()
        }
    }
    
}
