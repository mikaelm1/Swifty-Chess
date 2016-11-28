////
////  ViewController.swift
////  Swifty Chess
////
////  Created by Mikael Mukhsikaroyan on 10/28/16.
////  Copyright © 2016 MSquaredmm. All rights reserved.
////
//
//// LEGACY: NOT ACTIVE
//import UIKit
//
//class ChessViewController: UIViewController {
//    
//    lazy var chessCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(ChessCell.self, forCellWithReuseIdentifier: "chessCell")
//        cv.delegate = self
//        cv.dataSource = self
//        cv.backgroundColor = .blue
//        return cv
//    }()
//    
//    var chessBoard: ChessBoard!
//    var isMakingAMove = false
//    var chessPieceToBeMoved: ChessPiece?
//    var highlightedCells = [ChessCell]()
//    var possibleMoves = [BoardIndex]()
//    var currentPlayerTurn = UIColor.white
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        chessBoard = ChessBoard()
//        
//        setupViews()
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.drawBoard()
//        }
//        
//        let dummy = UIButton(type: .system)
//        dummy.translatesAutoresizingMaskIntoConstraints = false
//        //dummy.titleLabel?.text = "I'm a dummy"
//        dummy.setTitle("I'm a dummy", for: [])
//        dummy.addTarget(self, action: #selector(dummyTapped(sender:)), for: .touchUpInside)
//        view.addSubview(dummy)
//        dummy.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        dummy.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//    }
//    
//    func dummyTapped(sender: UIButton) {
//        let vc = ChessVC()
//        present(vc, animated: true, completion: nil)
//    }
//    
//    func setupViews() {
//        view.addSubview(chessCollectionView)
//        
//        chessCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
//        chessCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
//        chessCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
//        
//        let height = (view.frame.size.width - 20)
//        chessCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
//    }
//
//
//}
//
//extension ChessViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chessCell", for: indexPath) as! ChessCell
//        
//        // The sections will be the rows and the items will be the columns
////        let piece = chessBoard.board[indexPath.section][indexPath.item]
////        cell.pieceLabel.text = piece.symbol
////        cell.pieceLabel.textColor = piece.color
////        
////        // Set up the board colors
////        if (indexPath.item % 2 == 0 && indexPath.section % 2 == 0) || (indexPath.item % 2 != 0 && indexPath.section % 2 != 0) {
////            cell.backgroundColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
////        } else {
////            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
////        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected item: \(indexPath.item) In Section: \(indexPath.section)")
//        //print("Selected piece: \(chessBoard.board[indexPath.section][indexPath.item].symbol)")
//        
//        if !isMakingAMove {
//            // tapped on a piece. Show possible moves
//            isMakingAMove = true
//            
//            let selectedCell = collectionView.cellForItem(at: indexPath)
//            selectedCell?.backgroundColor = .red
//            
//            chessPieceToBeMoved = chessBoard.board[indexPath.section][indexPath.item]
//            //print(chessPieceToBeMoved?.symbol)
//            
//            showMoves(forPiece: chessPieceToBeMoved!, atIndexPath: indexPath)
//            
//        } else {
//            isMakingAMove = false
//            // If tapped one of available moves, move piece there
//            let destinationIndex = BoardIndex(row: indexPath.section, column: indexPath.item)
//            for move in possibleMoves {
//                if move == destinationIndex {
//                    if let piece = chessPieceToBeMoved {
//                        let sourceIndex = BoardIndex(row: piece.row, column: piece.col)
//                        chessBoard.move(chessPiece: piece, fromIndex: sourceIndex, toIndex: destinationIndex)
//                    }
//                }
//            }
//            
//            // If tapped on another own piece, then switch highlight to that
//            if chessBoard.isAttackingOwnPiece(attackingPiece: chessPieceToBeMoved!, atIndex: destinationIndex) {
//                isMakingAMove = true
//                removeHighlights()
//                chessPieceToBeMoved = chessBoard.board[indexPath.section][indexPath.item]
//                showMoves(forPiece: chessPieceToBeMoved!, atIndexPath: indexPath)
//            }
//            
//            // if tapped on empty cell that's not in available moves
//            
//            
//            // refresh board ui
//        }
//        drawBoard()
//    }
//    
//    func drawBoard() {
//        // The sections will be the rows and the items will be the columns
//        
//        for row in 0...7 {
//            for col in 0...7 {
//                let indexPath = IndexPath(row: col, section: row)
//                let piece = chessBoard.board[row][col]
//                let cell = chessCollectionView.cellForItem(at: indexPath) as! ChessCell
//                cell.pieceLabel.text = piece.symbol
//                cell.pieceLabel.textColor = piece.color
//                // Set up the board colors
//                if (indexPath.item % 2 == 0 && indexPath.section % 2 == 0) || (indexPath.item % 2 != 0 && indexPath.section % 2 != 0) {
//                    cell.backgroundColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
//                } else {
//                    cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
//                }
//            }
//        }
//    }
//    
//    func removeHighlights() {
//        for cell in highlightedCells {
//            cell.removeHighlighting()
//        }
//    }
//    
//    func showMoves(forPiece piece: ChessPiece, atIndexPath index: IndexPath) {
//        possibleMoves = chessBoard.getPossibleMoves(forPiece: piece)
//        for move in possibleMoves {
//            print("Move: \(move.row), \(move.column)")
//            let cellIndex = IndexPath(row: move.column, section: move.row)
//            let cell = chessCollectionView.cellForItem(at: cellIndex) as! ChessCell
//            print("Cell loc: \(cellIndex.section), \(cellIndex.item)")
//            print("Cell name: \(cell.pieceLabel.text)")
//            cell.setAsPossibleMoveLocation()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let dimension = (view.frame.size.width - 20) / 8
//        //print(dimension)
//        return CGSize(width: dimension, height: dimension)
//    }
//    
//}
//
//
//
