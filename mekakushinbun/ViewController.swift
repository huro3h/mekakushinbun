//  ViewController.swift
//  mekakushinbun
//  Created by satoshiii on 2016/06/15.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate {

	@IBOutlet weak var listTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "feeList", bundle: nil), forCellReuseIdentifier: "feeList")
	}
	
	override func viewWillAppear(animated: Bool) {
		print("news一覧画面表示")
	}

	func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10 // 行数をデータの数でカウント
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("newsCell")! as! newsTableViewCell
		return cell
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
	}

	
	
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
}

