//
//  DataManager.swift
//  HDFCPerks
//
//  Created by Sanjay Mali on 24/05/18.
//  Copyright © 2018 Sanjay Mali. All rights reserved.
//

import Foundation
import UIKit
public  class DataManager{
    public func webservice(_ api:String,param:[String:Any],completion:@escaping (_ data:Data?, _ error:Error?) -> Void){
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string:api)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest){ (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode)
                  completion(data,nil)
            }
        }
        dataTask.resume()
    }
    public  func getRequest(_ api:String,param:[String:Any],completion:@escaping (_ data:Data?, _ error:Error?) -> Void){
        let color = UIColor.init(red:0/255, green: 76/255, blue: 143/255, alpha: 1)
        //        KRProgressHUD.set(style: .custom(background:color, text: .white, icon: nil)).set(maskType: .black).show()
        guard let url = URL(string:api) else { return }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        print(url)
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
//            request.httpBody = jsonData
//        } catch {
//            print("Something went wrong")
//        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do{
                if let er  = error  {
                    print("error = \(er.localizedDescription)")
                }
                guard data != nil else {
                    DispatchQueue.main.async{
//                        KRProgressHUD.dismiss()
                    }
                    
                    return
                }
                DispatchQueue.main.async{
//                    KRProgressHUD.dismiss()
                }
                completion(data,nil)
            }
            }.resume()
    }
}
