//
//  APIClient.swift
//  YunDan
//
//  Created by Jakey on 14-7-31.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

import UIKit

var _sharedClient:HttpClient!


class HttpClient: NSObject {

    class func sharedClient()->HttpClient{
        if _sharedClient == nil{
            _sharedClient = HttpClient();
        }
        return _sharedClient;
    }
    //回调的闭包
    typealias Response = (NSURLResponse!, AnyObject!, NSError!) -> Void
 
    //post请求
     func postParam(uri:String, param: Dictionary<String, String>?,block:Response){
        
        var paramDic:NSDictionary =  NSDictionary()
        if param?.count>0{
            paramDic = param!
        }
        
        let jsonString = jsonFromDictionary(paramDic)

        var url: NSURL = NSURL(string: uri)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        let data = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
  
                if error?
                {
                    block(response, nil, error)
                }
                else
                {
                    print(response.description)
                    let jsonData:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                    if (jsonData?.isKindOfClass(NSDictionary) && jsonData?.count>0){
                        block(response, jsonData, nil)
                    }else{
                        block(response, nil, nil)
                    }
                }
           })

    }

    //get请求
    func getParam(url: String, param: Dictionary<String, String>, block: Response) {
        
        var newUrl = url
        if param.count != 0 {
            newUrl += "?"
            var i = 0
            for (key ,value) in param {
                if i != 0 {
                    newUrl += "&"
                }
                
                newUrl += "\(key)=\(value)"
                i++
            }
        }
        var request = NSMutableURLRequest(URL: NSURL(string: newUrl))
        request.HTTPMethod = "GET"
       
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            if error?
            {
                block(response, nil, error)
            }
            else
            {
                let jsonData:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                if (jsonData?.isKindOfClass(NSDictionary)){
                    block(response, jsonData, nil)
                }else{
                    block(response, nil, nil)
                }
            }
        })

    }
    
    
    func jsonFromDictionary(jsonObj: NSDictionary) ->String{
        var error:NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(
            jsonObj,
            options: NSJSONWritingOptions(0),
            error: &error)
        var string = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
        return string
    }
    //把 JSON 转成 Array 或 Dictionary
    func objectFromJSON(json:String!) -> AnyObject! {
        let string:NSString = json
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        var error:NSError?
        let object : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        if let err = error {
            println("JSON to object error:\(err.localizedDescription)")
            return nil
        } else {
            return object;
        }
    }

    //把 Array 或 Dictionary 转 JSON
    func JSONFromObject(object:AnyObject!) -> String!{
        if !NSJSONSerialization.isValidJSONObject(object) {
            return nil
        }
        var error:NSError?
        let data = NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions(0), error: &error)
        if let err = error {
            println("object to JSON error:\(err.localizedDescription)")
            return nil
        } else {
            return NSString(data: data, encoding: NSUTF8StringEncoding)
        }
    }
    //URL 解编码
    func decodeEscapesURL(value:String) -> String {
        let str:NSString = value
        return str.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        /*
        var outputStr:NSMutableString = NSMutableString(string:value);
        outputStr.replaceOccurrencesOfString("+", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, outputStr.length))
        return outputStr.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        */
    }
    //URL 编码
    func encodeEscapesURL(value:String) -> String {
        let str:NSString = value
        let originalString = str as CFStringRef
        let charactersToBeEscaped = "!*'();:@&=+$,/?%#[]" as CFStringRef  //":/?&=;+!@#$()',*"    //转意符号
        //let charactersToLeaveUnescaped = "[]." as CFStringRef  //保留的符号
        let result =
        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
            originalString,
            nil,    //charactersToLeaveUnescaped,
            charactersToBeEscaped,
            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as NSString
        
        return result as String
    }

    
}
