//
//  AnimalModel.swift
//  AnimalClassifierApp
//
//  Created by eric on 2022-02-20.
//

import Foundation

class AnimalModel : ObservableObject {
    
    @Published var animal = Animal()
    
    func getAnimal(){
        
        let stringUrl = Bool.random() ? catUrl : dogUrl
        
        // create a url object
        let url = URL(string: stringUrl)
        
        // check that the url isnt nil
        guard url != nil else {
            print("Couldn't create URL object")
            return
        }

        // get a url session
        let session = URLSession.shared
        
        // create a data task - a random dog or cat
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            if error == nil && data != nil {
                
                // try to parse JSON
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [[String:Any]] {
                        
                        // check if response is empty or pick the first animal
                        let item = json.isEmpty ? [:] : json[0]
                        
                        // pass the json object to the animal initializer
                        // the animal initializer will fetch the animal image data
                        if let animal = Animal(json: item){
                            
                            // must complete in the main thread
                            DispatchQueue.main.async {
                                // an infinite loop
                                // do not move on until prediction results has been fetched
                                while animal.results.isEmpty {}
                                self.animal = animal
                            
                            }
                        }
                    }
                }catch {
                    print("Could't parse JSON")
                }
            }
        }
        
        // start the data task
        dataTask.resume()
        
    }
}
