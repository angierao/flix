//
//  MovieViewController.swift
//  flixapp
//
//  Created by Angeline Rao on 6/15/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    var filteredData: [NSDictionary]?
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        filteredData = movies
        
        self.title = "Movies"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getMovies(_:firstLoad:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getMovies(refreshControl, firstLoad: true)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    
        //searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["All", "This Week", "This Month"]
        searchController.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    func getDate() -> [Int]{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        return [day, month, year]
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
                var dateMatch = false
                
                if scope == "This Month" {
                    let yearmonth: String = String((movie["release_date"] as? String)!.characters.dropLast(3))
                    let month = String(yearmonth.characters.suffix(2))
                    if Int(month) == getDate()[1] {
                        dateMatch = true
                    }
                }
                else if scope == "This Week" {
                        let dayString = String((movie["release_date"] as! String).characters.suffix(2))
                    if (Int(dayString)! - getDate()[0]) < 8 {
                        dateMatch = true
                    }
                }
                return (dateMatch || scope == "All") && (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            self.tableView.reloadData()
        }

    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func getMovies(refreshControl: UIRefreshControl, firstLoad: Bool) {
        
        let apiKey = "d1c647e254e62ab5d6f57a3a3a112777"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        if firstLoad {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                }
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
         refreshControl.endRefreshing()
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredData!.count
        }
        else if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie: NSDictionary
        
        if searchController.active && searchController.searchBar.text != "" {
            movie = filteredData![indexPath.row]
        }
        else {
            movie = movies![indexPath.row]
        }
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        let imageRequest = NSURLRequest(URL: imageUrl!)

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURLRequest(imageRequest, placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: {() -> Void in cell.posterView.alpha = 1.0})
                }
                else {
                    cell.posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                print("failure")
        })
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell!
        let indexPath = tableView.indexPathForCell(cell)
        
        let movie: NSDictionary
        if searchController.active && searchController.searchBar.text != "" {
            movie = filteredData![indexPath!.row]
        } else {
            movie = movies![indexPath!.row]
        }
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

