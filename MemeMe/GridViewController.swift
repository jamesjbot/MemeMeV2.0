//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 10/19/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import Foundation
import UIKit

class GridViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myreloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2*space))/3
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        // Set up the buttons for Edit and pullUpMemeEditor and description
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "pullUpMemeEditor")
        self.navigationItem.title = "Sent Memes"
        
        //Pull in the shared data model on initial loading
        
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
    }
    
    
    // Invoke the new meme editor
    func pullUpMemeEditor(){
        let evc = self.storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        self.presentViewController(evc, animated: true, completion: nil)
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let localmemes = memes {
            return localmemes.count
        } else {
            return 0
        }
        
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        return cell
    }
    
    
    
    // Bring up the Meme detail view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            myreloadData()
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
            detailController?.myMeme = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController!, animated: true)
            
    }
    
    
    
    // Reload data
    func myreloadData(){
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
}