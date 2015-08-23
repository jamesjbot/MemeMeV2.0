//
//  TopTextFieldDelegate.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 8/21/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate : NSObject, UITextFieldDelegate {

    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("Toptextfielddelegate called")
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        println("<---------------TopTextFieldDelegate Textfieldshouldbeginediting called with tag \(textField.tag)")
/**        if textField.tag == 1 {
            utilizekeyboard = false
        } else {
            utilizekeyboard = true
        } **/
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //topTextField.text = ""
        println("Textfield did begin editting entered")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //This is a good place to save text data
        println("Textfield did End editting entered on textfield \(textField.tag)")
 //       viewWillDisappear(true)
        
    }
}