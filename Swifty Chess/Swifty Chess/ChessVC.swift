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
    var playerTurn = UIColor.black
    
    let turnLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let checkLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .red
        return l
    }()
    
    lazy var restartButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restart Game", for: [])
        b.setTitleColor(.white, for: [])
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.addTarget(self, action: #selector(restartPressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
        
        chessBoard.delegate = self
        
        drawBoard()
        setupViews()
    }
    
    func drawBoard() {
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: DummyPiece(row: 5, column: 5), color: .clear), count: 8)
        boardCells = Array(repeating: oneRow, count: 8)
        let cellDimension = (view.frame.size.width - 0) / 8
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 100
        for row in 0...7 {
            yOffset = (CGFloat(row) * cellDimension) + 80
            xOffset = 50
            for col in 0...7 {
                xOffset = (CGFloat(col) * cellDimension) + 0
                
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
        updateLabel()
    }
    
    func setupViews() {
        
        view.addSubview(restartButton)
        restartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        restartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        
        view.addSubview(turnLabel)
        turnLabel.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -10).isActive = true
        turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(checkLabel)
        checkLabel.bottomAnchor.constraint(equalTo: turnLabel.topAnchor, constant: -10).isActive = true
        checkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func updateLabel() {
        let color = playerTurn == .white ? "White" : "Black"
        turnLabel.text = "\(color) player's turn"
    }
    
    // MARK: - Actions
    
    func restartPressed(sender: UIButton) {
        let ac = UIAlertController(title: "Restart", message: "Are you sure you want to restart the game?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.chessBoard.startNewGame()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }

}

extension ChessVC: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        //print("Selected cell at: \(row), \(col)")
        
        // Check if making a move (if had selected piece before)
        if let movingPiece = pieceBeingMoved, movingPiece.color == playerTurn {
            let source = BoardIndex(row: movingPiece.row, column: movingPiece.col)
            let dest = BoardIndex(row: row, column: col)
            
            // check if selected one of possible moves, if so move there
            for move in possibleMoves {
                if move.row == row && move.column == col {
                    
                    //print(chessBoard.board[cell.row][cell.column].symbol)
                    chessBoard.move(chessPiece: movingPiece, fromIndex: source, toIndex: dest)
                    //print(chessBoard.board[cell.row][cell.column].symbol)
                    //drawBoard()
                    
                    pieceBeingMoved = nil
                    playerTurn = playerTurn == .white ? .black : .white
                    if chessBoard.isPlayerUnderCheck(playerColor: playerTurn) {
                        checkLabel.text = "You are in check"
                    } else {
                        checkLabel.text = ""
                    }
                    updateLabel()
                    //print("The old cell now holds: \(cell.piece.symbol)")
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
        } else { // not already moving piece
    
            if cell.piece.color == playerTurn {
                // selected another piece to play
                cell.backgroundColor = .red
                pieceBeingMoved = cell.piece
                removeHighlights()
                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                highligtPossibleMoves()
            } else {
                // tapped on either emtpy cell or enemy piece, ignore
            }
            
        }
        
        updateLabel()
        //print("The old cell now holds: \(cell.piece.symbol)")
        //print(chessBoard.board[cell.row][cell.column])
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

extension ChessVC: ChessBoardDelegate {
    
    func boardUpdated() {
        //print("Board updated")
        for row in 0...7 {
            for col in 0...7 {
                let cell = boardCells[row][col]
                let piece = chessBoard.board[row][col]
                cell.configureCell(forPiece: piece)
            }
        }
        
    }
    
    func gameOver(withWinner winner: UIColor) {
        if winner == .white {
            showGameOver(message: "White player won!")
        } else if winner == .black {
            showGameOver(message: "Black player won!")
        }
    }
    
    func gameTied() {
        print("GAME TIED!!!")
        showGameOver(message: "Game Tied!")
    }
    
    func promote(pawn: Pawn) {
        showPawnPromotionAlert(forPawn: pawn)
    }
    
    // MARK: Alerts
    
    func showGameOver(message: String) {
        let ac = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.chessBoard.startNewGame()
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { action in
            
            print("Too bad. That's all we can do right now. Haven't added another scene yet")
            //self.chessBoard.startNewGame()
        })
        
        ac.addAction(okAction)
        ac.addAction(noAction)
        present(ac, animated: true, completion: nil)
    }
    
    func showPawnPromotionAlert(forPawn pawn: Pawn) {
        let ac = UIAlertController(title: "Promote Pawn", message: "Please choose the piece you want to promote your pawn into", preferredStyle: .actionSheet)
        let queen = UIAlertAction(title: "Queen", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: Queen(row: pawn.row, column: pawn.col, color: pawn.color))
        })
        let rook = UIAlertAction(title: "Rook", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: Rook(row: pawn.row, column: pawn.col, color: pawn.color))
        })
        ac.addAction(queen)
        ac.addAction(rook)
        present(ac, animated: true, completion: nil)
    }
    
}

