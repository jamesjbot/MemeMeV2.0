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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        myreloadData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myreloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2*space))/3
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Set up the buttons for Edit and pullUpMemeEditor and description
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
            target: self,
            action: #selector(GridViewController.pullUpMemeEditor))
        navigationItem.title = "Sent Memes"
        
        //Pull in the shared data model on initial loading
        
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
    }
    
    
    // MARK: - Meme editor methods
    
    func pullUpMemeEditor(){
        let evc = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        present(evc, animated: true, completion: nil)
    }
    
    
    // MARK: - Data source methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let localmemes = memes {
            return localmemes.count
        } else {
            return 0
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        return cell
    }
    
    
    
    // Bring up the Meme detail view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            myreloadData()
            let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
            detailController?.myMeme = memes[(indexPath as NSIndexPath).row]
            detailController?.position = (indexPath as NSIndexPath).row
            navigationController!.pushViewController(detailController!, animated: true)
            
    }
    
    
    
    // Reload data
    func myreloadData(){
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    
}
