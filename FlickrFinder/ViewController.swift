//
//  ViewController.swift
//  FlickrFinder
//
//  Created by Mohamed Mohsen on 5/3/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchingLatitudeLongtiudeBtn: UIButton!
    @IBOutlet weak var searchingTextBtn: UIButton!
    @IBOutlet weak var longitudeText: UITextField!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var searchingText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableUI(isEnabled: true)
    }
    
    func searchForImage(searchPhotos: [Photo]) {
        
        guard searchPhotos.count > 0 else {
            DispatchQueue.main.async {
                self.imageTitle.text = "Sorry, this search text has no related images."
            }
            return
        }
        
        let randIndex = Int(arc4random()) % searchPhotos.count
        let photo = searchPhotos[randIndex]
        let task = URLSession.shared.dataTask(with: photo.url, completionHandler: {
            (data, urlResponse, error) in
            
            /* GUARD: Was there an error? */
            guard error == nil else{
                print("An error happened during fetching the URL: \(photo.url!), with error message: \(error!)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by loading the URL: \(photo.url!)")
                return
            }
            
            /* GUARD: Could be binded as an image */
            guard let image = UIImage(data: data) else {
                print("Returned data couldn't be binded as an image, data: \(data)")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.imageTitle.text = photo.title
            }
        })
        task.resume()
    }
    
    //All we need to deactivate the "Grab New Photo From Gallery" button
    //So, user can't press it while we are still fetching & loading the image
    func enableUI(isEnabled: Bool){
        self.searchingTextBtn.isEnabled = isEnabled
        self.searchingLatitudeLongtiudeBtn.isEnabled = isEnabled
        self.searchingText.isEnabled = isEnabled
        self.latitudeText.isEnabled = isEnabled
        self.longitudeText.isEnabled = isEnabled
        self.imageTitle.text = (isEnabled) ? "Search For Image..." : "Fetching Your Image..."
    }
    
    @IBAction func searchForImageUsingText(_ sender: UIButton) {
        enableUI(isEnabled: false)
        
        guard let text = self.searchingText.text else {
            return
        }
        let searchPhotos = FlickrPhotos.getSearchPhotosAPIURLAbout(searchingText: text)
        searchForImage(searchPhotos: searchPhotos)
        enableUI(isEnabled: true)
    }
    
    @IBAction func searchingForImageUsingLatitudeAndLongtitude(_ sender: UIButton) {
//        self.latitudeText.text = "48.85"
//        self.longitudeText.text = "2.29"
        enableUI(isEnabled: false)
        guard let latitude = self.latitudeText.text else {
            return
        }
        guard let longitude = self.longitudeText.text else {
            return
        }
        guard let searchPhotos = FlickrPhotos.getSearchPhotosAPIURLWithCoords(latitude: latitude, longitude: longitude) else {
            return
        }
        searchForImage(searchPhotos: searchPhotos)
        enableUI(isEnabled: true)
    }
    
}

