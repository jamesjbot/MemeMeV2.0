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
        
        detailImageView.contentMode = UIViewContentMode.ScaleAspectFit
        detailImageView.image = myMeme.memedImage

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the buttons for editExistingMeme and pullUpMemeEditor
        
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "editExistingMeme")
    }
    
    
    func editExistingMeme(){
            let evc = storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
            evc.myMeme = myMeme!
            presentViewController(evc, animated: true, completion: nil)

    }
    

}