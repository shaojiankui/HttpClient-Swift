//
//  MainViewController.swift
//  HttpClient-Swift
//
//  Created by Jakey on 14-8-5.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var dataList:NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
    
        let testUrl = "http://api.skyfox.org/api-test.php"
        var dic: Dictionary<String, String> = ["action": "cateList"]
        HttpClient.sharedClient().postParam(testUrl,param:dic,block: {  (response: NSURLResponse!, data: AnyObject!, error: NSError!) -> Void in
        
        let dic = data as Dictionary<String, AnyObject>
            
            var alert = UIAlertView(title: "成功", message: dic.description, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        });
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
