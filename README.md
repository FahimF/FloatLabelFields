FloatLabelFields
================
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg)](https://developer.apple.com/iphone/index.action)
[![License](http://img.shields.io/badge/license-MIT-orange.svg)](http://mit-license.org)
[![Issues](http://img.shields.io/github/issues/FahimF/FloatLabelFields.svg)](https://github.com/FahimF/FloatLabelFields/issues?state=open)

- [Overview](#overview)
- [Installation](#installation)
	- [Via Interface Builder](#via-interface-builder)
	- [Via Code](#via-code)
- [Credits](#credits)
- [Additional References](#references)
- [Questions](#questions)

## Overview ##

`FloatLabelFields` is the Swift implementation of a UX pattern that has come to be known as the **"Float Label Pattern"**. The initial Objective-C implementation of this pattern can be found on Github as [JVFloatLabeledTextField](https://github.com/jverdi/JVFloatLabeledTextField).

Due to space constraints on mobile devices, it is common to rely solely on placeholders as a means to label fields.
This presents a UX problem, in that, once the user begins to fill out a form, no labels are present.

This UI component library, which includes both a `UITextField` and `UITextView` subclass, aims to improve the user experience by having placeholders transition into floating labels that hover above the fields after they are populated with text.

Credits for the concept to Matt D. Smith ([@mds](http://www.twitter.com/mds)), and his [original design](http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users):

![Matt D. Smith's Design](https://cloud.githubusercontent.com/assets/181110/5260534/f64efed4-7a4a-11e4-9b62-2cc1e009ee95.gif)

Since the code is Swift-based, do note that this version of the component swill only work on iOS 7.x+.

## Installation ##

You can install the `FloatLabelField` components two ways:

### Via Interface Builder ###

Just add a `UITextField` or `UITextView` to your storyboard and then set the custom class for the control to either `FloatLabelTextField` or `FloatLabelTextView`.

![Custom Class](https://cloud.githubusercontent.com/assets/181110/5260533/f64a23fa-7a4a-11e4-8505-563a8e7ad300.png)

**Note:** Sometimes, you might have to set the Module explicitly instead of letting Xcode set it implicitly too before it works.

Next, switch to the Attributes Inspector tab and set the necessary attributes to configure your text field or text view. The *Placeholder* attribute (or *Hint* in the case of a `UITextView`) defines the actual title which will be used for your field. 

![Properties](https://cloud.githubusercontent.com/assets/181110/5260537/f652f66a-7a4a-11e4-80ee-2645e3fe3e80.png)

The other values such as *Hint Y Padding*, *Title Y Padding*, *Title Text Colour* etc. define how the title will look.

If everything is set up correctly, you'll see the title display on Interface Builder after you've configured the field.

![Final Result](https://cloud.githubusercontent.com/assets/181110/5260535/f651ffb2-7a4a-11e4-8703-6df7959e0bc4.png)

### Via Code ###

Using `FloatLabelFields` via code works the same as you would do to set up a `UITextField` or `UITextView` instance. Simply create an instance of the class, set the necessary properties, and then add the field to your view.

```swift
let fld = FloatLabelTextField(frame:vwHolder.bounds)
fld.placeholder = "Comments"
vwHolder.addSubview(fld)
```

## Credits ##
- This project derives inspiration from [jverdi](https://github.com/jverdi)'s Objective-C [JVFloatLabeledTextField](https://github.com/jverdi/JVFloatLabeledTextField) project.

## Additional References ##

[How the Float Label Pattern Started](http://mattdsmith.com/float-label-pattern/) - Matt D. Smith  
[Float Label Pattern](http://bradfrostweb.com/blog/post/float-label-pattern/) - Brad Frost  
[Material Design - Floating Labels](http://www.google.com/design/spec/components/text-fields.html#text-fields-floating-labels) - Google

## Questions? ##

* E-mail: fahimf (at) gmail (dot) com
* Web: [http://rooksoft.sg/](http://rooksoft.sg/)
* Twitter: [http://twitter.com/FahimFarook](http://twitter.com/FahimFarook) 


