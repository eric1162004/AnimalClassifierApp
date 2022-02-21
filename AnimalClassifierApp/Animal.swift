//
//  Animal.swift
//  AnimalClassifierApp
//
//  Created by eric on 2022-02-20.
//

import Foundation
import CoreML
import Vision

// Prediction Result from Image Classifier Model
struct Result : Identifiable{
    let id = UUID()
    var imageLabel : String
    var confidence : Double
}

class Animal {
    
    // url for the image
    var imageUrl: String
    
    // image data
    var imageData: Data?
    
    // Classified results
    var results: [Result]
    
    let modelFile = try! CatOrDog_1(configuration: MLModelConfiguration())
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String:Any]){
        
        // chekc that JSON has a url
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        
        // Set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
        
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
                self.classifiyAnimal()
            }
        }
        
        // start the data task
        dataTask.resume()
    }
    
    func classifiyAnimal() {
        
        // Get a referenc eto the modle
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        // create an image handler
        let handler = VNImageRequestHandler(data: imageData!)
        
        // create a request to the model
        let request = VNCoreMLRequest(model: model){ (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("couldn't classify the iamge")
                return
            }
            
            for classification in results {
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
            
        }
        
        // execute the request
        do {
            try handler.perform([request])
        } catch {
            print("Invalid image")
        }
    }
}
