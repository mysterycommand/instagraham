//
//  PhotosViewController.swift
//  instagraham
//
//  Created by Tommy Chheng on 8/26/15.
//  Copyright (c) 2015 Matt Hayes. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var photos:[NSDictionary]?
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: "updatePhotos", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.insertSubview(self.refreshControl!, atIndex:0)
        
        updatePhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePhotos() {
        var clientId = "41cd0066b82f47e69db868af15c4b370"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            self.photos = responseDictionary["data"] as? [NSDictionary]
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = photos {
            return p.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: PhotoCell = tableView.dequeueReusableCellWithIdentifier("cell") as! PhotoCell
        
        let photo = photos![indexPath.row]
        
        let imageUrl = NSURL(string: photo.valueForKeyPath("images.low_resolution.url") as! String)
        
        cell.photoView?.setImageWithURL(imageUrl!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationView = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        
        let photo = photos![indexPath.row]
        destinationView.photo = photo
    }
}
