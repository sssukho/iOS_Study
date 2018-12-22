//
//  pictureCell.swift
//  Instragram
//
//  Created by Sukho Lim on 08/12/2018.
//  Copyright © 2018 Sukho Lim. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    @IBOutlet weak var picImg: UIImageView!
    
    //default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //alignment
        let width = UIScreen.main.bounds.width
        
        picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
    }
}
