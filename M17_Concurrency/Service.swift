//
//  ViewModel.swift
//  M17TableView
//
//  Created by Maxim NIkolaev on 01.12.2021.
//

import UIKit
import SnapKit

struct Service {
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString)
                
        else {
            print("Ошибка, не удалось загрузить изображение")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, error, response) in
            guard let data = data else {
                print("Not found")
                
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
        }
        task.resume()
    }
    
    func getImageURL(completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let someDictionaryFromJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let imageUrl = someDictionaryFromJSON?["message"] as? String
            completion(imageUrl, error)
        }
        task.resume()
    }
}

