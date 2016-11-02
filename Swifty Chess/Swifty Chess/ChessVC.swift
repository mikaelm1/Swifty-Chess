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
    var boardCells = [[BoardCell]]()
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        drawBoard()
    }
    
    
    func drawBoard() {
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: DummyPiece(row: 5, column: 5), color: .white), count: 8)
        boardCells = Array(repeating: oneRow, count: 8)
        let cellDimension = (view.frame.size.width - 8) / 8
        var xOffset: CGFloat = 10
        var yOffset: CGFloat = 100
        for row in 0...7 {
            yOffset = (CGFloat(row) * cellDimension) + 80
            xOffset = 50
            for col in 0...7 {
                xOffset = (CGFloat(col) * cellDimension) + 4
                
                let piece = chessBoard.board[row][col]
                let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                cell.delegate = self
                boardCells[row][col] = cell
                
                view.addSubview(cell)
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                } else {
                    cell.color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                // set the color
                cell.removeHighlighting()
            }
        }
    }

}

extension ChessVC: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        print("Selected cell at: \(row), \(col)")
        
        // Check if making a move (if had selected piece before)
        if let movingPiece = pieceBeingMoved {
            let source = BoardIndex(row: movingPiece.row, column: movingPiece.col)
            let dest = BoardIndex(row: row, column: col)
            
            // check if selected one of possible moves, if so move there
            for move in possibleMoves {
                if move.row == row && move.column == col {
                    
                    chessBoard.move(chessPiece: movingPiece, fromIndex: source, toIndex: dest)
                    drawBoard()
                    pieceBeingMoved = nil
                    return
                }
            }
            // check if selected another own piece
            if chessBoard.isAttackingOwnPiece(attackingPiece: movingPiece, atIndex: dest) {
                // remove the old selected cell coloring and set new piece
                boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
                pieceBeingMoved = cell.piece
                cell.backgroundColor = .red 
                
                // reset the possible moves 
                removeHighlights()
                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                highligtPossibleMoves()
            }
        } else {
            // selected piece to be moved
            cell.backgroundColor = .red
            pieceBeingMoved = cell.piece
            removeHighlights()
            possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
            highligtPossibleMoves()
        }
        
    }
    
    func highligtPossibleMoves() {
        for move in possibleMoves {
            //print(move.row)
            boardCells[move.row][move.column].setAsPossibleLocation()
        }
    }
    
    func removeHighlights() {
        for move in possibleMoves {
            //print(move.row)
            boardCells[move.row][move.column].removeHighlighting()
        }
    }
    
}

