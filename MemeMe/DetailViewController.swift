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
    var position: Int!
    
    
    
    
    // Function needed to correctly fill this screen with image
    override func viewWillAppear(_ animate: Bool){
        
        detailImageView.contentMode = UIViewContentMode.scaleAspectFit
        detailImageView.image = myMeme.memedImage

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the buttons for editExistingMeme
        let fixedspace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedspace.width = 80.0
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain,
            target: self,action: #selector(DetailViewController.editExistingMeme)),
            fixedspace,
        UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.deleteExistingMeme))]

    }
    
    
    
    func editExistingMeme(){
            let evc = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
            evc.myMeme = myMeme!
            present(evc, animated: true, completion: nil)
    }
    
    func deleteExistingMeme(){
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        appDelegate.memes.remove(at: position)
        navigationController?.popToRootViewController(animated: true)
    
        
    
    }
}
