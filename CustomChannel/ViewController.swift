//
//  ViewController.swift
//  CustomChannel
//
//  Created by 五月 on 2018/4/1.
//  Copyright © 2018年 孙凯峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func test(_ sender: Any) {
        let customChannelView = CustomchannelView()
        customChannelView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-77)
        customChannelView.show(inView: self.view)
        customChannelView.customchannelViewDismissBlock = {(models) in
            print("选择的标签 models--\(models)")
            for model in models {
             print("model.title ** \(model.title)")
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

