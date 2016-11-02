//
//  Knight.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class Knight: ChessPiece {
    
    init(row: Int, column: Int, color: UIColor) {
        
        super.init(row: row, column: column)
        self.color = color
        symbol = "♞"
        
    }
    
    /** Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the sate of the board */
    func isMovementAppropriate(toIndex dest: BoardIndex) -> Bool {
        
        let validMoves =  [(self.row - 1, self.col + 2), (self.row - 2, self.col + 1), (self.row - 2, self.col - 1), (self.row - 1, self.col - 2), (self.row + 1, self.col - 2), (self.row + 2, self.col - 1), (self.row + 2, self.col + 1), (self.row + 1, self.col + 2)]
        
        for (validRow, validCol) in validMoves {
            if dest.row == validRow && dest.column == validCol {
                return true
            }
        }
        
        return false
    }
    
}
