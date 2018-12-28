//
//  homeVC.swift
//  Instragram
//
//  Created by Sukho Lim on 08/12/2018.
//  Copyright © 2018 Sukho Lim. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {
    //refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 10
    
    //arrays to hold server information
    var uuidArray = [String]()
    var picArray = [PFFileObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        //background color
        collectionView?.backgroundColor = .white
        //title at the top
        self.navigationItem.title = PFUser.current()?.username
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC.refresh), for: UIControl.Event.valueChanged)
        collectionView?.addSubview(refresher)
        
        // receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(homeVC.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        
        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: #selector(homeVC.uploaded(_:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        // load posts func
        loadPosts()
    }
    
    //refreshing func
    @objc func refresh() {
        
        //reload data information
        collectionView?.reloadData()
        
        //stop refresher animating
        refresher.endRefreshing()
    }
    
    // reloading func after received notification
    @objc func reload(_ notification:Notification) {
        collectionView?.reloadData()
    }
    
    // reloading func with posts after received notification
    @objc func uploaded(_ notification:Notification) {
        loadPosts()
    }
    
    func loadPosts() {
        //request information from server
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                // find objects related to our request
                for object in objects! {
                    
                    // add found data to arrays (holders)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                }
                
                self.collectionView?.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    //cell numb
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        // STEP 1. Get user data
        // get users data with connections to collumns of PFuser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFileObject
        avaQuery.getDataInBackground { (data, error) -> Void in
            header.avaImg.image = UIImage(data: data!)
        }
        header.button.setTitle("edit profile", for: UIControl.State())
        
        // STEP 2. Count Statistics
        // count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground(block: { (count, error) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        })

        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        followers.countObjectsInBackground(block: { (count, error) -> Void in
            if error == nil {
                header.followers.text = "\(count)"
            }
        })

        // count total followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: PFUser.current()!.username!)
        followings.countObjectsInBackground (block: { (count, error) -> Void in
            if error == nil {
                header.following.text = "\(count)"
            }
        })
        
//        // tap followings
//        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingsTap))
//        followingsTap.numberOfTapsRequired = 1
//        header.followings.isUserInteractionEnabled = true
//        header.followings.addGestureRecognizer(followingsTap)
        
        //STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingsTap))
        followingsTap.numberOfTapsRequired = 1
        header.following.isUserInteractionEnabled = true
        header.following.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    // taped posts label
    @objc func postsTap() {
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionView.ScrollPosition.top, animated: true)
        }
    }
    
    // tapped followers label
    @objc func followersTap() {

        user = PFUser.current()!.username!
        category = "followers"

        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC

        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }

    // tapped followings label
    @objc func followingsTap() {

        user = PFUser.current()!.username!
        category = "followings"

        // make reference to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC

        // present
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    //clicked logout
    @IBAction func logout(_ sender: Any) {
        
        //implement log out
        PFUser.logOutInBackground { (error) -> Void in
            if error == nil {
                
                //remove logged in user from App memory
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
            }
        }
    }
    

/*
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        return cell
    }

 
    // MARK: UICollectionViewDelegate
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

