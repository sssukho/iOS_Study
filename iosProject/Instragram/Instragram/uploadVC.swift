//
//  uploadVC.swift
//  Instragram
//
//  Created by Sukho Lim on 28/12/2018.
//  Copyright © 2018 Sukho Lim. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UI Objects
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    //default func
    override func viewDidLoad() {
        super.viewDidLoad()

        //disable publish button
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        //hide remove button
        removeBtn.isHidden = true
        
        //standard UI containt
        picImg.image = UIImage(named: "pbg.png")
        
        //hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImg(_:)))
        picTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(picTap)
        
        //call alignment function
        alignment()
    }
    
    //hide keyboard function
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func selectImg(_ recognizer : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    //hold selected image in picImg object and dismiss PickerController()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //enable publish btn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1) //alpha 는 투명성
        
        // unhide remove button
        removeBtn.isHidden = false
        
        
        // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.zoomImg(_:)))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    @objc func zoomImg(_ recognizer : UITapGestureRecognizer) {
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x, width: self.view.frame.size.width, height: self.view.frame.size.width)
        let unzoomed = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.size.height + 35, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        //if picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            //with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                //resize image frame
                self.picImg.frame = zoomed
                
                //hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
            })
          // to unzoom
        } else {
            //with animation
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                // resize image frame
                self.picImg.frame = unzoomed
                
                //unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
            })
        }
    }
    
    //alignmnet
    func alignment() {
        let width = self.view.frame.size.width
        picImg.frame = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.size.height + 35, width: width / 4.5, height: width / 4.5)
        titleTxt.frame = CGRect(x: picImg.frame.size.width + 25, y: picImg.frame.origin.y, width: width - titleTxt.frame.origin.x - 10, height: picImg.frame.size.height)
        publishBtn.frame = CGRect(x: 0, y: self.tabBarController!.tabBar.frame.origin.y - width / 8, width: width, height: width / 8)
        removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.size.height + 10, width: picImg.frame.size.width, height: 20)
    }
    
    //clicked publish button
    @IBAction func publishBtn_clicked(_ sender: Any) {
        // dismiss keyboard
        self.view.endEditing(true)
        
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()!.username
        object["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFileObject
        object["uuid"] = "\(PFUser.current()!.username) \(NSUUID().uuidString)"
        
        if titleTxt.text.isEmpty {
            object["title"] = ""
        } else {
            object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        //send pic too server after converting to FILE and comprassion
        let imageData = picImg.image!.jpegData(compressionQuality: 0.5)
        let imageFile = PFFileObject(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        //finally save information
        object.saveInBackground(block: {(success, error) -> Void in
            if error == nil {
                
                //send notification with name "uploaded"
                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
                
                //switch to another ViewController at 0 index of tabbar
                self.tabBarController!.selectedIndex = 0
                
                // reset everything
                self.viewDidLoad()
                self.titleTxt.text = ""
            }
        })
    }
    
    //clicked remove button
    @IBAction func removeBtn_clicked(_ sender: Any) {
        self.viewDidLoad()
    }
}
