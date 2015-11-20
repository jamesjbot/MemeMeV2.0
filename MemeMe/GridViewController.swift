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
        print("GridViewController viewDidAppear called")
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("GridViewController viewWillAppear called")
        //let object = UIApplication.sharedApplication().delegate as! AppDelegate
        //let appDelegate = object as AppDelegate
        //memes = appDelegate.memes
        myreloadData()
    }
    
    override func viewDidLoad() {
        print("---------------------------<<<<<<<<<<<<<<<<GridViewController called viewDidLoad")
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2*space))/3
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        // The buttons for Edit and pullUpMemeEditor and description
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "pullUpMemeEditor")
        self.navigationItem.title = "Sent Memes"
        
        //Pull in the shared data model on initial loading
        
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
    }
    
    func pullUpMemeEditor(){
        /*let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        detailController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        */
        let evc = self.storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        //Try to dismiss myself before presenting the new viewcontroller
        //Presenting by pushing onto navigation controller comes over from right
        //self.navigationController!.pushViewController(evc, animated: true)
        self.presentViewController(evc, animated: true, completion: nil)
        //self.presentViewController(ViewController(), animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let object = UIApplication.sharedApplication().delegate as! AppDelegate
        //let appDelegate = object as AppDelegate
        //memes = appDelegate.memes
        //myreloadData()
        if let localmemes = memes { // If casting, use, eg, if let var = abc as? NSString
            // variableName will be abc, unwrapped
            print("memes is populated \(localmemes.count)")
            return localmemes.count
        } else {
            // abc is nil
            return 0
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        //cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
            /*
            //Grab the DetailVC from Storyboard
            let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailVC")
            let detailVC = object as! VillainDetailViewController
            
            //Populate view controller with data from the selected item
            detailController.villain = self.allVillains[indexPath.row]
            
            //Present the view controller using navigation
            self.navigationController!.pushViewController(detailController, animated: true)
            */
            
    }
    
    func myreloadData(){
        print("GridViewController function reloadData() Attempting to reload Data")
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
        //println("----------->SMT Line 100 Of interest appDelegate has this many memes \(appDelegate.memes.count)")
        //tableView.reloadData()
        //println("the description for reloaded tableview is \(tableView.description)")
        //println("SMTViewController TableData told to be Reloaded, not sure if it did.")
        //println("Visible cells \(tableView.visibleCells())")
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
}