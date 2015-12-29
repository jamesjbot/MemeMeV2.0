//
//  ViewController.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 7/26/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
    
    var currentTextField: UITextField!
    
    let BOTTOMTEXTFIELDID = 2
    
    var myMeme: Meme?
    
    var scaledTransform: CGAffineTransform?
    
    var centerPoint: CGPoint?
    
    // Setting Font Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 36)!,
        NSStrokeWidthAttributeName : -5.0 //TODO: Fill in appropriate Float
    ]
    
    
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

    @IBAction func movedown(sender: AnyObject) {
        print("the transform is",CGAffineTransformIsIdentity(imagePickerView.transform))
        //imagePickerView.transform = CGAffineTransformIdentity
                print("the transform is",CGAffineTransformIsIdentity(imagePickerView.transform))
            //imagePickerView.center.y = imagePickerView.center.y + 50
        //view.frame.origin.y = view.frame.origin.y + 50
            //imagePickerView.autoresizingMask = UIViewAutoresizing.None
        print("imageviewautoresizingmask",imagePickerView.autoresizingMask.rawValue)
// looks like i have to save the scaling and translation factors and then reapply them to the center
    }
    
    
    @IBAction func moveup(sender: AnyObject) {
        imagePickerView.center.y = imagePickerView.center.y - 50
        //view.frame.origin.y = view.frame.origin.y - 50
    }
    
    @IBAction func moveleft(sender: AnyObject) {
            imagePickerView.center.x = imagePickerView.center.x - 50
    }
    
    @IBAction func moveright(sender: AnyObject) {
                imagePickerView.center.x = imagePickerView.center.x + 50
    }
    
    @IBAction func imageViewLocation(sender: AnyObject) {
        print("Center Coordinates",imagePickerView.center)
        print("Origin Coordinates",imagePickerView.frame.origin)
        print("Frame Size",imagePickerView.frame.width,"x",imagePickerView.frame.height)
        print("View Bounds(size)",imagePickerView.bounds)
        print("Transform ",imagePickerView.transform)
        print(" ")
        
        //Save the transform before it moves
        //Set back to identify
        //Move the UIImageView
        //Reset the original scale transform
        
        
        
    }

    /**
    
    override func viewWillLayoutSubviews() {
        print("view will layout subview")
                imageViewLocation(self)
        //viewWillLayoutSubviews()
                imageViewLocation(self)
        print("exiting view will layout subviews\n")
    }
    
    override func viewDidLayoutSubviews() {
        
        print("view did layout subviews keyboard height",myKeyboardHeight,"position",centerPoint)
                imageViewLocation(self)
        //viewDidLayoutSubviews()
        //imagePickerView.center = CGPointMake(centerPoint!.x,centerPoint!.y - myKeyboardHeight)
                imageViewLocation(self)
        print("exiting view did layout subview\n")
    }
    
    **/
    
    /**

    
        Starting to load main ViewController and initializations

    
    **/
    
    override func viewWillAppear(animated: Bool) {
        print("Viewwillappear")
        super.viewWillAppear(animated)
        subscribeToKeyboardShowNotifications()

    }

    
    
    override func viewWillDisappear(animated: Bool) {
        print("viewwilldisappear")
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        
        view.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        self.view.autoresizesSubviews = false
        //centerPoint = imagePickerView.center
        imagePickerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        
        // Assign delegates to top and bottom textfield
        topTextField.delegate = self
        bottomTextField.delegate = self
    
        
        // Assign a delegate to imagePicker
        imagePicker.delegate = self
        
        
        // Clear screen and initialize text attributes
        initializeSurface()
        // If we are loading from a previous made Meme; populate the premade values
        if myMeme != nil {
            topTextField.text = myMeme?.topString
            bottomTextField.text = myMeme?.bottomString
            imagePickerView.image = myMeme?.originalimage
        }
    }
    
    
    
    /// Resets the imageview, top and bottom textfield to their default values
    func initializeSurface(){
        
        
        
        // Load messages for initial textfields
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        
        initializeTextFields(topTextField)
        initializeTextFields(bottomTextField)
        
        
        // Set Image to nothing
        imagePickerView.image = nil
        
        
        // Setting Camera button state depending on hardware available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func initializeTextFields(editingTextField: UITextField){
        // Apply fonts to textfields
        editingTextField.defaultTextAttributes = memeTextAttributes
        
        // Center align text (this must go after textAttributes are set otherwse it will not center text)
        editingTextField.textAlignment = NSTextAlignment.Center
        
        // Settextfields FontSize to Adjust automatically depending on length of string
        editingTextField.adjustsFontSizeToFitWidth = true
        
        // Set textfields to always capitalize
        editingTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }

    

    /**  

    
        UIButton Actions

    
    **/
    /// The target of the Share Action button; will bring up the ActivityViewController to share the memedimage
    @IBAction func share(){
        // Generate a memed image
        // Create a local variable for instantian of a UIImage
        let image = generateMemedImage()
        
        
        // Define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        // Instantiate a UIActivityViewController object with the UIImage as a parameter
        let controller = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        
    
        // Present the ActivityViewController
        presentViewController(controller, animated: true, completion: nil)
        
        
        // Assign the function that should run when ActivityViewController completes
        controller.completionWithItemsHandler = {
            
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            // testing add block for ok
            self.save()
            
        }
        
    }
    
    
    
    /// The target of the Cancel Button; reinitializes the base page
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    
    
    /**
    
    
        Loading Images from Album or Camera
    
    
    **/
    /// Selects an Image from the photo album
    @IBAction func pickAnImage(sender: AnyObject) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    /// Selects an Image from the camera
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    /** 
    
    
        UIImagePickerControllerDelegate Methods
    
    
    **/
    /// Present the new UIImage in the imageview
    func imagePickerController(picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
            // Verify that the image is a UIImage; if it is then show it
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                imagePickerView.image = image
                imagePickerView.frame.size.height = 548
                imagePickerView.frame.size.width = 320
                imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
                

                
                // Now that we have an image available; allow sharebutton
                shareButton.enabled = true
            }
            
            
            // Dismiss the ImagePicker ViewController.
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Dismiss the ImagePicker ViewController because the user cancelled the ImagePicker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    /**
    
    
        UITextField delegate methods
    
    
    **/
    

    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        print("\nTextfieldshouldbeginediting")
        imagePickerView.autoresizingMask = UIViewAutoresizing.None

        
        currentTextFieldBeingEdited = textField.tag
        
        currentTextField = textField
        
        // Sign up for keyboardWillHide notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        
        // Always fix the font of the textfield as sometimes it defaults out.
        initializeTextFields(currentTextField)
        
        print("Exiting textfield should begin editing")
        
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
    /// Generates a keyboard height for the bottom textfield, generates 0 for top textfield
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        // Only save a keyboard height offset when the bottom textfield calls for a keyboard; 
        // (this function is guaranteed to happen AFTER textFieldShouldBeginEditing function is called)
        if (currentTextField.tag == BOTTOMTEXTFIELDID) { // The bottomTextField is calling for a keyboard
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue// of CGRect
            return keyboardSize.CGRectValue().height
        } else { // The topTextField is calling for a keyboard
            return 0.0
        }
    }
    
    
    
    /// Moves the view up prior to presenting keyboard
    func keyboardWillShow(notification: NSNotification){
        imagePickerView.autoresizingMask = UIViewAutoresizing.None

        print("keyboard will show")
        imageViewLocation(self)
        imagePickerView.autoresizingMask = UIViewAutoresizing.None
        // Save the current scaled trasnformation
        scaledTransform = imagePickerView.transform
        
        // Save the current centerPoint
        centerPoint = imagePickerView.center

        // Set transform back to identity
        //imagePickerView.transform = CGAffineTransformIdentity
        //print("I should be identity now")
        imageViewLocation(self)
        
        // Get height of keyboard and save it globally
        myKeyboardHeight = getKeyboardHeight(notification)
        
        // Move the whole UIView up by the keyboard amount
        //view.frame.origin.y -= myKeyboardHeight
        //topTextField.transform = CGAffineTransformMakeTranslation(0, -myKeyboardHeight)
        if myKeyboardHeight != 0 {
            bottomTextField.transform = CGAffineTransformMakeTranslation(0,-myKeyboardHeight)
            print(imagePickerView.transform)
            scaledTransform = imagePickerView.transform
            imagePickerView.transform = CGAffineTransformConcat(imagePickerView.transform,CGAffineTransformMakeTranslation(0, -myKeyboardHeight))
            print(imagePickerView.transform)
        }
        // Stop responding to keyboard will SHOW notificaions
        unsubscribeFromKeyboardShowNotifications()
        
        // Begin to respond to keyboard will HIDE notifications
        subscribeToKeyboardHideNotifications()
        
        
        // Rescale Image
        //imagePickerView.transform = scaledTransform!
        //print("setting ui centerpoint to be ",CGPointMake(centerPoint!.x,centerPoint!.y - myKeyboardHeight))
        //imagePickerView.center = CGPointMake(centerPoint!.x,centerPoint!.y - myKeyboardHeight)
        
        imageViewLocation(self)
        print("exiting keyboardwillshow\n")
    }
    
    
    /// Moves the view down when the keyboard is dismissed
    func keyboardWillHide(notification: NSNotification){
        imagePickerView.autoresizingMask = UIViewAutoresizing.None

        /// Move the whole UIView down by the keyboard amount
        //view.frame.origin.y = 0.0
        print("Moving down by keyboard height ", myKeyboardHeight)
        //topTextField.transform = CGAffineTransformMakeTranslation(0, myKeyboardHeight)
        if myKeyboardHeight != 0 {
            //topTextField.transform = CGAffineTransformMakeTranslation(0, myKeyboardHeight)
            bottomTextField.transform = CGAffineTransformMakeTranslation(0, 0)
        print(imagePickerView.transform)
        imagePickerView.transform = scaledTransform!
            print(imagePickerView.transform)
        }
        imagePickerView.center = centerPoint!
        unsubscribeFromKeyboardHideNotifications()
        subscribeToKeyboardShowNotifications()
    }
    
    
    /// Subscribes to the notification center for keyboard appearances
    func subscribeToKeyboardShowNotifications(){
        // Notify this view controller when keyboard will show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    /// Subscribes to the notification center for keyboard disappearances
    func subscribeToKeyboardHideNotifications(){
        // Notify this viewcontroller when keyboard will hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    /// Unsubscribes to the notification center for keyboard appearnaces
    func unsubscribeFromKeyboardShowNotifications(){
        // Stop notifying this view controller when the keyboard will show
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    /// Unscubscribes to the notification center for keyboard disappearances
    func unsubscribeFromKeyboardHideNotifications(){
        // Stop notifying this view controller when the keyboard will hide
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
  
    
    
    

    
    /**


        Saving memes and memed image functions
    
    
    **/
    /// Creates the Meme struct
    func save(){
        let meme: Meme!
        if imagePickerView.image != nil { // Case: If we have an image selected
            
            meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalimage: imagePickerView.image!, memedImage: generateMemedImage())

            
        } else { // Case: where we want to save the text
            
            meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalimage: nil, memedImage: generateMemedImage())

        }
        
        // Add it to the memes array in the Application Delegate
        let tempAppDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        tempAppDel.memes.append(meme)

    }
    
    
    
    /// Creates a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navigation bar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)

        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar navbar
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
  
    
    
    /** 


        UI Gesturerecognizer functions

    **/

    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        let translationamount = recognizer.translationInView(view)
        
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translationamount.x,
                y:view.center.y + translationamount.y)
        }
        recognizer.setTranslation(CGPointZero, inView: view)
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let localview = recognizer.view {

            localview.transform = CGAffineTransformScale(localview.transform,
                recognizer.scale, recognizer.scale)
            recognizer.scale = 1

        }
        recognizer.view?.center = view.center // Reposition the center of the image otherwise sometimes it will be off the screen unrecoverable
    }
    
    
    
} // End of ViewController Class


