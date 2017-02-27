//
//  ViewController.swift
//  FingerprintTest
//
//  Created by Christoph Fuchs on 22/12/2016.
//  Copyright © 2016 mohemian. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginButtonClicked(sender: UIButton.init())
    }
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    self.navigateToAuthenticatedViewController()
                    
                } else {
                    // Check if there is an error
                    if let err = error {
                        print("ERROR! @%", err)
                        DispatchQueue.main.async {
                            self.debugLabel.textColor = UIColor.red
                            self.debugLabel.text = err.localizedDescription
                        }
                    }
                }
        })
    }
    
    func navigateToAuthenticatedViewController(){
        print("Logged in!")
        DispatchQueue.main.async {
            self.debugLabel.textColor = UIColor.green
            self.debugLabel.text = "Logged in!"
        }
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

