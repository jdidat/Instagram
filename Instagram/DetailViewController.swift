//
//  DetailViewController.swift
//  Instagram
//
//  Created by Jackson Didat on 2/8/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {

    var post: PFObject?
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var postPicture: UIImageView!
    @IBOutlet weak var caption: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            if let user = post["user"] as? PFUser {
                username.text = user.username
            } else {
                username.text = "🤖"
            }
            
            if let comment = post["comment"] as? String {
                caption.text = comment
            }
            
            if let imageFile = post["photo"] as? PFFile {
                imageFile.getDataInBackground(block: {
                    (imageData: Data!, error: Error!) -> Void in
                    if (error == nil) {
                        let image = UIImage(data: imageData)
                        self.postPicture.image = image
                    }
                })
            }
            
            if let timestamp = post["date"] as? String{
                date.text = timestamp
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
