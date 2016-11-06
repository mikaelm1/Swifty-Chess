//
//  ChessCell.swift
//  Swifty Chess
//
//  Created by Mikael Mukhsikaroyan on 10/31/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

// LEGACY: NOT ACTIVE 
import UIKit

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
    
    func setAsPossibleMoveLocation() {
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 2
    }
    
    func removeHighlighting() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
