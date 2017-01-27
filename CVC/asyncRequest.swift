//
//  asyncRequest.swift
//  CVC
//
//  Created by Vora, Chintan on 1/21/17.
//  Copyright © 2017 Vora, Chintan. All rights reserved.
//

import Foundation
import UIKit

class AsyncRequest{

    let url = "https://vty3pl4ola.execute-api.us-east-1.amazonaws.com/dev"
    let httpMethod = "POST"
    
    
    func requestorImage(image: UIImage, localArr: [UIImage], tray: UICollectionView){
        let imagedata = UIImageJPEGRepresentation(image, 0.0);
        let base64image = (imagedata?.base64EncodedString())!
        let json: [String:Any] = ["operation": "insert-in-collection",
                                  "data": [
                                    "collection-name": "ccq10",
                                    "image": base64image
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print("ASYNC Requestor called")
        var request = URLRequest(url: URL(string: self.url)!)
        request.httpMethod = self.httpMethod
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                let res = responseJSON
                //print(res["input"]!)
                DispatchQueue.main.async {
                    //localArr.append(image)
                    tray.reloadData()
                    //let NSarr = res["response"]! as! NSArray
                    //let firstObj = NSarr[0] as! String
                    //print("Insert ID: \(firstObj)")
                    //self.imageArr.append(image)
                    //self.tray.reloadData()
                    //return res
                }
                //let ret = res["code"]! as! Int
                //print("ret: \(ret)")
            }
        }
        task.resume()
    }
}
