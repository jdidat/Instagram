//
//  PostViewController.swift
//  Instagram
//
//  Created by Jackson Didat on 2/8/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var caption: UITextView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let phoneImage = UIImagePickerController()
    
    @IBAction func selectImage(_ sender: Any) {
        phoneImage.delegate = self
        phoneImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        phoneImage.allowsEditing = false
        self.present(phoneImage, animated: true)
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(self.image.image!)
        let imageFile = PFFile(name: "Picture", data: imageData!)
        let post = PFObject(className: "Post")
        post["user"] = PFUser.current()
        post["photo"] = imageFile
        post["comment"] = caption.text
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM.dd.yyyy"
        let result = format.string(from: date)
        
        post["date"] = result
        
        post.saveInBackground { (success, error) in
            if success {
                print("Post was saved!")
            } else {
                print(error)
                print("Post could not be saved :(")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        caption.layer.borderWidth = 1
        caption.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = image
        } else {
            print("error getting image")
        }
        
        self.dismiss(animated: true, completion: nil)
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
