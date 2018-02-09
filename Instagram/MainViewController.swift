//
//  MainViewController.swift
//  Instagram
//
//  Created by Jackson Didat on 2/7/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    var refresh: UIRefreshControl!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        if let user = post["user"] as? PFUser {
            cell.username.text = user.username
        } else {
            cell.username.text = "🤖"
        }
        cell.postImage.image = nil
        cell.tag = indexPath.row
        if let imageFile = post["photo"] as? PFFile {
            imageFile.getDataInBackground(block: {
                (imageData: Data!, error: Error!) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData)
                    if cell.tag == indexPath.row {
                        DispatchQueue.main.async {
                            cell.postImage.image = image
                        }
                    }
                }
            })
        }
        
        if let comment = post["comment"] as? String {
            cell.caption.text = comment
        }
        
        if let time = post["date"] as? String {
            cell.date.text = time
        }
        
        return cell
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        present(viewController!, animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: Any) {
        self.performSegue(withIdentifier: "uploadSegue", sender: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let logo = UIImage(named: "Instagram_logo_2.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        imageView.center = (navigationController?.navigationBar.center)!
        imageView.contentMode = .scaleAspectFit
        //imageView.contentMode = .asp
        imageView.image = logo
        
        self.navigationItem.titleView = imageView
        tableView.delegate = self
        tableView.dataSource = self
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(MainViewController.fetchPosts), for: .valueChanged)
        tableView.insertSubview(refresh, at: 0)
        fetchPosts()
    }
    
    @objc func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.limit = 20
        query.findObjectsInBackground(block:  { (posts, error) in
            if error != nil {
            print(error?.localizedDescription)
                self.refresh.endRefreshing()
            } else if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                let dvc = segue.destination as! DetailViewController
                dvc.post = post
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
