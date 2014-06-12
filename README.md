##SuggestiveTextField for iPad


* It's a `UITextfield` subclass that presents suggestions based on user input.
* Suggestions are being displayes in a `UIPopoverController`.

```objective-c
NSArray *suggestions = @[@"Warsaw",@"Paris",@"Zurich"];
//Initialize with frame or from xib, doesn't matter.
SuggestiveTextField *textField = [SuggestiveTextField alloc] initWithFrame:CGRectMake(0,0,100,30)];
//Remember to set suggestions.
[textField setSuggestions:suggestions];

//Optional
textField.shouldHideOnSelection = NO; //default is YES
[textField setPopoverSize:CGSizeMake(100,100)];
```
 
![screenshot](https://github.com/tetek/SuggestiveTextField/blob/master/screenshot.png?raw=true "Screenshot")

Simply copy SuggestiveTextField class to your project and use as in ViewController.h example.


###License
The code is licensed under [WTFPL](http://en.wikipedia.org/wiki/WTFPL)
