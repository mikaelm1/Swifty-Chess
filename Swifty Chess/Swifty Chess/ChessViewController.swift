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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
        if (indexPath.item % 2 == 0 && indexPath.section % 2 == 0) || (indexPath.item % 2 != 0 && indexPath.section % 2 != 0) {
            cell.backgroundColor = UIColor(white: 0.8, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(white: 0.25, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item: \(indexPath.item) In Section: \(indexPath.section)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (view.frame.size.width - 20) / 8
        //print(dimension)
        return CGSize(width: dimension, height: dimension)
    }
    
}

class ChessCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

