//  ViewController.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIScrollViewDelegate {

	@IBOutlet weak var listTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "newsCell", bundle: nil), forCellReuseIdentifier: "newsCell")
		
		Alamofire.request(.GET, "http://news.yahoo.co.jp/pickup/rss.xml", parameters: nil)
			.response { (request, response, data, error) in
				print ("requestの中身\(request)")
				print("responseの中身\(response)")
				print("dataの中身\(data)")
				print("errorの中身\(error)")
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		print("news一覧画面表示")
		listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

//	func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//		return true
//	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10 // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("newsCell")! as! newsTableViewCell
		
		cell.subjectLabel.text = "題名\([indexPath.row])"
		cell.detailLabel.text = "詳細\([indexPath.row])"
		cell.dateTimeLabel.text = "日時\([indexPath.row])"
		cell.sourceLabel.text = "記事元\([indexPath.row])"
		return cell
	}
	
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
	}
	
	
	// 自作関数置き場
	// NSDate->String型に変換
	func dateString(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
		// dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		dateFormatter.dateFormat = "M/d"
		let dateString: String = dateFormatter.stringFromDate(date)
		return dateString
	}
	
	
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
}

