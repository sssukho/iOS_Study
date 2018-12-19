//
//  resetPasswordVC.swift
//  Instragram
//
//  Created by Sukho Lim on 25/11/2018.
//  Copyright © 2018 Sukho Lim. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //alignment
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 20
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.size.width / 4, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        //tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signInVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    
    //hide keyboard function
    func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func resetBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty {
            
            //show alertt message
            let alert = UIAlertController(title: "Email field", message: "is empty", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // request for reseting password
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success, error) -> Void in
            if success {
                
                // show alert message
                let alert = UIAlertController(title: "Email for reseting password", message: "has been sent to texted email", preferredStyle: UIAlertController.Style.alert)
                
                // if pressed OK call self.dismiss.. function
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        //hide keyboard when pressed cancel.
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
