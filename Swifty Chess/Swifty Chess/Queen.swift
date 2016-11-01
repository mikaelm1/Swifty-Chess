//
//  Queen.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/29/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class Queen: ChessPiece {
    
    init(row: Int, column: Int, color: UIColor) {
        
        super.init(row: row, column: column)
        self.color = color
        symbol = "♛"
        
    }
    
    /** Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the sate of the board */
    func isMovementAppropriate(toIndex dest: BoardIndex) -> Bool {
        
        // check diagonal move
        if abs(dest.row - self.row) == abs(dest.column - self.col) {
            return true
        }
        
        // check rook-like move 
        if self.row == dest.row || self.col == dest.column {
            return true 
        }
        
        return false
    }
    
}
