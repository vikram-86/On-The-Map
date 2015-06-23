//
//  LoginViewController+UIStubs.swift
//  On The Map
//
//  Created by Suthananth Arulanantham on 18.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//
import UIKit

/*Stubs for controlling UI Problems*/
extension LoginViewController {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // return the height of keyboard
    func getKeyboardHeight(notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // shift view back to normal when keyboard hides
    func keyboardWillHide(notificaion:NSNotification){
        self.view.superview?.frame.origin.y = 0
    }
    
    // shift view up a half when the keyboard shows
    func keyboardWillShow(notification:NSNotification){
        self.view.superview?.frame.origin.y = (0 - self.getKeyboardHeight(notification))/2.0
    }
    
    func subscribetoKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.addTapRecognizer()
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        self.removeTapRecognizer()
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func addTapRecognizer(){
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(self.tapRecognizer!)
    }
    
    func removeTapRecognizer(){
        self.view.removeGestureRecognizer(self.tapRecognizer!)
    }
}