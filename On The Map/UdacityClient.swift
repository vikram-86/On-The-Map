//
//  UdacityClient.swift
//  On The Map
//
//  Created by Suthananth Arulanantham on 17.06.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

// enums of message to display when acitivity screen is shown
enum ServerMessage:String{
    case Reconnect = "Please tap the screen to reconnect"
    case Retry = "Please tap the screen to retry"
    
    static let allValues = [Reconnect,Retry]
}

class UdacityClient:NSObject,FBSDKLoginButtonDelegate {
    
    typealias requestDictionary = [String:[String:String]]
    // creating a session either using facebook accesstoken or 
    // udacity credentials
    var view = UIView()
    var tapCaunter: Int = 0
    init(view:UIView) {
        super.init()
        self.view = view
        self.tapCaunter = 0
    }
    func postingASession(httpRequest: requestDictionary){
        self.view.userInteractionEnabled = false
        SwiftSpinner.show("Connecting\nto Udacity")
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var err : NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(httpRequest, options: nil, error: &err)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in

            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode{
                case 403:
                    let responseMessage = "Incorrect username/password"
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tapCaunter = 1
                        self.handleConnectionProblems(responseMessage, httpRequest: httpRequest)
                    })
                    return
                default:
                    println(httpResponse.statusCode)
                }
            }
            
            if error != nil  {
                let errorMessage = error.localizedDescription
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.handleConnectionProblems(errorMessage, httpRequest: httpRequest)
                })
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length-5))  // subset response data
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            SwiftSpinner.hide(completion: { () -> Void in
             self.view.userInteractionEnabled = true
            })
        })
        
        task.resume()
    }
    
    
    
    
    // function that handles any connection issues while log in session
    func handleConnectionProblems(message:String, httpRequest:requestDictionary){
        let retryMessage = ServerMessage.allValues[self.tapCaunter].rawValue
        switch self.tapCaunter{
        case 0:
            ++self.tapCaunter
            SwiftSpinner.show(message, animated: false).addTapHandler({ () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.postingASession(httpRequest)
                })
                }, subtitle: retryMessage)
        case 1:
            self.view.userInteractionEnabled = true
            SwiftSpinner.show(message, animated: false).addTapHandler({ () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.view.userInteractionEnabled = true
                    self.tapCaunter = 0
                    SwiftSpinner.hide(completion: { () -> Void in
                        
                    })
                })
                }, subtitle: retryMessage)
        default:
            return
        }
    }
}
