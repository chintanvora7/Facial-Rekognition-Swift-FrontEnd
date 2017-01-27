//
//  topicVC.swift
//  CVC
//
//  Created by Vora, Chintan on 1/22/17.
//  Copyright © 2017 Vora, Chintan. All rights reserved.
//

import UIKit

class topicVC: UIViewController {

    @IBOutlet weak var topic: UITextField!

    @IBOutlet weak var segOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("topic: \(topic.text!)")
        segOutlet.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segbutton(_ sender: UIButton) {
        performSegue(withIdentifier: "appseg", sender: "ASSDASD")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AppViewController {
                destination.collectionName = topic.text!
                //destination.reset(UIButton())
                //destination.collectionLabel.text = topic.text!
                //destination.reloadInputViews()
                //destination.collectionLabel.text = "ccq9"
        }
    }
    
    @IBAction func createTopic(_ sender: UIButton) {
        requestorGeneral(operation: "create-collection")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestorGeneral(operation: String){
        let url = "https://vty3pl4ola.execute-api.us-east-1.amazonaws.com/dev"
        let httpMethod = "POST"
        let collectionName = self.topic.text!
        let json: [String:Any] = ["operation": operation,
                                  "data": [
                                    "collection-name": collectionName
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = httpMethod
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
                    print("SUCCESS")
                    self.segOutlet.isHidden = false
                }
            }
        }
        task.resume()
    }

}
