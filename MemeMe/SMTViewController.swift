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
    var selection: IndexPath?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myreloadData()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the buttons for editExistingMeme and pullUpMemeEditor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SMTViewController.editExistingMeme))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(SMTViewController.pullUpMemeEditor))
        navigationItem.title = "Sent Memes"
        
        // Load global application data
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelgate = object as AppDelegate
        memes = appDelgate.memes

    }

    // MARK: - Edit existing meme code
    
    func editExistingMeme(){
        // Only edit if something is selected
        
        if let someindexrow = (tableView.indexPathForSelectedRow as IndexPath?)?.row {
            let evc = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
            evc.myMeme = memes[someindexrow]
            present(evc, animated: true, completion: nil)
        }
    }
    
    
    
    func pullUpMemeEditor(){
        let evc = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        present(evc, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Table View Data Source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeCell") as UITableViewCell?
        let meme : Meme = memes[(indexPath as NSIndexPath).row]
        // Setting the cell properties
        // Set the name and image
        cell!.textLabel?.text = "\(meme.topString) ... \(meme.bottomString)"
        let imageView = UIImageView(image: meme.memedImage)
        cell!.imageView?.image = imageView.image
        return cell!
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // A Cell was selected call up the detail view of the cell or show the meme
        // Mark the TableViewCell
        tableView.selectRow(at: selection, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        
        // Save the user selection
        selection = indexPath
        
        // Bring up the detail view of the meme
        let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailController?.myMeme = memes[(indexPath as NSIndexPath).row]
        detailController?.position = (indexPath as NSIndexPath).row
        navigationController!.pushViewController(detailController!, animated: true)
    }

    
    
    // Function to reload all data from global meme data
    func myreloadData() {
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        
        // Set the new memes so that tableView init will request a count that is accurate
        memes = appDelegate.memes
        
        // This function is called on the UIKit implementation of tableView since I deleted the IBOutlet to my localtable view
        // This will call the tableView init and cellatindexrow
        tableView.reloadData()
        
        // If memes exist, Set the current selection to whatever the user last picked
        let memeexist: Bool = memes.count > 0
        
        if memeexist {
            tableView.selectRow(at: selection, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
    }

    
    
    /**

        Deletion functions

    **/
    // MARK: - Deletion functions
    
    
    // Always allow editable rows
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Commit the delete function
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // Remove from local model
            memes.remove(at: (indexPath as NSIndexPath).row)
            
            // Remove from UI
            tableView.deleteRows(at: [indexPath], with:UITableViewRowAnimation.automatic)

            // Remove from global model
            let object = UIApplication.shared.delegate as! AppDelegate
            let appDelegate = object as AppDelegate
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.delete;
    }

}

