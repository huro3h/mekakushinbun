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

	var articles: [[String: String?]] = [] // 記事を入れるプロパティを定義
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "newsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
		getArticles()
		
	}

	override func viewWillAppear(animated: Bool) {
//		print("news一覧画面表示")
		
//		listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("newsCell")! as! newsTableViewCell
		let article = articles[indexPath.row] // 行数番目の記事を取得
		print("なにがはいってるか表示\(article)")
		cell.subjectLabel?.text = article["title"]!
		cell.dateTimeLabel.text = article["publishedDate"]!
//		cell.detailLabel.text = "詳細\([indexPath.row])"
//		cell.sourceLabel.text = "記事元\([indexPath.row])"
		return cell
	}
	
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
	
	func getArticles() {
		Alamofire.request(.GET, "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/rss.xml&num=8") // APIへリクエストを送信
		.responseJSON { response in
			// ここに処理を記述していく
			guard let object = response.result.value else {
				return
			//print(response.result.value)
			}
				let json = JSON(object)
				json.forEach { (key, json) in
					if(key == "responseData") {
						json.forEach { (key, json) in
							json.forEach { (key, jsonArray) in
								if(key == "entries") {
									jsonArray.forEach{ (_, json) in
										let article: [String: String?] = [
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
			
			print(self.articles)
			// 非同期通信の為、上のほうで１回目カウントした際は空振りしている
			// ので、読み直しさせることで正常に表示させる
			self.listTableView.reloadData()
		}
	}
	
	

//http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=[http://news.yahoo.co.jp/pickup/rss.xml]&num=[10]
//http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=[ここにRSSフィードのURL]&num=[取得する数]
	
//http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/rss.xml&num=10


//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
}

