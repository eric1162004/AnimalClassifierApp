//
//  Animal.swift
//  AnimalClassifierApp
//
//  Created by eric on 2022-02-20.
//

import Foundation

class Animal {
    
    // url for the image
    var imageUrl: String
    
    // image data
    var imageData: Data?
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
    }
    
    init?(json: [String:Any]){
        
        // chekc that JSON has a url
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        
        // Set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        
        // download the image data
        getImage()
        
    }
    
    func getImage(){
        
        // Create a url object
        let url = URL(string: imageUrl)
        
        // check the url is not nil
        guard url != nil else {
            print("Couldn't get URL object")
            return
        }
        
        // get a url session
        let session = URLSession.shared
        
        // create the data task - this will fetch the actual image data of a given image url
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // check that there are no errors and there was data
            if error == nil && data != nil {
                self.imageData = data
            }
        }
        
        // start the data task
        dataTask.resume()
    }
}
