//
//  ChessVC2.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/31/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class ChessVC: UIViewController {
    
    var chessBoard = ChessBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        drawBoard()
    }
    
    
    func drawBoard() {
        
        let cellDimension = (view.frame.size.width - 8) / 8
        print(cellDimension)
        var xOffset: CGFloat = 10
        var yOffset: CGFloat = 100
        for row in 0...7 {
            yOffset = (CGFloat(row) * cellDimension) + 80
            xOffset = 50
            for col in 0...7 {
                xOffset = (CGFloat(col) * cellDimension) + 4
                
                let piece = chessBoard.board[row][col]
                let cell = BoardCell(row: row, column: col, piece: piece)
                
                view.addSubview(cell)
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                } else {
                    cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            }
        }
    }
    
}

