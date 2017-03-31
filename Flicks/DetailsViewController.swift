//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Balaji Tummala on 3/30/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleOverviewView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as! String
        overviewLabel.text = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
        let ImageUrl = URL(string: baseURL + posterPath)
        posterImageView.setImageWith(ImageUrl!)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: titleOverviewView.frame.size.height + 70)
        overviewLabel.sizeToFit()
        // Do any additional setup after loading the view.
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
