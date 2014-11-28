//
//  FloatLabelTextView.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//

import UIKit

@IBDesignable class FloatLabelTextView: UITextView {
	let animationDuration = 0.3
	let placeholderTextColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.65)
	private var titleLabel = UILabel()
	private var placeholderLabel = UILabel()
	private var initialTopInset:CGFloat = 0
	
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
	
	var titleLabelFont:UIFont = UIFont.systemFontOfSize(12.0) {
		didSet {
			titleLabel.font = titleLabelFont
		}
	}
	
	@IBInspectable var placeholder:String = "" {
		didSet {
			titleLabel.text = placeholder
			titleLabel.sizeToFit()
			var r = titleLabel.frame
			r.size.width = frame.size.width
			titleLabel.frame = r
			placeholderLabel.text = placeholder
			placeholderLabel.sizeToFit()
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

	deinit {
		let nc = NSNotificationCenter.defaultCenter()
		nc.removeObserver(self, name:UITextViewTextDidChangeNotification, object:self)
		nc.removeObserver(self, name:UITextViewTextDidBeginEditingNotification, object:self)
		nc.removeObserver(self, name:UITextViewTextDidEndEditingNotification, object:self)
	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		adjustTopTextInset()
		placeholderLabel.alpha = text.isEmpty ? 1.0 : 0.0
		let r = textRect()
		placeholderLabel.frame = CGRect(x:r.origin.x, y:r.origin.y, width:placeholderLabel.frame.size.width, height:placeholderLabel.frame.size.height)
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
	
	// MARK:- Private Methods
	private func setup() {
		println("Setup called")
		initialTopInset = textContainerInset.top
		textContainer.lineFragmentPadding = 0.0
		titleLabelActiveTextColour = tintColor
		// Placeholder label
		placeholderLabel.font = font
		placeholderLabel.text = placeholder
		placeholderLabel.numberOfLines = 0
		placeholderLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
		placeholderLabel.backgroundColor = UIColor.clearColor()
		placeholderLabel.textColor = placeholderTextColor
		insertSubview(placeholderLabel, atIndex:0)
		// Set up title label
		titleLabel.alpha = 0.0
		titleLabel.font = titleLabelFont
		titleLabel.textColor = titleLabelTextColour
		titleLabel.backgroundColor = backgroundColor
		println("The textview placeholder is: \(placeholder)")
		if !placeholder.isEmpty {
			titleLabel.text = placeholder
			titleLabel.sizeToFit()
		}
		self.addSubview(titleLabel)
		// Observers
		let nc = NSNotificationCenter.defaultCenter()
		nc.addObserver(self, selector:"layoutSubviews", name:UITextViewTextDidChangeNotification, object:self)
		nc.addObserver(self, selector:"layoutSubviews", name:UITextViewTextDidBeginEditingNotification, object:self)
		nc.addObserver(self, selector:"layoutSubviews", name:UITextViewTextDidEndEditingNotification, object:self)
	}

	private func adjustTopTextInset() {
		var inset = textContainerInset
		inset.top = initialTopInset + titleLabel.font.lineHeight + placeholderYPadding
		textContainerInset = inset
	}
	
	private func textRect()->CGRect {
		var r = UIEdgeInsetsInsetRect(bounds, contentInset)
		r.origin.x += textContainer.lineFragmentPadding
		r.origin.y += textContainerInset.top
		return CGRectIntegral(r)
	}
	
	private func setTitlePositionForTextAlignment() {
		var titleLabelX = textRect().origin.x
		var placeholderX = titleLabelX
		if textAlignment == NSTextAlignment.Center {
			titleLabelX = (frame.size.width - titleLabel.frame.size.width) * 0.5
			placeholderX = (frame.size.width - placeholderLabel.frame.size.width) * 0.5
		} else if textAlignment == NSTextAlignment.Right {
			titleLabelX = frame.size.width - titleLabel.frame.size.width
			placeholderX = frame.size.width - placeholderLabel.frame.size.width
		}
		var r = titleLabel.frame
		r.origin.x = titleLabelX
		titleLabel.frame = r
		r = placeholderLabel.frame
		r.origin.x = placeholderX
		placeholderLabel.frame = r
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseOut, animations:{
			// Animation
			self.titleLabel.alpha = 1.0
			var r = self.titleLabel.frame
			r.origin.y = self.titleLabelYPadding + self.contentOffset.y
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
