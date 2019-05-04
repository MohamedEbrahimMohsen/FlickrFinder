//
//  Photo.swift
//  FlickrFinder
//
//  Created by Mohamed Mohsen on 5/3/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

// Class for the photo represntation.
class Photo{
    var title: String
    var url: URL!
    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}
