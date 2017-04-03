//
//  ViewController.swift
//  Flicks
//
//  Created by Balaji Tummala on 3/29/17.
//  Copyright © 2017 Balaji Tummala. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movieDict:[NSDictionary]?
    var filteredData:[NSDictionary]?
    var endPoint: String!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        
        errorImage.image = UIImage(named: "error")
        //let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        if(endPoint == "top_rated"){
            url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        self.movieDict = responseDictionary["results"] as! [NSDictionary]
                        self.filteredData = responseDictionary["results"] as! [NSDictionary]
                        //print(movieDict)
                        self.tableView.reloadData()
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                } else {
                    self.errorView.isHidden = false
                }
        });
        task.resume()

     //   networkRequest(refreshControl)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at:0)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movieDict {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! CustomCell
        let movie = movieDict![indexPath.row]
       // print(movie["title"] as! String)
        let baseURL = "https://image.tmdb.org/t/p/original"
        if let posterPath = movie["poster_path"] as? String {
            let ImageUrl = URL(string: baseURL + posterPath)
            let imageRequest = NSURLRequest(url: ImageUrl!)
            
            //cell.moviePosterView.setImageWith(ImageUrl!)
            cell.moviePosterView.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.moviePosterView.alpha = 0.0
                    cell.moviePosterView.image = image
                    UIView.animate(withDuration: 0.4, animations: { () -> Void in
                        cell.moviePosterView.alpha = 1.0
                    })
                } else {
                    cell.moviePosterView.image = image
                }}, failure: {(imageRequest, imageResponse, image) -> Void in})
        }
        
        cell.movieTitle.text = movie["title"] as! String
        cell.overview.text = movie["overview"] as! String
        
        
        //cell.textLabel?.text = movie["title"] as! String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender! as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movieDict![(indexPath?.row)!]
        
        let detailsViewController = segue.destination as! DetailsViewController
        detailsViewController.movie = movie
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        var url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        if(endPoint == "top_rated"){
            url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
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
                } else {
                    self.errorView.isHidden = false
                }
                refreshControl.endRefreshing()
        });
        task.resume()

    }
    
    func networkRequest (_ refreshControl: UIRefreshControl)  {
        var url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        if(endPoint == "top_rated"){
            url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }
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
                } else {
                    self.errorView.isHidden = false
                }
                refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      //  var filtered = searchText.isEmpty ? self.movieDict : self.movieDict?.filter { (($0["title"] as! String).lowercased().range(of: searchText) != nil) }
        
       // var namePredicate = NSPredicate(format: "title like %@",  String(searchText));
        let searchPredicate = NSPredicate(format: "title CONTAINS[C] %@", searchText)
        self.movieDict = self.movieDict?.filter { searchPredicate.evaluate(with: $0) };
        if searchText == "" {
            self.movieDict = self.filteredData
        }
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.movieDict = self.filteredData
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
}

