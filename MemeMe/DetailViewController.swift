//
//  DetailViewController.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 11/19/15.
//  Copyright © 2015 James Jongs. All rights reserved.
//

import Foundation
import UIKit


class DetailViewController: UIViewController{



    @IBOutlet weak var detailImageView: UIImageView!

    var myMeme: Meme!
    
    
    // Function needed to correctly fill this screen with image
    override func viewWillAppear(animate: Bool){
        
        detailImageView.contentMode = UIViewContentMode.ScaleAspectFill
        detailImageView.image = myMeme.memedImage

    }

}