//
//  RentalDetailViewController.swift
//  flixapp
//
//  Created by Angeline Rao on 6/17/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class RentalDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    @IBOutlet weak var ratingLabel: UILabel!
    var rental: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = rental["title"] as? String
        titleLabel.text = title
        self.title = title
        
        let date = rental["release_dates"] as? NSDictionary
        let dvdDate = date!["dvd"] as? String
        dateLabel.text = "Released on DVD: " + dvdDate!
        
        let rating = rental["mpaa_rating"] as? String
        ratingLabel.text = "Rated " + rating!
        
        var cast: String = ""
        let castMembers = rental["abridged_cast"] as? [NSDictionary]
        for castMember in castMembers! {
            cast = cast + (castMember["name"] as! String) + ", "
        }
        castLabel.text = String(cast.characters.dropLast(2))
        
        let synopsis = rental["synopsis"] as? String
        synopsisLabel.text = synopsis
        
        let posterPaths = rental["posters"] as! NSDictionary
        let posterPath = posterPaths["detailed"] as! String
        let imageUrl = NSURL(string: posterPath)
        imageView.setImageWithURL(imageUrl!)
        
        

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
