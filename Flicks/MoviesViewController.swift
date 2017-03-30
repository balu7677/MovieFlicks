//
//  ViewController.swift
//  Flicks
//
//  Created by Balaji Tummala on 3/29/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movieDict:[NSDictionary]?
    
    @IBOutlet weak var movieTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        //let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        self.movieDict = responseDictionary["results"] as! [NSDictionary]
                        //print(movieDict)
                        self.tableView.reloadData()
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        task.resume()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movieDict {
            return movies.count
        } else {
            print(0)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! CustomCell
        let movie = movieDict![indexPath.row]
       // print(movie["title"] as! String)
        let baseURL = "https://image.tmdb.org/t/p/w342"
        let posterPath = movie["poster_path"] as! String
        let ImageUrl = URL(string: baseURL + posterPath)
        cell.movieTitle.text = movie["title"] as! String
        cell.overview.text = movie["overview"] as! String
        cell.moviePosterView.setImageWith(ImageUrl!)
        
        //cell.textLabel?.text = movie["title"] as! String
        return cell
    }


}

