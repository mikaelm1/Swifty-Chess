//
//  ChessPiece.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class ChessPiece {
    
    var row: Int
    var col: Int
    var symbol: String
    var color: UIColor
    
    init(row: Int, column: Int) {
        self.row = row
        self.col = column
        self.symbol = "   "
        self.color = .clear 
    }
    
    func printInfo() -> String {
        var pColor = "Clear"
        if color == .white {
            pColor = "White"
        } else if color == .black {
            pColor = "Black"
        }
        return "\(pColor) \(symbol)"
    }
    
}
