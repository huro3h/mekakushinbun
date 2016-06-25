//  ViewController.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import Ji

class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIScrollViewDelegate, NSXMLParserDelegate {

	@IBOutlet weak var listTableView: UITableView!
	
	var selectedIndex = -1
	
	var newsTopicTypes: [String] =
		["http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/rss.xml&num=15",
		 "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/world/rss.xml&num=15",
		 "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/economy/rss.xml&num=15",
		 "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/science/rss.xml&num=15"]
	
	var newsCategoryNames: [String] = ["トップ","国際","経済","サイエンス"]
	var articles: [[String: AnyObject?]] = [] // 記事を入れるプロパティを定義

	override func viewDidLoad() {
		super.viewDidLoad()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "newsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
		getArticles()
	}
	
	
//	override func viewWillAppear(animated: Bool) {
//	}
	

	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("newsCell")! as! newsTableViewCell
		let article = articles[indexPath.row] // 行数番目の記事を取得
		cell.subjectLabel?.text = article["title"]! as? String
		cell.dateTimeLabel?.text = dateString(article["publishedDate"]! as! NSDate)
		cell.categoryLabel?.text = article["category"]! as? String
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		print("\(indexPath.row)行目を選択")
		selectedIndex = indexPath.row
		performSegueWithIdentifier("detailSegue", sender: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if (segue.identifier == "detailSegue") {
			let detailVC = segue.destinationViewController as! detailController
			detailVC.selectedIndex = selectedIndex
			detailVC.newsUrl = articles[selectedIndex]["link"] as! String
		}else if (segue.identifier == "menuSegue") {
			
		}else {
			// どちらでもない遷移
		}
		
	}
	
	
	
	// 自作関数置き場
	// NSDate->String型に変換
	func dateString(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
		dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		// dateFormatter.dateFormat = "M/d"
		let dateString: String = dateFormatter.stringFromDate(date)
		return dateString
	}
	
	// String->NSDate型に変換
	func stringDate(strdate: String) -> NSDate {
		let formatter = NSDateFormatter()
		formatter.locale = NSLocale(localeIdentifier: "US_en")
		formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
		let date = formatter.dateFromString(strdate)
		return date!
	}

	
	func getArticles() {
		
		var newsCount: Int = 1
		let newsCategoryNamesCounter: Int = newsCategoryNames.count
		
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
											let articleDate = self.stringDate(json["publishedDate"].string!)
											
											let article: [String: AnyObject?] = [
												"title": json["title"].string,
												"publishedDate" : articleDate,
												"link" : json["link"].string,
												"category" : self.newsCategoryNames[newsCount-1],
											]
											self.articles.append(article)
											
										}
									}
								}
							}
						}
					}
				// 非同期通信の為、上のほうで１回目カウントした際は空振りしている
				// ので、読み直しさせることで正常に表示させる
				self.listTableView.reloadData()
				
				if (newsCount == newsCategoryNamesCounter){
					self.articles = self.articles.sort{($0["publishedDate"] as! NSDate).compare($1["publishedDate"] as! NSDate) == NSComparisonResult.OrderedDescending
					}
					// print(self.articles)
				}
				newsCount++
			}
		}
	}

//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
}

