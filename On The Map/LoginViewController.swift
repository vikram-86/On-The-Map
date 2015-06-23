//
//  ViewController.swift
//  On The Map
//
//  Created by Suthananth Arulanantham on 16.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var login: FBSDKLoginButton?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var tapRecognizer : UITapGestureRecognizer? = nil
    var udacityClient : UdacityClient? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.udacityClient = UdacityClient(view: self.view)

        self.checkAccessToken()
        
    }
    // enable all the notifications and delegates on this viewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribetoKeyboardNotifications()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    // disable all the notifications on this viewController
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    // Check if facbookbook access token allready exists
    // otherwise make a facebook login button on the screen
    func checkAccessToken(){
        if FBSDKAccessToken.currentAccessToken() != nil{
            let httpRequest:[String:[String:String]] = ["facebook_mobile":["access_token":FBSDKAccessToken.currentAccessToken().tokenString]]
            self.udacityClient!.postingASession(httpRequest)
        }
        else{
            self.login?.delegate = self.udacityClient
            self.login?.readPermissions = ["public_profile","email","user_friends"]
        }
    }
    @IBAction func loginButtonTouched() {
        // TODO: handle Login 
        self.view.endEditing(true)
        if let (result,message) = self.checkTexfields(){
            if result == true {
                let httpBody = ["udacity":["username":"\(self.emailTextField.text)","password":"\(self.passwordTextField.text)"]]
                self.udacityClient!.postingASession(httpBody)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Checking if all fields are suplied, if user wishes to 
    // log in with Udacity credencials
    func checkTexfields() -> (result:Bool,message:String)?{
        var message = ""
        var result = false
        
        if self.emailTextField.text == "" && self.passwordTextField.text == "" {
            message = "Missing Email & Password"
            result = false
        }
        else if self.emailTextField.text == ""{
            message = "Missing Email"
            result = false
        }
        else if self.passwordTextField.text == ""{
            message = "Missing Password"
            result = false
        }
        else{
            message = "All field OK"
            result = true
        }
        
        return (result,message)
    }
    
    // Redirect user to Udacity's signup page
    // using safari, when user touches this button
    @IBAction func signupButtonTouced(sender: UIButton) {
        let URL = NSURL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.sharedApplication().openURL(URL)
    }
    
}

