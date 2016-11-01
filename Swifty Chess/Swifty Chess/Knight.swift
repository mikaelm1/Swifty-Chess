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
    func isMovementAppropriate(fromIndex source: BoardIndex, toIndex dest: BoardIndex) -> Bool {
        
        let validMoves =  [(source.row - 1, source.column + 2), (source.row - 2, source.column + 1), (source.row - 2, source.column - 1), (source.row - 1, source.column - 2), (source.row + 1, source.column - 2), (source.row + 2, source.column - 1), (source.row + 2, source.column + 1), (source.row + 1, source.column + 2)]
        
        for (validRow, validCol) in validMoves {
            if dest.row == validRow && dest.column == validCol {
                return true
            }
        }
        
        return false
    }
    
}
