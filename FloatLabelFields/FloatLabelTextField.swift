//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2015 RookSoft Ltd & Myles Ringle. All rights reserved.
//
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//
//
//  Updated for Swift 2.0 by Myles Ringle on 15/10/15.
//

import UIKit

@IBDesignable class FloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var title = UILabel()
	
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if text!.isEmpty {
				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	
	override var placeholder:String? {
		didSet {
			title.text = placeholder
			title.sizeToFit()
		}
	}
	
	override var attributedPlaceholder:AttributedString? {
		didSet {
			title.text = attributedPlaceholder?.string
			title.sizeToFit()
		}
	}
	
	var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
		didSet {
			title.font = titleFont
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour:UIColor = UIColor.gray() {
		didSet {
			if !isFirstResponder() {
				title.textColor = titleTextColour
			}
		}
	}
	
	@IBInspectable var titleActiveTextColour:UIColor! {
		didSet {
			if isFirstResponder() {
				title.textColor = titleActiveTextColour
			}
		}
	}
	
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)!
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder()
		if isResp && !text!.isEmpty {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
		}
		// Should we show or hide the title label?
		if text!.isEmpty {
			// Hide
			hideTitle(isResp)
		} else {
			// Show
			showTitle(isResp)
		}
	}
	
	override func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	private func setup() {
		borderStyle = UITextBorderStyle.none
		titleActiveTextColour = tintColor
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		if let str = placeholder {
			if !str.isEmpty {
				title.text = str
				title.sizeToFit()
			}
		}
		self.addSubview(title)
	}

	private func maxTopInset()->CGFloat {
		return max(0, floor(bounds.size.height - font!.lineHeight - 4.0))
	}
	
	private func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		var x = r.origin.x
		var width = title.frame.size.width
		if textAlignment == NSTextAlignment.center {
			width = self.frame.size.width
			title.textAlignment = NSTextAlignment.center
		} else if textAlignment == NSTextAlignment.right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:width, height:title.frame.size.height)
	}
	
	private func showTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [.beginFromCurrentState, .curveEaseOut], animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [.beginFromCurrentState, .curveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
}
