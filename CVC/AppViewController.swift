//
//  ViewController.swift
//  CVC
//
//  Created by Vora, Chintan on 1/20/17.
//  Copyright © 2017 Vora, Chintan. All rights reserved.
//

import UIKit

class AppViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate{

    var indexArr : [IndexPath] = []
    var imageArr : [UIImage?] = []
    var selectedImages: [String] = []
    var targetImages: [Int] = []
    var collectionName: String = ""
    var secondView = false
    
    var trashCalled = false
    
    var insertedImages = [String:String]()
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    @IBOutlet weak var deleteOutlet: UIButton!
    
    @IBAction func secondView(_ sender: UIButton) {
        secondView = !secondView
    }
    
    @IBAction func rekognition(_ sender: UIButton) {
        similarity()
    }
    
    @IBOutlet weak var rekognitionOutlet: UIButton!
    
    @IBOutlet weak var faceMatchCount: UILabel!
    
    @IBOutlet weak var secondImageVIew: UIImageView!
    
    @IBAction func addInView(_ sender: UIButton) {
        secondView = true
        addFromLibrary(sender)
    }
    
    @IBAction func addInViewCam(_ sender: UIButton) {
        secondView = true
        addFromCamera(sender)
    }

    
    @IBAction func addInTray(_ sender: UIButton) {
        secondView = false
        addFromLibrary(sender)
    }
    
    @IBOutlet weak var sentiment: UIButton!
    
    @IBAction func sentimentAnalysis(_ sender: UIButton) {
        requestorSentiment(image: secondImageVIew.image!)
    }
    
    @IBOutlet weak var sentimentOutput: UITextView!
    
    
    @IBOutlet weak var similarityOutlet: UIButton!
    
    @IBAction func addInTrayCam(_ sender: UIButton) {
        secondView = false
        addFromCamera(sender)
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var trashOutlet: UIButton!
    
    @IBAction func trashImages(_ sender: UIButton) {
        
        trashCalled = true
        isDeleteOptionOn = false
        
        //requestorGeneral(operation: "delete-collection")
        
        print("a")
        for ind in indexArr{
            collectionView(tray, didSelectItemAt: ind)
        }
        
        self.targetImages = self.targetImages.sorted{$0 > $1}
        print("-------")
        print(self.targetImages.count)
        print(self.targetImages)
        print("------")
        
        
        print("b")
        for index in targetImages{
            imageArr.remove(at: index)
        }
        print("c")
        if self.indexArr.count > 0 {
            self.indexArr.removeAll()
        }
        print("d")
        if self.targetImages.count > 0{
            self.targetImages.removeAll()
        }
        print("e")
        
        print("before call")
        requestorGeneral(operation: "delete-collection")
        print("after call")
        //self.tray.reloadData()
        isDeleteOptionOn = true
        
        //Delete(sender)
        //toggleDelete()
        trashCalled = false
    }
    
    
    var isDeleteOptionOn: Bool = false
    
    func toggleDelete(){
        trashOutlet.isHidden = !trashOutlet.isHidden
        isDeleteOptionOn = !isDeleteOptionOn
    }
    
    @IBOutlet weak var collectionInput: UITextField!
    
    @IBAction func del(_ sender: UIButton) {
        
    }
    
    @IBAction func addToCollection(_ sender: UIButton) {
        
        //print(collectionView(tray, numberOfItemsInSection: 10))
        
        //tableData.append("ABC")
        print("Collection Name: \(collectionName)")
        print("CURRENT IMAGE ARRAY:\(imageArr)")
        print("IMAGE ARRAY COUNT: \(imageArr.count)")
        print("TRACKING ARRAY: \(selectedImages)")
        print("Second View: \(secondView)")
        print("Second image view: \(secondImageVIew.image)")
        print("Target Array: \(targetImages)")
        print("Index Array: \(indexArr)")
        print("Delete Option On? \(isDeleteOptionOn)")
        print("Trash flag On? \(trashCalled)")
        
        //self.tray.reloadData()
        
    }
    
    /*
    @IBAction func createCollection(_ sender: UIButton) {
     requestorGeneral(operation: "create-collection")
    }
    */
    
    @IBAction func Delete(_ sender: UIButton) {
        toggleDelete()
        if isDeleteOptionOn == false{
            deleteOutlet.tintColor = UIColor.black
            deleteOutlet.setImage(#imageLiteral(resourceName: "pointer"), for: .normal)
           // deleteOutlet.setTitle("Unselectable", for: .normal)
        }else{
            deleteOutlet.tintColor = UIColor.red
            deleteOutlet.setImage(#imageLiteral(resourceName: "select"), for: .normal)
           // deleteOutlet.setTitle("Selectable", for: .normal)
        }
        print("DELETE?: \(isDeleteOptionOn)")
        
    }
    
    @IBOutlet weak var tray: UICollectionView!
    
    
    // ----------- App Load ----------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reset(UIButton())
        self.rekognitionOutlet.isHidden = true
        self.sentiment.isHidden = true
        self.similarityOutlet.isHidden = true
       // self.deleteOutlet.setTitle("UnSelectAble", for: .normal)
        self.deleteOutlet.setImage(#imageLiteral(resourceName: "pointer"), for: .normal)
        self.trashOutlet.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // -------------- Image Picker ------------------
    
    var async = AsyncRequest()
    
    @IBAction func addFromLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            //self.imageView.scale = 0.50
        }
    }
    
    @IBAction func addFromCamera(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            //self.imageView.scale = 0.50
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        
        if secondView == true{
            secondImageVIew.image = image
            secondImageVIew.alpha = 1
            secondImageVIew.backgroundColor = UIColor.white
            self.rekognitionOutlet.isHidden = false
            self.sentiment.isHidden = false
            self.similarityOutlet.isHidden = false
            requestorSentiment(image: self.secondImageVIew.image!)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil);
            requestor(image: image)
        }

    }
    
    // ------ Requestor -------
    let url = ""
    let httpMethod = "POST"
    
    

    

    
    
    @IBAction func reset(_ sender: UIButton) {
        self.imageArr.removeAll()
        self.targetImages.removeAll()
        self.tray.reloadData()
        self.rekognitionOutlet.isHidden = true
        self.selectedImages.removeAll()
        self.secondImageVIew.image = nil
        //self.collectionName = ""
    }
    
    
    // --------------- Collection View Logic ---------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: colvwCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! colvwCell
            //cell.label.text = tableData[indexPath.row]
            //cell.pickedImage.image = UIImage(named: imageDB[indexPath.row])
            cell.pickedImage.image = imageArr[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Cell \(indexPath.row) selected")
        //print(self.collectionView(tray, cellForItemAt: indexPath))
        
        let cell = collectionView.cellForItem(at: indexPath)
        

        if self.isDeleteOptionOn == true{
            indexArr.append(indexPath)
            targetImages.append(indexPath.row)
            
            
            cell?.layer.borderColor = UIColor(red: 0.72, green: 0.61, blue: 1.39, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 5
            
        }else{
            cell?.layer.borderColor = UIColor.white.cgColor
        }
       //let col = UIColor(cgColor:(cell?.layer.backgroundColor)!).
        //print("CELL COLOR: \(col)")
    }

    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func delCol(_ sender: UIButton) {
        requestorGeneral(operation: "delete-collection")
    }
    
    
    func sentimentObjToDict(obj: [Any]) -> [String]{
        print("Inside Sentiment Function")
        var respArr: [String] = []
        var resp = ""
        for each in obj{
            
            let face = each as! [String: Any]
            let genderObj = face["gender"] as! [Any]
            let gender = genderObj[0] as! String
            let genderConfidence = genderObj[1] as! Double
            resp = gender+" "+String(genderConfidence)
            
            var emotionBlob :[String] = []
            let emotionObj = face["emotions"] as! [Any]
            for emotion in emotionObj{
                let feeling = emotion as! [Any]
                let verb = feeling[0] as! String
                let verbConfidence = String(feeling[1] as! Double)
                let v = "\t "+verb+" "+verbConfidence
                emotionBlob.append(v)
            }
            let eb = emotionBlob.map{String($0)}.joined(separator: "\n")
            respArr.append(resp)
            respArr.append(eb)
        }
        return respArr
    }
    
    // -------- Sentiment Analysis ------------
    
    func requestorSentiment(image: UIImage){
        
        print("Sentiment Analysis")
        let imagedata = UIImageJPEGRepresentation(image, 0.0);
        let base64image = (imagedata?.base64EncodedString())!
        let json: [String:Any] = ["operation": "get-face-detail",
                                  "data": [
                                    "image": base64image
                                    ]
                                ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: self.url)!)
        request.httpMethod = self.httpMethod
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let res = responseJSON
                DispatchQueue.main.async {
                    let ret = res["code"]! as! Int
                    let res = res["response"] as! [Any]
                    let respArr = self.sentimentObjToDict(obj: res)
                    
                
                    print(respArr)
                    
                    let ssss = String(describing: res)
                    self.sentimentOutput.text = String(describing: respArr.map{String($0)}.joined(separator: "\n\n"))
                    
                    //print("res \(res)")
                    //let obj = res[0] as! [String:Any]
                    //let gender = obj["gender"] as! [String:Double]
                    //print("Ret result: \(gender)")
                    //print("JSON: \(res)")
                }
            }
        }
        task.resume()
    }
    
    // ------- Create Collection ----------
    
    func requestorGeneralCreate(operation: String){
        print("Create COLL CALLED")
        let collectionName = self.collectionName
        let json: [String:Any] = ["operation": operation,
                                  "data": [
                                    "collection-name": collectionName
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
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
                    let ret = res["code"]! as! Int
                    if ret == 201 {
                        print("Create Success")
                        self.requestorAddMulti(imageArr: self.imageArr as! [UIImage])
                    }else{
                        print("No such collection exists")
                    }
                    //self.collectionLabel.text = self.collectionInput.text!
                    //self.collectionName = self.collectionLabel.text!
                    //self.tray.reloadData()
                }
            }
        }
        task.resume()
    }
    
    
    // ------- Delete Collection -----------
    func requestorGeneral(operation: String){
        print("DELETE COLL CALLED")
        let collectionName = self.collectionName
        let json: [String:Any] = ["operation": operation,
                                  "data": [
                                    "collection-name": collectionName
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
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
                    let ret = res["code"]! as! Int
                    if ret == 200 {
                        print("Delete Success")
                        self.requestorGeneralCreate(operation: "create-collection")
                    }else{
                        print("No such collection exists")
                    }
                    //self.collectionLabel.text = self.collectionInput.text!
                    //self.collectionName = self.collectionLabel.text!
                    //self.tray.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func arrayToBase64Images(imageArr: [UIImage]) -> [String]{
        var copyArr: [String] = []
        for image in imageArr{
            let imagedata = UIImageJPEGRepresentation(image, 0.0);
            let base64image = (imagedata?.base64EncodedString())!
            copyArr.append(base64image)
        }
        return copyArr
    }
    
    func requestorAddMulti(imageArr: [UIImage]){
        let requestArr = arrayToBase64Images(imageArr: imageArr)
        let json: [String:Any] = ["operation": "multi-insert-in-collection",
                                  "data": [
                                    "collection-name": self.collectionName,
                                    "images": requestArr
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
                    //let NSarr = res["response"]! as! NSArray
                    //let firstObj = NSarr[0] as! String
                    //print("Insert ID: \(firstObj)")
                    self.insertIdsIntoArray(imageArray: res["response"] as! [String])
                    print("RESP: \(res["response"])")
                    self.tray.reloadData()
                    //self.multiInsertImageArrAppend(imgArr: imageArr)
                    //self.imageArr.append(image)
                    //self.tray.reloadData()
                }
                //let ret = res["code"]! as! Int
                //print("ret: \(ret)")
            }
        }
        task.resume()
    }
    
    func multiInsertImageArrAppend(imgArr: [UIImage]){
        for image in imgArr{
            self.imageArr.append(image)
        }
    }
    
    
    func requestor(image: UIImage){
        
        let imagedata = UIImageJPEGRepresentation(image, 0.0);
        let base64image = (imagedata?.base64EncodedString())!
        let json: [String:Any] = ["operation": "insert-in-collection",
                                  "data": [
                                    "collection-name": self.collectionName,
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
                    //let NSarr = res["response"]! as! NSArray
                    //let firstObj = NSarr[0] as! String
                    //print("Insert ID: \(firstObj)")
                    self.insertIdsIntoArray(imageArray: res["response"] as! [String])
                    print("RESP: \(res["response"])")
                    self.imageArr.append(image)
                    self.tray.reloadData()
                }
                let ret = res["code"]! as! Int
                print("ret: \(ret)")
            }
        }
        task.resume()
    }
 
    func insertIdsIntoArray(imageArray: [String]){
        if imageArray.count > 0{
            for img in imageArray {
                print("Image id: \(img)")
                self.selectedImages.append(img)
            }
        }
    }
    
    func similarity(){
        print("REKOGNITION CALLED")
        let image = secondImageVIew.image!
        let imagedata = UIImageJPEGRepresentation(image, 0.0);
        let base64image = (imagedata?.base64EncodedString())!
        let json: [String:Any] = ["operation": "similarity-in-collection",
                                  "data": [
                                    "collection-name": self.collectionName,
                                    "image": base64image
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
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
                //print(responseJSON)
                let res = responseJSON
                //print(res)
                DispatchQueue.main.async {
                    let r = res["response"]
                    
                    if let re = res["response"]{
                        let resp = re as! [Double]
                        if resp.count > 0 {
                            self.textView.text = resp.map{String($0)}.joined(separator: "\n")
                            self.faceMatchCount.text = "Faces matched: "+String(resp.count)
                           // self.rekognitionOutput.text = resp.map{String($0)}.joined(separator: " ")
                        }else{
                            self.textView.text = "Not Similar"
                            self.faceMatchCount.text = String("Faces matched: 0")
                            //self.rekognitionOutput.text = String("Not Similar")
                        }
                    }
                }
            }
        }
        task.resume()
    }
}








