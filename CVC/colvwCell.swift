//
//  colvwCell.swift
//  CVC
//
//  Created by Vora, Chintan on 1/20/17.
//  Copyright © 2017 Vora, Chintan. All rights reserved.
//

import UIKit

class colvwCell: UICollectionViewCell {
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    
    var imageArray: [UIImage?] = []{
        didSet{
            print("~~~~~~~~")
        }
    }
    
    
    
    
}
