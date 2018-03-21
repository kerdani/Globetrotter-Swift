//
//  NewViewController.swift
//  Globetrotter
//
//  Created by Abdelrahman El Kerdani on 12/3/17.
//  Copyright © 2017 Abdelrahman El Kerdani. All rights reserved.
//

import UIKit
import QuartzCore

class NewViewController: UIViewController {
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var uuid = ""
    var heightScroll = 21+46;
    var varY = 100
    var x=0
    var x2=0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userInput: UITextField!
    
    @IBOutlet weak var count1: UILabel!
    @IBOutlet weak var count2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

     
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        guard let url = URL(string: "https://globetrotterapp.herokuapp.com/welcome")else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as AnyObject
                    self.uuid = json["uuid"] as! String
                    let message = json["message"] as! String
//                    print(json)
//                    print(self.uuid)
//                    print(message)
//
                    DispatchQueue.main.async {
                        let label = UILabel(frame: CGRect(x: 18, y: 55, width: 190, height: 21))
                        label.textAlignment = .left
                        label.text = message
                        //label.sizeToFit()
                        label.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
                        label.layer.cornerRadius = 5
                        label.font=UIFont(name:"Times New Roman" ,size:15)
//                        label.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
                        label.textColor = UIColor.white
                        self.x2+=1
                        self.count1.text = String(self.x2)
                        self.scrollView.addSubview(label)
                        
                        
                        
                        //self.userInput.becomeFirstResponder();
                        
                    }
                    
                    
                    
                    
                }
                catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = -1 * (endFrame?.size.height ?? 0.0)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func Help(_ sender: Any) {
//        DispatchQueue.main.async {
//            let label = UILabel(frame: CGRect(x: 18, y: 80, width: 190, height: 21))
//            label.textAlignment = .left
//            label.text = "Please enter a city or country"
//            //label.sizeToFit()
//            label.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
//            label.layer.cornerRadius = 5
//            label.font=UIFont(name:"Times New Roman" ,size:15)
//            //                        label.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
//            label.textColor = UIColor.white
//            self.x2+=1
//            self.count1.text = String(self.x2)
//            self.scrollView.addSubview(label)
//
       
        DispatchQueue.main.async {
            let label = UILabel(frame: CGRect(x: 18, y: self.varY, width: 160, height: 21))
            label.textAlignment = .left
            label.text = "Please enter a city/country"
            //                    label.sizeToFit()
            label.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
            label.layer.cornerRadius = 5
            label.font=UIFont(name:"Times New Roman" ,size:15)
            //                    label.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
            label.textColor = UIColor.white
            self.scrollView.addSubview(label)
            
            self.x2+=1
            self.count2.text = String(self.x)
            
            self.varY+=46
            self.heightScroll+=91
            self.scrollView.contentSize=CGSize(width:336,height:self.heightScroll)
            if(self.heightScroll>Int(self.scrollView.frame.height)){
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightScroll-Int(self.scrollView.frame.height)), animated: true)
            }        }
   //     self.x2+=1
        self.x2+=1
        self.count1.text = String(self.x2)

    }
    
    
    
    @IBAction func send(_ sender: Any) {
        
        let input = userInput.text as! String
        print(input)
        let parameters = ["message":input]
        guard let url = URL(string: "https://globetrotterapp.herokuapp.com/chat")else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.uuid, forHTTPHeaderField: "Authorization")
        guard let httpBody = try?JSONSerialization.data(withJSONObject: parameters, options: [])else {return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                print("error:", error)
            }
            
            let status = (response as! HTTPURLResponse).statusCode
            if (status == 422) {
                let json = String(data: data!, encoding: .utf8)!
                DispatchQueue.main.async {
                    let label1 = UILabel(frame: CGRect(x: 260, y: self.varY, width: 200, height: 21))
                    label1.textAlignment = .center
                    label1.text = input
                    label1.sizeToFit()
                    label1.lineBreakMode = .byWordWrapping
                    label1.numberOfLines = 0
                    label1.clipsToBounds = true
                    label1.font = UIFont(name:"Times New Roman",size:15)
                    label1.layer.backgroundColor = UIColor.lightGray.cgColor
                    label1.layer.cornerRadius = 5

//                    label1.backgroundColor = UIColor.lightGray
                    label1.textColor = UIColor.black
                    self.scrollView.addSubview(label1)
                    self.varY+=46
                    
                    self.x2+=1
                    self.count1.text = String(self.x2)
                    
                    let label = UILabel(frame: CGRect(x: 18, y: self.varY, width: 150, height: 21))
                    label.textAlignment = .left
                    label.text = json as! String
//                    label.sizeToFit()
                    label.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
                    label.layer.cornerRadius = 5
                    label.font=UIFont(name:"Times New Roman" ,size:15)
//                    label.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
                    label.textColor = UIColor.white
                    self.scrollView.addSubview(label)
                  
                    self.x+=1
                    self.count2.text = String(self.x)
                    
                    self.varY+=46
                    self.heightScroll+=91
                    self.scrollView.contentSize=CGSize(width:336,height:self.heightScroll)
                    if(self.heightScroll>Int(self.scrollView.frame.height)){
                     self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightScroll-Int(self.scrollView.frame.height)), animated: true)
                    }
                   // self.scrollView.contentSize=CGSize(width:336,height:self.heightScroll)
                    //self.userInput.text = ""
                    self.userInput.text = ""


                }
                //print(json)
            } else {
                do {
                    let text = String(data: data!, encoding: .utf8)!
                    //print(text)
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let array = json as! [String:Any]
                    //print(array)
                    
                    //                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    //                    print(json)
                    //print(json)
                    //print(json)
                    // let array = json as! [String:Any]
                    //print(array)
                    //print(array["message"])
                    
                    //print(array)
                    //                    for user in array {
                    //                        let userDic =  user as? [String:Any]
                    //                        let attraction = userDic!["Attraction"] as? String
                    //                        print(attraction)
                    //                    }
                    //print(array)
                    DispatchQueue.main.async {
                        let label = UILabel(frame: CGRect(x: 260, y: self.varY, width: 200, height: 21))
                        label.textAlignment = .center
                        label.text = input
                        label.font = UIFont(name:"Times New Roman",size:16)
                        label.sizeToFit()
                        label.font = UIFont(name:"Times New Roman",size:15)
                        label.lineBreakMode = .byWordWrapping
                        label.numberOfLines = 0
                        label.clipsToBounds = true
                        label.layer.backgroundColor = UIColor.lightGray.cgColor
                        label.layer.cornerRadius = 5
//                        label.backgroundColor = UIColor.lightGray
                        label.textColor = UIColor.black
                        
                        self.scrollView.addSubview(label)
                        self.varY+=46
                        self.x2+=1
                        self.count1.text = String(self.x2)
                        
                        let label1 = UILabel(frame: CGRect(x: 18, y: self.varY, width: 200, height: 21))
                        label1.textAlignment = .left
                        label1.text = array["message"] as! String
                        label1.lineBreakMode = .byWordWrapping
                        label1.numberOfLines=0
                        label1.clipsToBounds = true
                        label1.font=UIFont(name:"Times New Roman" ,size:15)
                        label1.sizeToFit()
                        label1.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
                        label1.layer.cornerRadius = 5
//                        label1.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
                        label1.textColor = UIColor.white
//                        label1.layer.backgroundColor = UIColor.lightGray.cgColor
//                        label1.layer.cornerRadius = 5
                        self.scrollView.addSubview(label1)
                        //print(label1.bounds.size.height)
                        var x = label1.bounds.size.height + 25
                        
                        self.x+=1
                        self.count2.text = String(self.x)
                        
                        self.varY+=Int(x)
                        self.heightScroll+=Int(x+71)
                        
                        self.scrollView.contentSize=CGSize(width:336,height:self.heightScroll)
                         self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightScroll-Int(self.scrollView.frame.height)), animated: true)
                        //                        self.results.text = text
                        //                        self.results.text = array["message"] as! String
                        self.userInput.text = ""
                    }
                    
                    
                }
                catch {
                    print("hey")
                    print(error)
                }
            }
            }.resume()
    }
    

    @IBAction func cairo(_ sender: Any) {
        print("cairo")
        let parameters = ["message":"Cairo"]
        guard let url = URL(string: "https://globetrotterapp.herokuapp.com/chat")else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.uuid, forHTTPHeaderField: "Authorization")
        guard let httpBody = try?JSONSerialization.data(withJSONObject: parameters, options: [])else {return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                print("error:", error)
            }

            let status = (response as! HTTPURLResponse).statusCode
            if (status == 422) {
                let json = String(data: data!, encoding: .utf8)!
            } else {
                do {
                    let text = String(data: data!, encoding: .utf8)!
                    //print(text)
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let array = json as! [String:Any]
                    //print(array)

                    //                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    //                    print(json)
                    //print(json)
                    //print(json)
                    // let array = json as! [String:Any]
                    //print(array)
                    //print(array["message"])

                    //print(array)
                    //                    for user in array {
                    //                        let userDic =  user as? [String:Any]
                    //                        let attraction = userDic!["Attraction"] as? String
                    //                        print(attraction)
                    //                    }
                    //print(array)
                    DispatchQueue.main.async {
                        let label = UILabel(frame: CGRect(x: 260, y: self.varY, width: 200, height: 21))
                        label.textAlignment = .center
                        label.text = "Cairo"
                        label.font = UIFont(name:"Times New Roman",size:17)
                        label.sizeToFit()
                        label.font = UIFont(name:"Times New Roman",size:15)
                        label.lineBreakMode = .byWordWrapping
                        label.numberOfLines = 0
                        label.clipsToBounds = true
                        label.layer.cornerRadius = 5
                        label.layer.backgroundColor = UIColor.lightGray.cgColor

                        

//                        label.backgroundColor = UIColor.lightGray
                        label.textColor = UIColor.black

                        self.scrollView.addSubview(label)
                        self.varY+=46

                        self.x2+=1
                        self.count1.text = String(self.x2)

                        let label1 = UILabel(frame: CGRect(x: 18, y: self.varY, width: 200, height: 21))
                        label1.textAlignment = .left
                        label1.text = array["message"] as! String
                        label1.lineBreakMode = .byWordWrapping
                        label1.numberOfLines=0
                        label1.clipsToBounds = true
                        label1.font=UIFont(name:"Times New Roman" ,size:15)
                        label1.sizeToFit()
                        label1.layer.backgroundColor = UIColor.init(red: 0, green: 0.74902, blue: 1, alpha: 1).cgColor
                        label1.layer.cornerRadius = 5
//                        label1.backgroundColor = UIColor(red:0 ,green:0.74902 ,blue:1, alpha:1)
                        label1.textColor = UIColor.white
                        self.scrollView.addSubview(label1)
                        print(label1.bounds.size.height)
                        var x = label1.bounds.size.height + 25

                        self.x+=1
                        self.count2.text = String(self.x)

                        self.varY+=Int(x)
                        self.heightScroll+=Int(x+71)

                        self.scrollView.contentSize=CGSize(width:336,height:self.heightScroll)
                        //                        self.results.text = text
                        //                        self.results.text = array["message"] as! String
                        
                        
//                       print(self.scrollView.frame.height)
//                       print(self.heightScroll)
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.heightScroll-Int(self.scrollView.frame.height)), animated: true)
                        self.userInput.text = ""

                    }


                }
                catch {
                    print("hey")
                    print(error)
                }
            }
            }.resume()
    }
    
    @IBAction func Reset(_ sender: Any) {
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
        self.heightScroll = 21+46;
        self.varY = 100
        self.scrollView.contentSize=CGSize(width:336,height:0)
        self.userInput.text = ""

        self.x2 = 0
        self.count1.text = String(self.x2)
        self.x = 0
        self.count2.text = String(self.x)
        self.viewDidLoad()
        
        


    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

}

