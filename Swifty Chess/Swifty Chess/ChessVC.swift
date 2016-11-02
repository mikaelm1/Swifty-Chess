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
        
        let boardContainer = UIView()
        boardContainer.translatesAutoresizingMaskIntoConstraints = false
        boardContainer.backgroundColor = .purple
        //view.addSubview(boardContainer)
        //boardContainer.topAnchor
        
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
        l.font = UIFont.systemFont(ofSize: 20)
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
