//
//  History.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 11/29/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

class History {
    
    // each dictionary will contain "start" and "end" move
    // Example: moves[0] = ["start": index1, "end": index2]
    var moves = [[String: BoardIndex]]()
    
    func showHistory() {
        for (i, m) in moves.enumerated() {
            let start = m["start"]
            let end = m["end"]
            print("Showing History======================")
            print("MOVE \(i+1)")
            print("Moved from: \(start?.valueCol.rawValue), \(start?.valueRow.rawValue)")
            print("To: \(end?.valueCol.rawValue), \(end?.valueRow.rawValue)")
        }
    }
    
}
