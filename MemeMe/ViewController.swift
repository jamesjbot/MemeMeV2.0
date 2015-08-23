//
//  ViewController.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 7/26/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var navbar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!

    let imagePicker:UIImagePickerController = UIImagePickerController()
    
    var myKeyboardHeight: CGFloat = 0.0
    
    var utilizekeyboard: Bool = false
    
    var currentTextFieldBeingEdited = 0
    
    /**
    Organization of code blocks

        Starting to load main ViewController and initializations functions
    
        UIButton Action functions
    
        Loading Images from Album or Camer functions
    
        UIImagePickerControllerDelegate functions
    
        UITextField delegate functions
    
        Keyboard elvating functions
    
        Saving memes and memed image functions
    **/


    
    
    
    
    
    
    /**

    
        Starting to load main ViewController and initializations

    
    **/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardShowNotifications()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Assign a delegates to top and bottom textfield
        topTextField.delegate = self
        bottomTextField.delegate = self
    
        
        // Assign a delegate to imagePicker
        imagePicker.delegate = self
        initializeSurface()
    }
    
    
    
    func initializeSurface(){
        // Configure initial share button
        shareButton.enabled = false
        
        
        // Load messages for initial textfields
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        
        // Center align text (this must go after text is set otherwise it will not center text
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        
        // Setting Font Attributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
            NSStrokeWidthAttributeName : -5.0 //TODO: Fill in appropriate Float
        ]
        
        
        // Apply fonts to textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        
        // Center align text (this must go after textAttributes are set otherwse it will not center text)
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        
        // Settextfields FontSize to Adjust automatically depending on length of string
        topTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.adjustsFontSizeToFitWidth = true
        
        
        // Set textfields to always capitalize
        topTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        
        // Set Image to nothing
        imagePickerView.image = nil
        
        
        // Setting Camera button state depending on hardware available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    

    

    /**  

    
        UIButton Actions

    
    **/
    
    // The Target of the Share Action button; will bring up the ActivityViewController to share the memedimage
    @IBAction func share(){
        // Generate a memed image
        // Create a local variable for instantian of a UIImage
        let image = generateMemedImage()
        
        
        // Define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        // Instantiate a UIActivityViewController object with the UIImage as a parameter
        let controller = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        
    
        // Present the ActivityViewController
        self.presentViewController(controller, animated: true, completion: nil)
        
        
        // Assign the function that should run when ActivityViewController completes
        controller.completionWithItemsHandler = {
            (activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    
    // The targe of the Cancel Button
    @IBAction func cancel(sender: AnyObject) {
        initializeSurface()
    }
    

    
    
    
    
    /**
    
    
        Loading Images from Album or Camera
    
    
    **/
    
    @IBAction func pickAnImage(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    /** 
    
    
        UIImagePickerControllerDelegate Methods
    
    
    **/
    
    func imagePickerController(picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            // Verify that the image is a UIImage; if it is then show it
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                imagePickerView.image = image
                imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
            
            // Now that we have an image available; allow sharebutton
            shareButton.enabled = true
            
            
            // Dismiss the ImagePicker ViewController.
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Dismiss the ImagePicker ViewController because the user cancelled the ImagePicker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    /**
    
    
        UITextField delegate methods
    
    
    **/
    
    func textField(textField: UITextField, shouldChangeCharactersInrange range: NSRange, replacemenString string: String) -> Bool {
        // Receive new text and replace text in textfield
        var newText: NSString = textField.text
        return true
    }
    

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Remember which textfield initiated the keyboard call
        currentTextFieldBeingEdited = textField.tag
        
        // Sign up for keyboardWillHide notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        return true
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // When return is hit on the keyboard, dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        // This is a good place to save text data in the future.
    }
    
    
    
    
    
    /** 
    
    
        Keyboard elvating functions
    
    
    **/
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        // Only save a keyboard height offset when the bottom textfield calls for a keyboard; 
        // (this function is guaranteed to happen AFTER textFieldShouldBeginEditing function is called)
        if (currentTextFieldBeingEdited == 2) { // The bottomTextField is calling for a keyboard
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue// of CGRect
            return keyboardSize.CGRectValue().height
        } else { // The topTextField is calling for a keyboard
            return 0.0
        }
    }
    
    
    
    func keyboardWillShow(notification: NSNotification){
        // Get height of keyboard and save it globally
        myKeyboardHeight = getKeyboardHeight(notification)
        
        // Move the whole UIView up by the keyboard amount
        self.view.frame.origin.y -= myKeyboardHeight
        
        // Stop responding to keyboard will SHOW notificaions
        unsubscribeFromKeyboardShowNotifications()
        
        // Begin to respond to keyboard will HIDE notifications
        subscribeToKeyboardHideNotifications()
    }
    
    
    
    func keyboardWillHide(notification: NSNotification){
        // Move the whole UIView down by the keyboard amount
        self.view.frame.origin.y += myKeyboardHeight
        unsubscribeFromKeyboardHideNotifications()
        subscribeToKeyboardShowNotifications()
    }
    
    
    
    func subscribeToKeyboardShowNotifications(){
        // Notify this view controller when keyboard will show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    
    func subscribeToKeyboardHideNotifications(){
        // Notify this viewcontroller when keyboard will hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    
    func unsubscribeFromKeyboardShowNotifications(){
        // Stop notifying this view controller when the keyboard will show
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    
    func unsubscribeFromKeyboardHideNotifications(){
        // Stop notifying this view controller when the keyboard will hide
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
  
    
    
    

    
    /**


        Saving memes and memed image functions
    
    
    **/
    
    func save(){
        //Create the meme
        var meme = Meme( topString: topTextField.text!, bottomString: bottomTextField.text!, iOriginalImage: imagePickerView.image!, iMemedImage: generateMemedImage()
        )
    }
    
    
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navigation bar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar navbar
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
  
    
} // End of ViewController Class







// The Meme class
class Meme {
    var topString: String
    var bottomString: String
    var originalimage: UIImage
    var memedImage: UIImage
    
    init(topString: String, bottomString: String, iOriginalImage: UIImage, iMemedImage: UIImage){
        self.topString = topString
        self.bottomString = bottomString
        self.originalimage = iOriginalImage
        self.memedImage = iMemedImage
    }
    
}

