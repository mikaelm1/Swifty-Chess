//
//  King.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/29/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class King: ChessPiece {
    
    var firstMove = true

    init(row: Int, column: Int, color: UIColor) {
        
        super.init(row: row, column: column)
        self.color = color
        symbol = "♚"
        
    }
    
    /** Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the sate of the board.
        If first time moving, returns true for two moves left or right without
        considering Rook status.
     */
    func isMovementAppropriate(toIndex dest: BoardIndex) -> Bool {
        
        // king only moves one space at a time 
        let rowDelta = abs(self.row - dest.row)
        let colDelta = abs(self.col - dest.column)
        if (rowDelta == 0 || rowDelta == 1) && (colDelta == 0 || colDelta == 1) {
            return true
        }
        
        if firstMove {
            if rowDelta == 0 && colDelta == 2 {
                return true
            }
        }
        
        return false
    }
    
}
