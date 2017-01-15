//
//  CollectionViewCell.swift
//  MemeMe
//
//  Created by Etjen Ymeraj on 9/21/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var memeCellImageView: UIImageView!

    var meme: Meme? { didSet{ updateUI() }}

    func updateUI() {
    guard let meme = meme else { return }
    memeCellImageView.image = meme.newimage
    }
}
