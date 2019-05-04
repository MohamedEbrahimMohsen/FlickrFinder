//
//  FlickrConstants.swift
//  FlickrFinder
//
//  Created by Mohamed Mohsen on 5/3/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

struct FlickrConstants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest/"
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let Text = "text"
        static let SafeSearch = "safe_search"
        static let Bbox = "bbox"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    // MARK: Flickr Output Response Format
    struct OutputResponseFormat{
        enum Format: String {
            case JSON = "json"
            case XML = "XML"
        }
        
        enum JSONCallback: String{
            case DisableJSONCallback = "1" /* 1 means "yes" */
            case EnableJSONCallback  = "0"
        }
    }
    
    // MARK: Flickr Galleries
    struct Galleries{
        enum Methods: String{
            case flickr_galleries_getPhotos = "flickr.galleries.getPhotos"
        }
        
        enum ID: String{
            case sleepingInTheLibraryID = "169786254-72157708327683714" /* Sleeping In The Library Gallery API ID */
        }
    }
    
    // MARK: Flickr Photos
    struct Photots{
        enum Methods: String{
            case flickr_photos_search = "flickr.photos.search"
        }
    }
    
    // MARK: Flickr Extras
    enum Extras: String{
        case url_m = "url_m"
    }
    
    // MARK: Flickr Safe Search
    enum SafeSearch: String{
        case safe = "1"
        case moderate = "2"
        case restricted = "3"
    }
    
    enum CommonAttributes: String{
        case title = "title"
    }
    
    // MARK: Flickr API Keys for the Applications
    enum APIKeys: String{
        case sleepingInTheLibraryAPIKey = "9bd28741be28392a227491f44bb604ea" /* Sleeping In The Library API Key */
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}

// MARK: HTTP Constants
struct HttpConstants{
    struct HttpMethod{
        static let GET = "GET"
        static let POST = "POST"
    }
}
