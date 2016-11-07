//
//  Swifty_ChessTests.swift
//  Swifty ChessTests
//
//  Created by Mikael Mukhsikaroyan on 11/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import XCTest
@testable import Swifty_Chess

class Swifty_ChessTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    let chessVC = ChessVC()
    
    override func setUp() {
        super.setUp()
        chessBoard.startNewGame()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialBoard() {
        // test some white pieces
        XCTAssertTrue(chessBoard.board[0][0] is Rook && chessBoard.board[0][0].color == .white, "There should be a rook at (0,0)")
        XCTAssertTrue(chessBoard.board[0][4] is King && chessBoard.board[0][4].color
            == .white, "The white king should be at (0,4)")
        
        // test some black pieces
        XCTAssertTrue(chessBoard.board[7][7] is Rook && chessBoard.board[7][7].color == .black, "Black rook should be at (7,7)")
        XCTAssertTrue(chessBoard.board[7][4] is King && chessBoard.board[7][4].color == .black, "Black king should be at (7,4)")
    }
    
    func testOnlyTwoKingsLeft() {
        class ChessVCMock: ChessVC {
            var tied = false
            var updated = false
            
            override func gameTied() {
                tied = true
            }
            
            override func boardUpdated() {
                updated = true
            }
        }
        let mockVC = ChessVCMock()
        mockVC.chessBoard = chessBoard
        chessBoard.delegate = mockVC
        // remove all but the kings from board
        for row in 0...7 {
            for col in 0...7 {
                if !(chessBoard.board[row][col] is King) && !(chessBoard.board[row][col] is DummyPiece) {
                    chessBoard.board[row][col] = DummyPiece(row: row, column: col)
                }
            }
        }
        chessBoard.move(chessPiece: chessBoard.board[0][0], fromIndex: BoardIndex(row: 0, column: 0), toIndex: BoardIndex(row: 0, column: 1))
        XCTAssertTrue(mockVC.updated, "Board did not update")
        XCTAssertTrue(mockVC.tied, "Game did not end")
        
    }
    
    func testGameOver() {
        
        class ChessVCMock: ChessVC {
            var gameOverCalled = false
            var numUpdates = 0
            
            override func gameOver(withWinner winner: UIColor) {
                gameOverCalled = true
            }
            
            override func boardUpdated() {
                numUpdates += 1
            }
        }
        let mockVC = ChessVCMock()
        mockVC.chessBoard = chessBoard
        chessBoard.delegate = mockVC
        // move black pawn
        chessBoard.move(chessPiece: chessBoard.board[6][4], fromIndex: BoardIndex(row: 6, column: 4), toIndex: BoardIndex(row: 4, column: 4))
        // move white pawn
        chessBoard.move(chessPiece: chessBoard.board[1][4], fromIndex: BoardIndex(row: 1, column: 4), toIndex: BoardIndex(row: 3, column: 4))
        // move black bishop
        chessBoard.move(chessPiece: chessBoard.board[7][5], fromIndex: BoardIndex(row: 7, column: 5), toIndex: BoardIndex(row: 4, column: 2))
        // move white pawn
        chessBoard.move(chessPiece: chessBoard.board[2][3], fromIndex: BoardIndex(row: 2, column: 3), toIndex: BoardIndex(row: 3, column: 3))
        // move black queen
        chessBoard.move(chessPiece: chessBoard.board[7][3], fromIndex: BoardIndex(row: 7, column: 3), toIndex: BoardIndex(row: 5, column: 5))
        // move white knight
        chessBoard.move(chessPiece: chessBoard.board[0][1], fromIndex: BoardIndex(row: 0, column: 1), toIndex: BoardIndex(row: 2, column: 2))
        // move black queen to attack king
        chessBoard.move(chessPiece: chessBoard.board[5][5], fromIndex: BoardIndex(row: 5, column: 5), toIndex: BoardIndex(row: 1, column: 5))

        XCTAssertTrue(mockVC.numUpdates == 7, "Delegate didn't send enough updates for each move")
        XCTAssertTrue(mockVC.gameOverCalled, "Game over was not called")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
