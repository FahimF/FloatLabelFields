//
//  ViewController.swift
//  FloatLabelExample
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	@IBOutlet var vwHolder:UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Set up a FloatLabelTextField via code
		let fld = FloatLabelTextField(frame:vwHolder.bounds)
		fld.placeholder = "Comments"
		vwHolder.addSubview(fld)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

