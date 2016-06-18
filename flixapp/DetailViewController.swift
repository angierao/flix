//
//  DetailViewController.swift
//  flixapp
//
//  Created by Angeline Rao on 6/16/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    var genres: [NSDictionary]?
    var moviesG: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        titleLabel.text = title
        self.title = title
        
        let date = movie["release_date"] as? String
        dateLabel.text = date
        
        let backdropPath = movie["backdrop_path"] as? String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let backdropUrl = NSURL(string: baseUrl + backdropPath!)
        backdropView.setImageWithURL(backdropUrl!)
        
        let posterPath = movie["poster_path"] as! String
        let posterUrl = NSURL(string: baseUrl + posterPath)
        coverView.setImageWithURL(posterUrl!)
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        let apiKeyG = "d1c647e254e62ab5d6f57a3a3a112777"
        let urlG = NSURL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKeyG)")
        let request = NSURLRequest(
            URL: urlG!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    self.moviesG = responseDictionary["genres"] as? [NSDictionary]
                    
                    var genreString: String = ""
                    let movieGenres = self.movie["genre_ids"] as? [Int]
                    for movieGenre in movieGenres! {
                        for genre in self.moviesG! {
                            if (genre["id"] as! Int) == movieGenre {
                                genreString = genreString + (genre["name"] as! String) + ", "
                            }
                        }
                    }
                    genreString = String(genreString.characters.dropLast(2))
                    self.genreLabel.text = genreString
                }
                print(self.moviesG!.count)
            }
            //refreshControl.endRefreshing()
        })
        task.resume()
        /*
       
 */

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
