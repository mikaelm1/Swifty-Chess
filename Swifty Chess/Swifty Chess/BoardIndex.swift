//
//  BoardIndex.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/31/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

class BoardIndex: Equatable {
    
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    static func ==(lhs: BoardIndex, rhs: BoardIndex) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
}
