//
//  ViewController.swift
//  FloatLabelExample
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	@IBOutlet var vwName:FloatLabelTextField!
	@IBOutlet var vwAddress:FloatLabelTextView!
	@IBOutlet var vwHolder:UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Set font for placeholder of a FloatLabelTextField
		if let fnt = UIFont(name:"Zapfino", size:12) {
			vwName.titleFont = fnt
		}
		// Set font for placeholder of a FloatLabelTextView
		if let fnt = UIFont(name:"Zapfino", size:12) {
			vwAddress.titleFont = fnt
		}
		// Set up a FloatLabelTextField via code
		let fld = FloatLabelTextField(frame:vwHolder.bounds)
		fld.placeholder = "Comments"
		// Set font for place holder (only displays in title mode)
		if let fnt = UIFont(name:"Zapfino", size:12) {
			fld.titleFont = fnt
		}
		vwHolder.addSubview(fld)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

