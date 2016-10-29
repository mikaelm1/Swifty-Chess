//
//  ViewController.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/28/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class ChessViewController: UIViewController {
    
    lazy var chessCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ChessCell.self, forCellWithReuseIdentifier: "chessCell")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .blue
        return cv
    }()
    
    var chessBoard: ChessBoard!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        chessBoard = ChessBoard()
        
        setupBoard()
    }
    
    func setupBoard() {
        view.addSubview(chessCollectionView)
        
        chessCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        chessCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        chessCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        let height = (view.frame.size.width - 20)
        chessCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }


}

extension ChessViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chessCell", for: indexPath) as! ChessCell
        
        // The sections will be the rows and the items will be the columns
        let piece = chessBoard.board[indexPath.section][indexPath.item]
        cell.pieceLabel.text = piece.symbol
        cell.pieceLabel.textColor = piece.color
        
        // Set up the board colors
        if (indexPath.item % 2 == 0 && indexPath.section % 2 == 0) || (indexPath.item % 2 != 0 && indexPath.section % 2 != 0) {
            cell.backgroundColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath.item) In Section: \(indexPath.section)")
        print("Selected piece: \(chessBoard.board[indexPath.section][indexPath.item].symbol)")
        
        // TODO: Get the possible moves from the chess board model and highlight them
        let possibleMoves = [chessBoard.board[0][0], chessBoard.board[0][1]]
        for move in possibleMoves {
            let cellIndex = IndexPath(row: move.row, section: move.col)
            let cell = collectionView.cellForItem(at: cellIndex) as! ChessCell
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (view.frame.size.width - 20) / 8
        //print(dimension)
        return CGSize(width: dimension, height: dimension)
    }
    
}

class ChessCell: UICollectionViewCell {
    
    var pieceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 25)
        l.textColor = .black
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(pieceLabel)
        pieceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        pieceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        pieceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        pieceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

