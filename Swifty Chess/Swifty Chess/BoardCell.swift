//
//  BoardCell.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 11/1/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class BoardCell: UIView {
    
    var row: Int
    var column: Int
    var piece: ChessPiece
    
    lazy var invisibleButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(selectedCell(sender:)), for: .touchUpInside)
        return b
    }()
    
    let pieceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 24)
        return l
    }()
    
    init(row: Int, column: Int, piece: ChessPiece) {
        self.row = row
        self.column = column
        self.piece = piece
        super.init(frame: .zero)
        setupViews()
        
        pieceLabel.text = piece.symbol
        pieceLabel.textColor = piece.color
    }
    
    func setupViews() {
        addSubview(invisibleButton)
        invisibleButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        invisibleButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        invisibleButton.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        invisibleButton.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
        
        addSubview(pieceLabel)
        pieceLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        pieceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        pieceLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        pieceLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
    }
    
    func selectedCell(sender: UIButton) {
        print("Selected cell at: \(row), \(column)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
