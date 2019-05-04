//
//  Photos.swift
//  FlickrFinder
//
//  Created by Mohamed Mohsen on 5/3/19.
//  Copyright © 2019 Mohamed Mohsen. All rights reserved.
//

import Foundation

class FlickrPhotos{
    
    static func getSearchPhotosAPIURLAbout(searchingText: String) -> [Photo]{
        let flickrParameters =
            [
                FlickrConstants.FlickrParameterKeys.Method : FlickrConstants.Photots.Methods.flickr_photos_search.rawValue,
                FlickrConstants.FlickrParameterKeys.APIKey : FlickrConstants.APIKeys.sleepingInTheLibraryAPIKey.rawValue,
                FlickrConstants.FlickrParameterKeys.Text : searchingText,
                FlickrConstants.FlickrParameterKeys.SafeSearch : FlickrConstants.SafeSearch.safe.rawValue,
                FlickrConstants.FlickrParameterKeys.Extras : FlickrConstants.Extras.url_m.rawValue,
                FlickrConstants.FlickrParameterKeys.Format : FlickrConstants.OutputResponseFormat.Format.JSON.rawValue,
                FlickrConstants.FlickrParameterKeys.NoJSONCallback : FlickrConstants.OutputResponseFormat.JSONCallback.DisableJSONCallback.rawValue
                ] as [String: AnyObject]
        
        let searchPhotosURL = flickrURLFrom(parameters: flickrParameters)

        return getSearchPhotosURLUsingFlickrAPIFor(searchPhotosURL: searchPhotosURL)
    }
    
    static func getSearchPhotosAPIURLWithCoords(latitude: String, longitude: String) -> [Photo]?{
        guard let lat = Double(latitude) else {
            print("Error! Latitude should entered only in numbers such as: 25.17")
            return nil
        }
        
        guard let long = Double(longitude) else {
            print("Error! Longitude should entered only in numbers such as: 25.17")
            return nil
        }
        
//        let latSign = (lat > 0) ? "+" : ""
//        let longSign = (long > 0) ? "+" : ""
//
//        let minLong = long - 0.01
//        let minLat = lat - 0.01
//        let maxLong = long + 0.01
//        let maxLat = lat + 0.01
//
//        let bbox = "\(minLong),\(minLat),\(maxLong),\(maxLat)"
        
        let flickrParameters =
            [
                FlickrConstants.FlickrParameterKeys.Method : FlickrConstants.Photots.Methods.flickr_photos_search.rawValue,
                FlickrConstants.FlickrParameterKeys.APIKey : FlickrConstants.APIKeys.sleepingInTheLibraryAPIKey.rawValue,
                FlickrConstants.FlickrParameterKeys.Bbox : bboxString(lat: latitude, long: longitude),
                FlickrConstants.FlickrParameterKeys.SafeSearch : FlickrConstants.SafeSearch.safe.rawValue,
                FlickrConstants.FlickrParameterKeys.Extras : FlickrConstants.Extras.url_m.rawValue,
                FlickrConstants.FlickrParameterKeys.Format : FlickrConstants.OutputResponseFormat.Format.JSON.rawValue,
                FlickrConstants.FlickrParameterKeys.NoJSONCallback : FlickrConstants.OutputResponseFormat.JSONCallback.DisableJSONCallback.rawValue
                ] as [String: AnyObject]
        
        let searchPhotosURL = flickrURLFrom(parameters: flickrParameters)
        
        return getSearchPhotosURLUsingFlickrAPIFor(searchPhotosURL: searchPhotosURL)
    }
    
    private static func bboxString(lat: String, long: String) -> String {
        // ensure bbox is bounded by minimum and maximums
        if let latitude = Double(lat), let longitude = Double(long) {
            let minimumLon = max(longitude - FlickrConstants.Flickr.SearchBBoxHalfWidth, FlickrConstants.Flickr.SearchLonRange.0)
            let minimumLat = max(latitude - FlickrConstants.Flickr.SearchBBoxHalfHeight, FlickrConstants.Flickr.SearchLatRange.0)
            let maximumLon = min(longitude + FlickrConstants.Flickr.SearchBBoxHalfWidth, FlickrConstants.Flickr.SearchLonRange.1)
            let maximumLat = min(latitude + FlickrConstants.Flickr.SearchBBoxHalfHeight, FlickrConstants.Flickr.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
    }

    
    private static func flickrURLFrom(parameters: [String: AnyObject]) -> URL{
        var components = URLComponents()
        components.scheme = FlickrConstants.Flickr.APIScheme
        components.host = FlickrConstants.Flickr.APIHost
        components.path = FlickrConstants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters{
            //convert value to be in string format
            components.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: ",", with: "%2C")
        return components.url!
    }
    
    private static func getSearchPhotosURLUsingFlickrAPIFor(searchPhotosURL: URL) -> [Photo]{
        var galleryPhotos = [Photo]()
        
        let httpRequest = URLRequest(url: searchPhotosURL)
        //httpRequest.httpMethod = HttpConstants.HttpMethod.GET
        let group = DispatchGroup()
        group.enter()
        let task = URLSession.shared.dataTask(with: httpRequest) { (data, urlResponse, error) in
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                print("URL at time of error: \(searchPhotosURL)")
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let dataAsJSON: AnyObject!
            do{
                dataAsJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }catch{
                print("Error! Could not parse the data to JSON.")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = dataAsJSON[FlickrConstants.FlickrResponseKeys.Status] as? String, stat == FlickrConstants.FlickrResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(dataAsJSON!)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = dataAsJSON[FlickrConstants.FlickrResponseKeys.Photos] as? [String: AnyObject], let photoArray = photosDictionary[FlickrConstants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(FlickrConstants.FlickrResponseKeys.Photos)' and '\(FlickrConstants.FlickrResponseKeys.Photo)' in \(dataAsJSON!)")
                return
            }
            
            for photoJSON in photoArray{
                guard let urlString = photoJSON[FlickrConstants.Extras.url_m.rawValue] as? String else {
                    continue
                }
                
                guard let title = photoJSON[FlickrConstants.CommonAttributes.title.rawValue] as? String else {
                    continue
                }
                
                guard let url = URL(string: urlString) else{
                    continue
                }
                
                galleryPhotos.append(Photo(title: title, url: url))
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return galleryPhotos
    }
    
    private static func escapedParameters(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return String() //return empty string
        }
        
        var keyValuePairs = [String]()
        
        for (key, value) in parameters{
            
            //convert value to be in string format
            let valueAsString = "\(value)"
            
            //Returns a new string created by replacing all characters in the string not in the specified set with percent encoded characters.
            let valueWithReplacingEscappedParameters = valueAsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            //append the new value in the KeyValuePairs
            keyValuePairs.append(key + "=\(valueWithReplacingEscappedParameters!)")
        }
        //join an ampersand "&" between every parameter in the parameters
        //add a question mark "?" at the beginning of the method parameter
        return "?\(keyValuePairs.joined(separator: "&"))"
    }
    
}
