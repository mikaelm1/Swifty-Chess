//
//  Bishop.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/29/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class Bishop: ChessPiece {
    
    init(row: Int, column: Int, color: UIColor) {
        
        super.init(row: row, column: column)
        self.color = color
        symbol = "💩"
        
    }
    /** Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the sate of the board */
    func isMovementAppropriate(toIndex dest: BoardIndex) -> Bool {
        
        if abs(dest.row - self.row) == abs(dest.column - self.col) {
            return true
        }
        return false
    }
    
}
