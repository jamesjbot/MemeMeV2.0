//
//  SentMemesTableViewControoler.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 8/24/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import Foundation
import UIKit

class SMTViewController: UITableViewController {

    // Get ahold of some villains, for the table
    // This is an array of Villain instances
    //let allMemes = Villain.allVillains
    //var running: Int = 1
    
    // Shared data model for memes
    var memes: [Meme]!

    /*
    override func viewWillAppear(animated: Bool){
        println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SentMemesTableViewController called viewWillAppear")
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
*/
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SMTViewController viewDidAppear called")
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("SMTViewController viewWillDisappear called")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("SMTViewController viewDidAppear called")
    }
    
    
    override func viewDidLoad() {
        print("---------------------------<<<<<<<<<<<<<<<<SentMemesTableViewController called viewDidLoad")
        print("\(self.description)")
        super.viewDidLoad()
        
        // The buttons for Edit and pullUpMemeEditor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "pullUpMemeEditor")
        self.navigationItem.title = "Sent Memes"
        
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelgate = object as AppDelegate
        
        //test code; these three lines make a default for the meme
        //create a new meme and add it to the local file
        //println("Running is now before making a meme; if this is 1 then SMTViewController is being invoked as a new object \(running)")
        //var meme = Meme(top: "viewDidLoad",bot: "\(String(running))")
        //running = running + 1
        //println("Running is now \(running)")
        //let tempAppDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        //appDelgate.memes.append(meme)
    
        
        memes = appDelgate.memes
        //println("The tableview description here is \(tableView.description)")

        //println("sentmemestabaleviewcontroller thinks there are this many memes \(memes.count)")
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
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("SentMemesTableViewController numberOfRowsInSection Called the count is \(memes.count)")
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("SentMemesTableViewController cellForrowAtIndexPath called with index \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell") as UITableViewCell?
        let meme : Meme
        //if indexPath.row >= 1 {
        //    meme = memes[1]}
        //else {
            meme = memes[indexPath.row]
        //}
        //Setting the cell properties
        // Set the name and image
        print("Creating a new cell object with \(meme.topString) \(meme.bottomString)")
        cell!.textLabel?.text = "\(meme.topString) ... \(meme.bottomString)"
        let imageView = UIImageView(image: meme.memedImage)
        cell!.imageView?.image = imageView.image
        
        
        //cell.imageView?.image = UIImage(named: villain.imageName)
        
        // If the cell has a detail label, we will put the evil scheme in.
        //if let detailTextLabel = cell.detailTextLabel {
        //    detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        //}
        print("How many subviews are there \(self.view.subviews.count)")
        //self.view.subviews.
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Did select row at index path called \(indexPath.row)")
        // A Cell was selected call up the detail view of the cell or show the meme
        //let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("SMTViewController") as! SMTViewController
        //detailController. = self.memes[indexPath.row]
        //self.navigationController!.pushViewController(detailController, animated: true)
        myreloadData()
        print("Data reloaded")
    }

    func myreloadData(){
        print("SMTViewController function reloadData() Attempting to reload Data")
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        //println("----------->SMT Line 100 Of interest appDelegate has this many memes \(appDelegate.memes.count)")
        tableView.reloadData()
        //println("the description for reloaded tableview is \(tableView.description)")
        //println("SMTViewController TableData told to be Reloaded, not sure if it did.")
        //println("Visible cells \(tableView.visibleCells())")
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
}

