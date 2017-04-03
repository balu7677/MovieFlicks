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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateobj = dateFormatter.date(from: (movie["release_date"] as? String)!)
        print(dateobj)
        dateFormatter.dateStyle = .long
        let dateString = dateFormatter.string(from: dateobj!)
        dateLabel.text = dateString
        
        let ratingStr = movie["popularity"] as! NSNumber
        let rating: Int = Int(ratingStr)
        ratingLabel.text = "\(rating)"
        ratingLabel.text = ratingLabel.text?.appending("%")
        titleLabel.text = movie["title"] as! String
        overviewLabel.text = movie["overview"] as! String
        let largeBaseURL = "https://image.tmdb.org/t/p/original"
        let smallBaseURL = "https://image.tmdb.org/t/p/w45"
        if let posterPath = movie["poster_path"] as? String {
            let largeImageUrl = URL(string: largeBaseURL + posterPath)
            let smallImageUrl = URL(string: smallBaseURL + posterPath)
            let smallImageRequest = NSURLRequest(url: smallImageUrl!)
            let largeImageRequest = NSURLRequest(url: largeImageUrl!)
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            self.posterImageView.setImageWith(
                                largeImageRequest as URLRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.posterImageView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    
            })
            
        //posterImageView.setImageWith(ImageUrl!)
        }
        overviewLabel.sizeToFit()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: titleOverviewView.frame.size.height + overviewLabel.frame.size.height)
        
        //titleOverviewView.size
        // Do any additional setup after loading the view.
        let titleText = NSAttributedString(string: titleLabel.text!, attributes: [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8),
            ])
        navigationItem.title = titleLabel.text
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
