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

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flix"
        navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getMovies(_:firstLoad:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getMovies(refreshControl, firstLoad: true)

        // Do any additional setup after loading the view.
    }
    
    func getMovies(refreshControl: UIRefreshControl, firstLoad: Bool) {
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
                        print("response: \(responseDictionary)")
                                                                                
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
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath )
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWithURL(imageUrl!)
        
        
        print("row \(indexPath.row)")
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
