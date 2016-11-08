//
//  ChessBoard.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

protocol ChessBoardDelegate {
    func boardUpdated()
    func gameOver(withWinner winner: UIColor)
    func gameTied()
}

class ChessBoard {
    
    var board = [[ChessPiece]]()
    var delegate: ChessVC?
    
    init() {
        
        let oneRow = Array(repeating: DummyPiece(row: 0, column: 0), count: 8)
        board = Array(repeating: oneRow, count: 8)
        startNewGame()
    }
    
    func startNewGame() {
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
        delegate?.boardUpdated()
    }
    
    func isAttackingOwnPiece(attackingPiece: ChessPiece, atIndex dest: BoardIndex) -> Bool {
        
        let destPiece = board[dest.row][dest.column]
        guard  !(destPiece is DummyPiece) else {
            // attacking an empty cell
            return false
        }
        
        return destPiece.color == attackingPiece.color
    }
    
    /// All move validations start here
    func isMoveLegal(forPiece piece: ChessPiece, toIndex dest: BoardIndex, considerOwnPiece consider: Bool) -> Bool {
        
        // Fix a bug. When checking if king can take opponent piece while under check by that piece
        if consider {
            if isAttackingOwnPiece(attackingPiece: piece, atIndex: dest) {
                return false
            }
        }
        
        if piece.col == dest.column && piece.row == dest.row {
            //print("Moving on itself")
            return false
        }
        
//        if !(piece is King) && doesMoveExposeKingToCheck(playerPiece: piece, toIndex: dest) {
//            return false
//        }
        
        switch piece {
        case is Pawn:
            return isMoveValid(forPawn: piece as! Pawn, toIndex: dest)
        case is Rook, is Bishop, is Queen:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case is Knight:
            // The knight doesn't care about the state of the board because
            // it jumps over pieces. So there is no piece in the way for example
            if !(piece as! Knight).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is King:
            return isMoveValid(forKing: piece as! King, toIndex: dest)
        default:
            break 
        }
        
        return true
    }
    
    func getPossibleMoves(forPiece piece: ChessPiece) -> [BoardIndex] {
        
        var possibleMoves = [BoardIndex]()
        for row in 0...7 {
            for col in 0...7 {
                let dest = BoardIndex(row: row, column: col)
                if isMoveLegal(forPiece: piece, toIndex: dest, considerOwnPiece: true) {
                    possibleMoves.append(dest)
                }
            }
        }
        
        // make sure that by making this move, the player is not exposing his king
        var realPossibleMoves = [BoardIndex]()
        
        if piece is King {
            print("Checking \(possibleMoves.count) moves for king")
            for move in possibleMoves {
                if !canOpponentAttack(playerKing: piece as! King, ifMovedTo: move) {
                    //print("Appending move for king")
                    if (piece as! King).firstMove && isMoveTwoCellsOver(forKing: piece as! King, move: move) {
                        if isRookNext(toKing: piece as! King, forMove: move) {
                            realPossibleMoves.append(move)
                        }
                    } else {
                        realPossibleMoves.append(move)
                    }
                }
            }
        } else {
            for move in possibleMoves {
                //print("BEFORE")
                //printBoard()
                if !doesMoveExposeKingToCheck(playerPiece: piece, toIndex: move) {
                    realPossibleMoves.append(move)
                }
                //print("AFTER")
                //printBoard()
            }
        }
        
        //print("\(realPossibleMoves.count) real moves")
        return realPossibleMoves
    }
    
    /// Makes the given move and checks for game over/tie and reports back through delegates
    func move(chessPiece: ChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) {
        
        if chessPiece is King {
            (chessPiece as! King).firstMove = false
            if isMoveTwoCellsOver(forKing: chessPiece as! King, move: dest) {
                //print("KING MOVED 2 Pieces OVER")
                board[dest.row][dest.column] = chessPiece
                chessPiece.row = dest.row
                chessPiece.col = dest.column
                board[source.row][source.column] = DummyPiece(row: source.row, column: source.column)
                let rook = board[dest.row][dest.column+1]
                board[dest.row][dest.column+1] = DummyPiece(row: dest.row, column: dest.column+1)
                rook.row = dest.row
                rook.col = dest.column - 1
                board[dest.row][dest.column-1] = rook
                
            } else {
                board[dest.row][dest.column] = chessPiece
                board[source.row][source.column] = DummyPiece(row: source.row, column: source.column)
                chessPiece.row = dest.row
                chessPiece.col = dest.column
            }
        } else {
            // add piece to new location
            board[dest.row][dest.column] = chessPiece
            // add a dummy piece at old location
            board[source.row][source.column] = DummyPiece(row: source.row, column: source.column)
            // update piece's location variables
            chessPiece.row = dest.row
            chessPiece.col = dest.column
        }
        
        // check if by making this move, the player has won the game
        if isWinner(player: chessPiece.color, byMove: dest) {
            delegate?.gameOver(withWinner: chessPiece.color)
        } else if isGameTie(withCurrentPlayer: chessPiece.color) {
            delegate?.gameTied()
        }
        
        delegate?.boardUpdated()
    }
    
    // MARK: - Move validations per piece type 
    
    func isMoveValid(forPawn pawn: Pawn, toIndex dest: BoardIndex) -> Bool {

        if pawn.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        
        // if it's same column
        if pawn.col == dest.column {
            if pawn.tryingToAdvanceBy2 {
                let moveDirection = pawn.color == .black ? -1 : 1
                
                // make sure there are no pieces in the way or at destination
                if board[dest.row][dest.column] is DummyPiece && board[dest.row - moveDirection][dest.column] is DummyPiece {
                    return true
                }
            } else {
                if board[dest.row][dest.column] is DummyPiece {
                    return true
                }
            }
        } else { // attempting to go diagonally
            // We will check that the destination cell does not contain a friend piece before getting to this cell
            // So just make sure the cell is not empty
            if !(board[dest.row][dest.column] is DummyPiece) {
                return true
            }
        }
        
        return false 
    }
    
    func isMoveValid(forRookOrBishopOrQueen piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        switch piece {
        case is Rook:
            if !(piece as! Rook).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is Bishop:
            if !(piece as! Bishop).isMovementAppropriate(toIndex: dest) {
                return false
            }
        case is Queen:
            if !(piece as! Queen).isMovementAppropriate(toIndex: dest) {
                return false
            }
        default:
            // shouldn't be here
            return false
        }
        
        // Diagonal movement for either queen or bishop:
        // *** eg: from index (1,1) to index (3,3) would need to go through (1,1), (2,2), (3,3)
        // Straight movement for either queen or rook:
        // *** eg: from index (1,5) to (1,2) would need to go through (1,5), (1,4), (1,3), (1,2)
        
        // Get the movement directions in both rows and columns
        var rowDelta = 0
        if dest.row - piece.row != 0 {
            // this value will be either -1 or 1 
            rowDelta = (dest.row - piece.row) / abs(dest.row - piece.row)
        }
        var colDelta = 0
        if dest.column - piece.col != 0 {
            colDelta = (dest.column - piece.col) / abs(dest.column - piece.col)
        }
        
        // make sure there are no pieces between itself and the destination cell
        var nextRow = piece.row + rowDelta
        var nextCol = piece.col + colDelta
        while nextRow != dest.row || nextCol != dest.column {
            if !(board[nextRow][nextCol] is DummyPiece) {
                return false
            }
            nextRow += rowDelta
            nextCol += colDelta
        }
        
        return true
    }
    
    func isMoveValid(forKing king: King, toIndex dest: BoardIndex) -> Bool {
        
        if !(king.isMovementAppropriate(toIndex: dest)) {
            return false
        }
        
        if isAnotherKing(atIndex: dest, forKing: king) {
            return false
        }
        
        return true
    }
    
    /// called from getPossibleMoves and when move made
    private func isMoveTwoCellsOver(forKing king: King, move: BoardIndex) -> Bool {
        let colDelta = abs(king.col - move.column)
        return colDelta == 2
    }
    
    /// called from getPossibleMoves only
    private func isRookNext(toKing king: King, forMove move: BoardIndex) -> Bool {
        if king.color == .white {
            //if move.row == 0 && move.column == 6
            return move.row == 0 && move.column == 6 && board[move.row][move.column + 1] is Rook
        } else if king.color == .black {
            return move.row == 7 && move.column == 6 && board[move.row][move.column + 1] is Rook
        }
        return false
    }
    
    func canOpponentAttack(playerKing king: King, ifMovedTo dest: BoardIndex) -> Bool {
        print("inside canOpponentAttack(playerKing:)")
        let opponent: UIColor = king.color == .white ? .black : .white
        if opponent == .black && king.color == .white {
            print("Checking if black opponent can attack white king")
        } else if opponent == .white && king.color == .black {
            print("Checking if white opponent can attack black king")
        }
        for row in 0...7 {
            for col in 0...7 {
                let piece = board[row][col]
                if piece.color == opponent {
                    if piece is Bishop && piece.color == .black {
                        print("Checking black bishop!!!!!!!")
                    }
                    //print("Can \(piece.printInfo()) attack king????????")
                    if isMoveLegal(forPiece: piece, toIndex: dest, considerOwnPiece: false) {
                        print("Can \(piece.printInfo()) attack king is true")
                        return true
                    }
                    
                    
                }
            }
        }
        return false
    }
    
    private func isAnotherKing(atIndex dest: BoardIndex, forKing king: King) -> Bool {
        
        let opponentColor = king.color == UIColor.white ? UIColor.black : UIColor.white
        // Get other king's index
        var otherKingIndex: BoardIndex!
        for row in 0...7 {
            for col in 0...7 {
                if let opponentKing = board[row][col] as? King, opponentKing.color == opponentColor {
                    otherKingIndex = BoardIndex(row: row, column: col)
                    break
                }
            }
        }
        
        // compute absolute difference between the kings
        let rowDiff = abs(otherKingIndex.row - king.row)
        let colDiff = abs(otherKingIndex.column - king.col)
        if (rowDiff == 0 || rowDiff == 1) && (colDiff == 0 || colDiff == 1) {
            print("Another king is right there")
            return true
        }
        //print("Not near opponent")
        return false
        
    }
    
    /// Returns true if current player is under check, false otherwise
    func isPlayerUnderCheck(playerColor: UIColor) -> Bool {
        
        guard let playerKing = getKing(forColor: playerColor) else {
            print("Something is seriously wrong")
            return false
        }
        
        let opponentColor: UIColor = playerColor == .white ? .black : .white
        
        return isKingUnderUnderCheck(king: playerKing, byOpponent: opponentColor)
    }
    
    private func getKing(forColor color: UIColor) -> King? {
        if color == .white {
            //print("Looking for white king")
        } else if color == .black {
            //print("looking for black king")
        }
        for row in 0...7 {
            for col in 0...7 {
                if let king = board[row][col] as? King, king.color == color {
                    return king
                }
            }
        }
        // should never get here
        print("Did not find king")
        return nil
    }
    
    /// returns true if player's king is under check, false otherwise. Called by
    /// another function: isPlayerUnderCheck
    private func isKingUnderUnderCheck(king: King, byOpponent color: UIColor) -> Bool {
        
        let kingIndex = BoardIndex(row: king.row, column: king.col)
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].color == color {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex, considerOwnPiece: true) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Simulates the move and returns true if making it will expose the player to a check
    func doesMoveExposeKingToCheck(playerPiece piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {

        let opponent: UIColor = piece.color == UIColor.white ? .black : .white
        guard let playerKing = getKing(forColor: piece.color) else {
            print("Something wrong in doesMoveExposeKingToCheck. Logic error")
            return false
        }
        //print("Piece index before: \(piece.row), \(piece.col)")

        let kingIndex = BoardIndex(row: playerKing.row, column: playerKing.col)
        //print("King index: \(kingIndex.row), \(kingIndex.column)")
        // can opponent attack own king if player makes this move?
        for row in 0...7 {
            for col in 0...7 {
                
                // "place" piece at the destination it's actually trying to go
                let pieceBeingAttacked = board[dest.row][dest.column]
                board[dest.row][dest.column] = piece
                board[piece.row][piece.col] = DummyPiece(row: piece.row, column: piece.col)
                //print("Piece being attacked: \(pieceBeingAttacked.printInfo()) by \(piece.printInfo())")
                
                if board[row][col].color == opponent {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex, considerOwnPiece: true) {
                        //print("\(board[row][col].symbol) can attack your king!")
                        // undo fake move
                        board[dest.row][dest.column] = pieceBeingAttacked
                        board[piece.row][piece.col] = piece
                        print("Move will expose king to check")
                        return true
                    }
                }
                
                // undo fake move
                board[dest.row][dest.column] = pieceBeingAttacked
                board[piece.row][piece.col] = piece
            }
        }
        
        return false
    }
    
    func printBoard() {
        print(String(repeating: "=", count: 40))
        for row in 0...7 {
            let bRow = board[row].map {$0.symbol}
            print(bRow)
        }
        print(String(repeating: "=", count: 40))
    }
    
    func isWinner(player color: UIColor, byMove move: BoardIndex) -> Bool {
        // Player wins if opponent's king has no more moves and the
        // opponent can't block the check with another one of his pieces
        let attackingPiece = board[move.row][move.column]
        let opponent: UIColor = color == UIColor.white ? .black : .white
        // check if the current player's move put opponent in check
        if isPlayerUnderCheck(playerColor: opponent) {
            print("Opponent under check")
            // does opponent's king have any possible moves
            guard let opponentKing = getKing(forColor: opponent) else {
                print("Something seriously wrong in isWinner. DEBUG!!")
                return false
            }
            let possibKingleMoves = getPossibleMoves(forPiece: opponentKing)
            // can another piece block the check or take out the piece causing the check
            if possibKingleMoves.count == 0 && !canPlayerEscapeCheck(player: opponent, fromAttackingPiece: attackingPiece) {
                return true
            }
        }
        
        return false
    }
    
    func canPlayerEscapeCheck(player: UIColor, fromAttackingPiece attacker: ChessPiece) -> Bool {
        
        guard let playerKing = getKing(forColor: player) else {
            print("canPlayerEscapeCheck SERIOUS ERROR")
            return false
        }
        for row in 0...7 {
            for col in 0...7 {
                let piece = board[row][col]
                let dest = BoardIndex(row: piece.row, column: piece.col)
                // if it's one of the player's pieces
                if piece.color == player {
                    let possibleMoves = getPossibleMoves(forPiece: piece)
                    // simulate every possible move and see if it ends check
                    for move in possibleMoves {
                        if canMove(move: move, takeOutChessPiece: attacker) || canMove(fromIndex: dest, toIndex: move, blockCheckBy: attacker, forKing: playerKing) {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func canMove(move: BoardIndex, takeOutChessPiece piece: ChessPiece) -> Bool {
        //print("Can take out attacking piece")
        return move.row == piece.row && move.column == piece.col
    }
    
    func canMove(fromIndex source: BoardIndex, toIndex dest: BoardIndex, blockCheckBy piece: ChessPiece, forKing king: King) -> Bool {
        
        let opponent: UIColor = king.color == .white ? .black : .white
        let movingPiece = board[source.row][source.column]
        board[dest.row][dest.column] = movingPiece
        board[source.row][source.column] = DummyPiece(row: 0, column: 0)
        movingPiece.col = dest.column
        movingPiece.row = dest.row
        
        if !isKingUnderUnderCheck(king: king, byOpponent: opponent) {
            // undo fake move
            board[source.row][source.column] = movingPiece
            board[dest.row][dest.column] = DummyPiece(row: dest.row, column: dest.column)
            movingPiece.row = source.row
            movingPiece.col = source.column
            print("Can block check")
            return true
        }
        
        // undo fake move
        board[source.row][source.column] = movingPiece
        board[dest.row][dest.column] = DummyPiece(row: dest.row, column: dest.column)
        movingPiece.row = source.row
        movingPiece.col = source.column
        
        return false
    }
    
    /// Called after the passed in player made a move
    private func isGameTie(withCurrentPlayer player: UIColor) -> Bool {
        // TODO: Add a more exhuastive list of draw possibilities
        
        // if only kings remain game is tied
        if onlyKingsLeft() {
            print("Only 2 kings left")
            return true
        }
        // or draw if currentPlayer or opponent not in check and has no possible moves
        //let playerPieces = getAllPieces(forPlayer: player)
        var movesLeft = false
//        for piece in playerPieces {
//            if getPossibleMoves(forPiece: piece).count > 0 {
//                movesLeft = true
//            }
//        }
        let opponent: UIColor = player == .white ? .black : .white
        let opponentPieces = getAllPieces(forPlayer: opponent)
        for piece in opponentPieces {
            if getPossibleMoves(forPiece: piece).count > 0 {
                movesLeft = true
            }
        }
        
        return !movesLeft
    }
    
    /// A helper function called from isGameTie(_:)
    private func getAllPieces(forPlayer player: UIColor) -> [ChessPiece] {
        var playerPieces = [ChessPiece]()
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].color == player {
                    playerPieces.append(board[row][col])
                }
            }
        }
        
        return playerPieces
    }
    
    /// A helper function called from isGameTie(_:)
    private func onlyKingsLeft() -> Bool {
        var count = 0
        for row in 0...7 {
            for col in 0...7 {
                if !(board[row][col] is DummyPiece) {
                    count += 1
                }
                if count > 2 {
                    return false
                }
            }
        }
        return true
    }
    
}



