//
//  ViewController.swift
//  APIJpushSwift
//
//  Created by OFweek01 on 2020/12/16.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let params: [String: Any] = [
            "platform": "all",
            "audience": "all",
            "notification": [
                "alert": "Hi,JPush !",
                "test": "https://www.baidu.com"
            ],
            "options": [
                "apns_production": false
            ]
        ]
        
        guard let url = URL.init(string: "https://api.jpush.cn/v3/push") else {
            return
        }
        var headers = [String: String]()
        let appKey = ""
        let masterSecret = ""
        let utf8EncodeData = "\(appKey):\(masterSecret)".data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        headers["Authorization"] = "Basic " + (base64String ?? "")
        // JSONEncoding.default
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                debugPrint(value)
                break
            case .failure(let error):
                debugPrint(error.localizedDescription)
                break
            }
        }
        
    }
    
    
}

