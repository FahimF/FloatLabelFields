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
	private var isIB = false
	private var title = UILabel()
	private var hintLabel = UILabel()
	private var initialTopInset:CGFloat = 0
	
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if text.isEmpty {
				return title.text!
			} else {
				return text
			}
		}
		set {
		}
	}
	
	var titleFont:UIFont = UIFont.systemFontOfSize(12.0) {
		didSet {
			title.font = titleFont
		}
	}
	
	@IBInspectable var hint:String = "" {
		didSet {
			title.text = hint
			title.sizeToFit()
			var r = title.frame
			r.size.width = frame.size.width
			title.frame = r
			hintLabel.text = hint
			hintLabel.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0 {
		didSet {
			adjustTopTextInset()
		}
	}
	
	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour:UIColor = UIColor.grayColor() {
		didSet {
			if !isFirstResponder() {
				title.textColor = titleTextColour
			}
		}
	}
	
	@IBInspectable var titleActiveTextColour:UIColor = UIColor.cyanColor() {
		didSet {
			if isFirstResponder() {
				title.textColor = titleActiveTextColour
			}
		}
	}
	
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect, textContainer:NSTextContainer?) {
		super.init(frame:frame, textContainer:textContainer)
		setup()
	}
	
	deinit {
		if !isIB {
			let nc = NSNotificationCenter.defaultCenter()
			nc.removeObserver(self, name:UITextViewTextDidChangeNotification, object:self)
			nc.removeObserver(self, name:UITextViewTextDidBeginEditingNotification, object:self)
			nc.removeObserver(self, name:UITextViewTextDidEndEditingNotification, object:self)
		}
	}
	
	// MARK:- Overrides
	override func prepareForInterfaceBuilder() {
		isIB = true
		setup()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		adjustTopTextInset()
		hintLabel.alpha = text.isEmpty ? 1.0 : 0.0
		let r = textRect()
		hintLabel.frame = CGRect(x:r.origin.x, y:r.origin.y, width:hintLabel.frame.size.width, height:hintLabel.frame.size.height)
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder()
		if isResp && !text.isEmpty {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
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
		initialTopInset = textContainerInset.top
		textContainer.lineFragmentPadding = 0.0
		titleActiveTextColour = tintColor
		// Placeholder label
		hintLabel.font = font
		hintLabel.text = hint
		hintLabel.numberOfLines = 0
		hintLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
		hintLabel.backgroundColor = UIColor.clearColor()
		hintLabel.textColor = placeholderTextColor
		insertSubview(hintLabel, atIndex:0)
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		title.backgroundColor = backgroundColor
		if !hint.isEmpty {
			title.text = hint
			title.sizeToFit()
		}
		self.addSubview(title)
		// Observers
		if !isIB {
			let nc = NSNotificationCenter.defaultCenter()
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:UITextViewTextDidChangeNotification, object:self)
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:UITextViewTextDidBeginEditingNotification, object:self)
			nc.addObserver(self, selector:#selector(UIView.layoutSubviews), name:UITextViewTextDidEndEditingNotification, object:self)
		}
	}

	private func adjustTopTextInset() {
		var inset = textContainerInset
		inset.top = initialTopInset + title.font.lineHeight + hintYPadding
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
			titleLabelX = (frame.size.width - title.frame.size.width) * 0.5
			placeholderX = (frame.size.width - hintLabel.frame.size.width) * 0.5
		} else if textAlignment == NSTextAlignment.Right {
			titleLabelX = frame.size.width - title.frame.size.width
			placeholderX = frame.size.width - hintLabel.frame.size.width
		}
		var r = title.frame
		r.origin.x = titleLabelX
		title.frame = r
		r = hintLabel.frame
		r.origin.x = placeholderX
		hintLabel.frame = r
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations:{
			// Animation
			self.title.alpha = 1.0
			var r = self.title.frame
			r.origin.y = self.titleYPadding + self.contentOffset.y
			self.title.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
}
