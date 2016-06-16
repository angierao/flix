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
    var photoUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        let title = movie["title"] as? String
        titleLabel.text = title
        
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
