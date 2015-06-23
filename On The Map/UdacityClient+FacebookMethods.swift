//
//  UdacityClient+FacebookMethods.swift
//  On The Map
//
//  Created by Suthananth Arulanantham on 17.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//
import FBSDKLoginKit

/*
    This extension of the Udacity client handles the facebook login and logout methods
*/
extension UdacityClient {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            // TODO: handle error
            println("error:\(error.localizedDescription)")
        }
        else if result.isCancelled {
            // TODO: handle login cancelled
            println("login cancelled")
        }
        else{
            if result.grantedPermissions.contains("email"){
                println("logged in")
                let httpRequest:[String:[String:String]] = ["facebook_mobile":["access_token":FBSDKAccessToken.currentAccessToken().tokenString]]
                self.postingASession(httpRequest)
                
            }
        }
    }
    
    // whent the logout button is pressed
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("user logged out")
    }
}
