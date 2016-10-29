//
//  ChessBoard.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

class ChessBoard {
    
    var board: [[ChessPiece]]!
    
    init() {
        
        let oneRow = Array(repeating: DummyPiece(row: 0, column: 0), count: 8)
        board = Array(repeating: oneRow, count: 8)
        
        for row in 0...7 {
            for col in 0...7 {
                switch row {
                case 0: // First row of chess board
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = Rook(row: row, column: col, color: .white)
                    case 1:
                        board[row][col] = Knight(row: row, column: col, color: .white)
                    case 2:
                        board[row][col] = Bishop(row: row, column: col, color: .white)
                    case 3:
                        board[row][col] = Queen(row: row, column: col, color: .white)
                    case 4:
                        board[row][col] = King(row: row, column: col, color: .white)
                    case 5:
                        board[row][col] = Bishop(row: row, column: col, color: .white)
                    case 6:
                        board[row][col] = Knight(row: row, column: col, color: .white)
                    default:
                        board[row][col] = Rook(row: row, column: col, color: .white)
                    }
                case 1:
                    board[row][col] = Pawn(row: row, column: col, color: .white)
                case 6:
                    board[row][col] = Pawn(row: row, column: col, color: .black)
                case 7:
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = Rook(row: row, column: col, color: .black)
                    case 1:
                        board[row][col] = Knight(row: row, column: col, color: .black)
                    case 2:
                        board[row][col] = Bishop(row: row, column: col, color: .black)
                    case 3:
                        board[row][col] = Queen(row: row, column: col, color: .black)
                    case 4:
                        board[row][col] = King(row: row, column: col, color: .black)
                    case 5:
                        board[row][col] = Bishop(row: row, column: col, color: .black)
                    case 6:
                        board[row][col] = Knight(row: row, column: col, color: .black)
                    default:
                        board[row][col] = Rook(row: row, column: col, color: .black)
                    }
                default:
                    board[row][col] = DummyPiece(row: row, column: col)
                }
            }
        }
    }
    
}
