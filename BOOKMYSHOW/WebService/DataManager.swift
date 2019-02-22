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
}
