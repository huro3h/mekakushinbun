//  detailController.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import Ji

class detailController: UIViewController {

	@IBOutlet weak var myWebView: UIWebView!
	@IBOutlet weak var mytextView: UITextView!
	@IBOutlet weak var webtextSwitch: UISegmentedControl!

	var selectedIndex = -1
	var newsUrl: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		print(newsUrl)
    }
	
	override func viewWillAppear(animated: Bool) {
		print("詳細画面表示\(selectedIndex)")
		print(newsUrl)
		let myURL = NSURL(string: newsUrl)
		let myURLReq = NSURLRequest(URL: myURL!)
		myWebView.loadRequest(myURLReq)
		
		let url = NSURL(string: newsUrl)
		let jiDoc = Ji(htmlURL: url!)
		let bodyNode = jiDoc?.xPath("//div")!.first!
		
		let h2 = jiDoc?.xPath("//h2")!.first!
		let hbody = bodyNode!.xPath("/div[@class='headlineTxt']/p[@class='hbody']").first
//		print(h2)
//		print(bodyNode)
		print(hbody)
	}
	
	@IBAction func pushSegmented(sender: UISegmentedControl) {
		
		switch sender.selectedSegmentIndex {
			case 0:
				mytextView.hidden = true
				myWebView.hidden = false
			case 1:
				mytextView.hidden = false
				myWebView.hidden = true
			default:
				print("該当無し")
		}
	}


	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
}
