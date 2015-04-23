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

    // MARK:- Properties

    let animationDuration = 0.3
    var title = UILabel()

    /**
        Quando qualquer parâmetro é alterado, caso este atributo esteja marcado como TRUE, esta alteração será replicada para as demais linhas (Left,Right,Top,Bottom)
        @param Boolean. TRUE = replicate changes to all lines
    */
    @IBInspectable var allLinesAreEquals:Bool = true { didSet { setNeedsDisplay() } }
    @IBInspectable var drawBottomLine:Bool = false  { didSet { setNeedsDisplay() } }
    @IBInspectable var drawLeftLine:Bool = false  { didSet { setNeedsDisplay() } }
    @IBInspectable var drawRightLine:Bool = false  { didSet { setNeedsDisplay() } }
    @IBInspectable var drawTopLine:Bool = false  { didSet { setNeedsDisplay() } }
    @IBInspectable var lineThikness:CGFloat = 1.0  { didSet { setNeedsDisplay() } }
    @IBInspectable var lineColor:UIColor = UIColor.grayColor()  { didSet { setNeedsDisplay() } }
	
	override var accessibilityLabel:String! {
		get {
			if text.isEmpty {
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
	
	override var attributedPlaceholder:NSAttributedString? {
		didSet {
			title.text = attributedPlaceholder?.string
			title.sizeToFit()
		}
	}
	
	@IBInspectable var titleFont:UIFont = UIFont.systemFontOfSize(12.0) {
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
	
	@IBInspectable var titleTextColour:UIColor = UIColor.grayColor() {
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
	required init(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
    /**
        By: Julio Fabio Chagas
        This override was made to draw lines around all 4 corners.
        I used drawRect instead of CGContext pattern to be able to se draws in Interface Builder
    */
    override func drawRect(rect: CGRect) {
        
        if(self.drawBottomLine || drawTopLine || drawLeftLine || drawRightLine) {
            drawLines()
        }
        
    }

    override func layoutSubviews() {
		super.layoutSubviews()
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
	
	override func textRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.textRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 3.0, 0.0, 3.0))
		}
		return CGRectIntegral(r)
	}
	
	override func editingRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.editingRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 3.0, 0.0, 3.0))
		}
		return CGRectIntegral(r)
	}
	
	override func clearButtonRectForBounds(bounds:CGRect) -> CGRect {
		var r = super.clearButtonRectForBounds(bounds)
		if !text.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return CGRectIntegral(r)
	}
		
	// MARK:- Private Methods
	private func setup() {
		borderStyle = UITextBorderStyle.None
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
        println("drawBottomLine \(self.drawBottomLine)")
	}
    
    /**
        This method checks when specific lines has to be draw based on parameters: drawBottomLine, drawLeftLine, drawTopLine, drawRightLine
    */
    private func drawLines() {
        let graphicsW = self.bounds.size.width
        let graphicsH = self.bounds.size.height
        let opaque = false
        let scale:CGFloat = 0
        var lineToDraw = UIBezierPath()

        if(drawBottomLine) {
            lineToDraw = UIBezierPath(rect: CGRect(x: 0.0, y: graphicsH, width: graphicsW, height: 1))
            drawSpecificLine(lineToDraw)
        }
        if(drawLeftLine) {
            lineToDraw = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0 , width: 1, height: graphicsH))
            drawSpecificLine(lineToDraw)
        }

        if(drawRightLine) {
            lineToDraw = UIBezierPath(rect: CGRect(x: graphicsW, y: 0.0 , width: 1, height: graphicsH))
            drawSpecificLine(lineToDraw)
        }

        if(drawTopLine) {
            lineToDraw = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0 , width: graphicsW, height: 1))
            drawSpecificLine(lineToDraw)
        }
        
    }
    
    /**
        This is the method responsible to draw the line seeting all design attributes
    */
    private func drawSpecificLine(line: UIBezierPath) {
        line.lineWidth = lineThikness
        lineColor.set()
        line.stroke()
    }
    
	private func maxTopInset()->CGFloat {
		return max(0, floor(bounds.size.height - font.lineHeight - 4.0))
	}
	
	private func setTitlePositionForTextAlignment() {
		var r = textRectForBounds(bounds)
		var x = r.origin.x
		if textAlignment == NSTextAlignment.Center {
			x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
		} else if textAlignment == NSTextAlignment.Right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseOut, animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animateWithDuration(dur, delay:0, options: UIViewAnimationOptions.BeginFromCurrentState|UIViewAnimationOptions.CurveEaseIn, animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
}
