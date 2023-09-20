//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Jimmy Ghelani on 2023-09-19.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        cell.emailLabel.text = "j@j.com"
        cell.likeLabel.text = "0"
        cell.commentLabel.text = "Comment"
        cell.userImageView.image = UIImage(named: "taptoselect.png")
        return cell
    }

}

#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let controller = storyboard.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
    return controller
}
