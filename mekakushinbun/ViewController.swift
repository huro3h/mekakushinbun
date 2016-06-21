//  ViewController.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIScrollViewDelegate, NSXMLParserDelegate {

	@IBOutlet weak var listTableView: UITableView!
	
	var newsTopicTypes: [String] = ["http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/rss.xml&num=15","http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/world/rss.xml&num=15","http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/economy/rss.xml&num=15","http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/science/rss.xml&num=15"]
	
	var articles: [[String: AnyObject?]] = [] // 記事を入れるプロパティを定義
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "newsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
		getArticles()
		

		
	}

	override func viewWillAppear(animated: Bool) {
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("newsCell")! as! newsTableViewCell
		let article = articles[indexPath.row] // 行数番目の記事を取得

		cell.subjectLabel?.text = article["title"]! as? String
		cell.dateTimeLabel?.text = article["publishedDate"]! as? String
		
		return cell
	}
	
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
	}
	
	
	// 自作関数置き場
	// NSDate->String型に変換
//	func dateString(date: NSDate) -> String {
//		let dateFormatter = NSDateFormatter()
//		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
//		dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//		// dateFormatter.dateFormat = "M/d"
//		let dateString: String = dateFormatter.stringFromDate(date)
//		return dateString
//	}
	
	// String->NSDate型に変換
	func stringDate(date: String) -> NSDate {
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "US_en")
		formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
		let date = formatter.dateFromString("Thu, 04 Sep 2014 10:50:12 +0000")
		return date!
	}

	
	func getArticles() {
		
		for a in newsTopicTypes {
			Alamofire.request(.GET, "\(a)") // APIへリクエストを送信
			.responseJSON { response in
				// ここに処理を記述していく
				guard let object = response.result.value else {
					return
				
				}
					let json = JSON(object)
					json.forEach { (key, json) in
						if(key == "responseData") {
							json.forEach { (key, json) in
								json.forEach { (key, jsonArray) in
									if(key == "entries") {
										jsonArray.forEach{ (_, json) in
											
											// 上で作った関数(stringDate)でNSDate型に変換
											var articleDate = self.stringDate(json["publishedDate"].string!)
											
											
											let article: [String: AnyObject?] = [
												"title": json["title"].string,
												"publishedDate" : json["publishedDate"].string
											]
											self.articles.append(article)
										}
									}
								}
							}
						}
					}
				
				// print(self.articles)
				// 非同期通信の為、上のほうで１回目カウントした際は空振りしている
				// ので、読み直しさせることで正常に表示させる
				self.listTableView.reloadData()
			}
		}
	}

//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
}

