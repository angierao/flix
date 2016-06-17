//
//  RentalViewController.swift
//  flixapp
//
//  Created by Angeline Rao on 6/17/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class RentalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var rentals: [NSDictionary]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "Top Rentals"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getRentals(_:firstLoad:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getRentals(refreshControl, firstLoad: true)


        // Do any additional setup after loading the view.
    }
    
    func getRentals(refreshControl: UIRefreshControl, firstLoad: Bool) {
        
        let apiKey = "yz8aght3p6b47r22wmkyezan"
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=\(apiKey)")
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
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    self.rentals = responseDictionary["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                   }
                }
              MBProgressHUD.hideHUDForView(self.view, animated: true)
             refreshControl.endRefreshing()
        })
        task.resume()

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rentals = rentals {
            return rentals.count
        }
        else {
            return 0
        }

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RentalCell", forIndexPath: indexPath) as! RentalCell
        
        let rental = rentals![indexPath.row]
        
        let title = rental["title"] as! String
        let synopsis = rental["synopsis"] as! String
        let posterPaths = rental["posters"] as! NSDictionary
        let posterPath = posterPaths["detailed"] as! String
        
        let imageUrl = NSURL(string: posterPath)
        let imageRequest = NSURLRequest(URL: imageUrl!)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = synopsis
        cell.coverView.setImageWithURLRequest(imageRequest, placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                if imageResponse != nil {
                    cell.coverView.alpha = 0.0
                    cell.coverView.image = image
                    UIView.animateWithDuration(0.3, animations: {() -> Void in cell.coverView.alpha = 1.0})
                }
                else {
                    cell.coverView.image = image
                }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    print("failure")
        })
        return cell
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
