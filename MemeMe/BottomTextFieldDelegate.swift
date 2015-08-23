//
//  BottomTextFieldDelegate.swift
//  MemeMe
//
//  Created by James Jongsurasithiwat on 8/21/15.
//  Copyright (c) 2015 James Jongs. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("Bottomtextfielddelegate called")
        textField.resignFirstResponder()
        return true;
    }
    // Code to receive textField delegate methods


}