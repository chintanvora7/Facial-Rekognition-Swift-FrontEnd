//
//  topicController.swift
//  CVC
//
//  Created by Vora, Chintan on 1/22/17.
//  Copyright © 2017 Vora, Chintan. All rights reserved.
//

import UIKit

class topicController: UIViewController {

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination
        if let identifier = segue.identifier {
            print(identifier)
            
            
        }
    }

}
