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

    
    // Shared data model for memes
    var memes: [Meme]! = []
    var selection: NSIndexPath?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the buttons for editExistingMeme and pullUpMemeEditor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editExistingMeme")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "pullUpMemeEditor")
        self.navigationItem.title = "Sent Memes"
        
        // Load global application data
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelgate = object as AppDelegate
        memes = appDelgate.memes

    }

    
    
    func editExistingMeme(){
        // Only edit if something is selected
        if let someindexrow = tableView.indexPathForSelectedRow?.row {
            let evc = self.storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
            evc.myMeme = memes[someindexrow]
            self.presentViewController(evc, animated: true, completion: nil)
        }
    }
    
    
    
    func pullUpMemeEditor(){
        let evc = self.storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        self.presentViewController(evc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: Table View Data Source
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell") as UITableViewCell?
        let meme : Meme = memes[indexPath.row]
        // Setting the cell properties
        // Set the name and image
        cell!.textLabel?.text = "\(meme.topString) ... \(meme.bottomString)"
        let imageView = UIImageView(image: meme.memedImage)
        cell!.imageView?.image = imageView.image
        return cell!
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // A Cell was selected call up the detail view of the cell or show the meme
        // Mark the TableViewCell
        tableView.selectRowAtIndexPath(selection, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        
        // Save the userselection
        selection = indexPath
        
        // Bring up the detail view of the meme
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
        detailController?.myMeme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController!, animated: true)
    }

    
    
    // Function to reload all data from global meme data
    func myreloadData(){
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
        // Set the current selection to whatever the user last picked
        tableView.selectRowAtIndexPath(selection, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
    }

    
    
    /**

        Deletion functions

    **/
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)

            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            let appDelegate = object as AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
        }
    }
    
    
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.Delete;
    }

}

