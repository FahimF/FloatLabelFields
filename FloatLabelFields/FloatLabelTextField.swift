//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//

import UIKit

@IBDesignable class FloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var titleLabel = UILabel()
	
	// MARK:- Properties
	override var accessibilityLabel:String! {
		get {
			if text.isEmpty {
				return titleLabel.text
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
			titleLabel.text = placeholder
			titleLabel.sizeToFit()
		}
	}
	
	override var attributedPlaceholder:NSAttributedString? {
		didSet {
			titleLabel.text = attributedPlaceholder?.string
			titleLabel.sizeToFit()
		}
	}
	
	var titleLabelFont:UIFont = UIFont.systemFontOfSize(12.0) {
		didSet {
			titleLabel.font = titleLabelFont
		}
	}
	
	@IBInspectable var placeholderYPadding:CGFloat = 0.0

	@IBInspectable var titleLabelYPadding:CGFloat = 0.0 {
		didSet {
			var r = titleLabel.frame
			r.origin.y = titleLabelYPadding
			titleLabel.frame = r
		}
	}
	
	@IBInspectable var titleLabelTextColour:UIColor = UIColor.grayColor() {
		didSet {
			if !isFirstResponder() {
				titleLabel.textColor = titleLabelTextColour
			}
		}
	}
	
	@IBInspectable var titleLabelActiveTextColour:UIColor! {
		didSet {
			if isFirstResponder() {
				titleLabel.textColor = titleLabelActiveTextColour
			}
		}
	}
	
	// MARK:- Init
	required init(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
//	override init() {
//		super.init()
//		setup()
//	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder()
		if isResp && !text.isEmpty {
			titleLabel.textColor = titleLabelActiveTextColour
		} else {
			titleLabel.textColor = titleLabelTextColour
		}
		// Should we show or hide the title label?
		if text.isEmpty {
			// Hide
			hideTitle(isResp)
		} else {
			// Show
			showTitle(isResp)
		}
	}
	
	override func textRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.textRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(titleLabel.font.lineHeight + placeholderYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return CGRectIntegral(r)
	}
	
	override func editingRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.editingRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(titleLabel.font.lineHeight + placeholderYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return CGRectIntegral(r)
	}
	
	override func clearButtonRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.clearButtonRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(titleLabel.font.lineHeight + placeholderYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return CGRectIntegral(r)
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	private func setup() {
		println("Setup called")
		borderStyle = UITextBorderStyle.None
		titleLabelActiveTextColour = tintColor
		// Set up title label
		titleLabel.alpha = 0.0
		titleLabel.font = titleLabelFont
		titleLabel.textColor = titleLabelTextColour
		println("The placeholder is: \(placeholder)")
		if let str = placeholder {
			if !str.isEmpty {
				titleLabel.text = str
				titleLabel.sizeToFit()
			}
		}
		self.addSubview(titleLabel)
	}

	private func maxTopInset()->CGFloat {
		return max(0, floor(bounds.size.height - font.lineHeight - 4.0))
	}
	
	private func setTitlePositionForTextAlignment() {
		var r = textRectForBounds(bounds)
		var x = r.origin.x
		if textAlignment == NSTextAlignment.Center {
			x = r.origin.x + (r.size.width * 0.5) - titleLabel.frame.size.width
		} else if textAlignment == NSTextAlignment.Right {
			x = r.origin.x + r.size.width - titleLabel.frame.size.width
		}
		titleLabel.frame = CGRect(x:x, y:titleLabel.frame.origin.y, width:titleLabel.frame.size.width, height:titleLabel.frame.size.height)
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseOut, animations:{
				// Animation
				self.titleLabel.alpha = 1.0
				var r = self.titleLabel.frame
				r.origin.y = self.titleLabelYPadding
				self.titleLabel.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseIn, animations:{
			// Animation
			self.titleLabel.alpha = 0.0
			var r = self.titleLabel.frame
			r.origin.y = self.titleLabel.font.lineHeight + self.placeholderYPadding
			self.titleLabel.frame = r
			}, completion:nil)
	}
}
