# Dialect

A lightweight real-time over-the-air translations framework for iOS.

## Introduction

Dialect allows you to update your app's translations without having to submit app updates and going through the review process to simply change a translation key. 

While a few other libraries providing this functionality exist, those are created by localization platforms such as Phrase or Lokalise, are closed source and of course limited to only their platform to keep you locked in. Not only that, they limit the amount of requests to their API you can make to get you to upgrade to higher pricing plans. 

Dialect is **not** connected to any localization platform and allows you to download translation files from anywhere, so you can host them yourself and save money. This doesn't mean you can't use localization platforms such as Phrase or Lokalise anymore. Almost all such services allow you to download translations to a JSON file. Simply upload that file somewhere and get your OTA translations for free.

And unlike those libraries, Dialect supports real-time updates, meaning that when an updated translation is downloaded, the UI will update instantly! No need to restart the app, reload a screen or set texts all over again.

For an Android option I'd recommend [restring](https://github.com/B3nedikt/restring), which is easy to implement. While it does not have automatic UI updates, those can be triggered manually.


## Requirements

- Xcode 11+
- iOS 9 or above
- Swift 4.2 or above (when using Swift)


## Installation

Dialect does not use any external dependencies.

### Manually

1. Open Dialect.xcodeproj
2. Build the Dialect-iOS scheme
3. Copy the generated Dialect.framework file to your project

### Using CocoaPods

Add Dialect to your Podfile and run `pod install`.

```ruby
# Podfile
platform :ios, '9.0'

target 'YOUR_TARGET_NAME' do
    # Dynamic frameworks is supported but not required
    use_frameworks!
	
    pod 'Dialect', '1.0.0'
end
```

## Usage

### Objective-C

Import Dialect.h in the implementation files (or in a Prefix header):

```objectivec
#import <Dialect/Dialect.h>
```

### Swift

Import Dialect.h in the Objective-C Bridging Header:

```objectivec
// Bridging header
#import <Dialect/Dialect.h>
```

Import the Dialect module:

```swift
import Dialect
```

## Documentation

Dialect stores localized strings as key value dictionaries. Similar to how NSBundle supports multiple localization files by using table names, Dialect also supports multiple localization dictionaries, one for each table name. When you try to get a localized string from Dialect, it will first look for a value in its own localization dictionary. If no value was found (or no localization dictionary exists) it will fallback to the localized string from the bundle.

### Downloading localization dictionaries

Dialect contains a built in download method that allows you to easily download localization dictionaries. It expects a JSON object with string values as a response:

```json
{
    "some_key": "some_translation",
    "some_other_key": "another_translation"
}
```

To download, call any of the download methods on the Dialect class, pass either a URL or a URLRequest and optionally the table name for which you want to store it. Use the URLRequest if you need more control such as headers or cache control.

```swift
let url = URL.init(string: "https://myserver.com/translations.json")
Dialect.downloadLocalizationDictionary(with: url!, table: nil)
```

```objectivec
NSURL *url = [NSURL URLWithString:@"https://myserver.com/translations.json"];
[Dialect downloadLocalizationDictionaryWithURL:url table:nil];
```

If for some reason the default download methods are not sufficient, you can handle the download yourself and set the localization dictionary manually. By default, downloaded localization dictionaries are stored on disk. The next time your app launches Dialect will automatically load the latest downloaded localization dictionaries. This way your app will always use its most up-to-date translations. But of course there are several additional methods that allow you to get, set or remove localization dictionaries, giving you full control.

```swift
// Some custom download implementation here
// Set a localization dictionary
Dialect.setLocalization(dictionary: dictionary, table: nil, update: true, storeOnDisk: true)

// Remove a localization dictionary
Dialect.removeLocalizationDictionary(table: nil, update: true, removeFromDisk: true)

// Get a localization dictionary
Dialect.localizationDictionary(forTable: nil)
```

```objectivec
// Some custom download implementation here
// Set a localization dictionary
[Dialect setLocalizationDictionary:dictionary table:nil update:YES storeOnDisk:YES];

// Remove a localization dictionary
[Dialect removeLocalizationDictionaryForTable:nil update:YES removeFromDisk:YES];

// Get a localization dictionary
[Dialect localizationDictionaryForTable:nil];
```

### Getting a localized string

Getting a localized string is easy, just call the stringFor method on the Dialect class to get the value for that key. The example below will get a localized string from the default localization dictionary and fallback to the default strings file if necessary.

```swift
label.text = Dialect.stringFor(key: "some_key")
```

```objectivec
label.text = [Dialect stringFor:@"some_key"];
```

There a several variations of this method: allowing you to set a custom table name (file), a different bundle and/or a default value. There is also an optional parameter which allows you to pass substrings that should be replaced, making formatted strings a lot easier.

```swift
let value1 = "Value1"
let value2 = "Value2"
Dialect.stringFor(key: "some_key", table: "my_table", bundle:.main, defaultValue: "", replace: [
    "{value1_to_replace}": value1,
    "{value2_to_replace}": value2,
])
```

```objectivec
NSString *value1 = @"Value1";
NSString *value2 = @"Value2";
[Dialect stringFor:@"some_key" table:@"my_table" bundle:NSBundle.mainBundle defaultValue:@"" replace:@{
    @"{value1_to_replace}": value1,
    @"{value2_to_replace}": value2,
}];
```

If you're currently using `NSLocalizedString` and want to implement OTA translations quickly, there is a `DIALocalizedString` method available which uses the exact same parameters. Simply find-replace "NSLocalizedString" by "DIALocalizedString" and you're good to go.

```swift
// label.text = NSLocalizedString("some_key", comment: "")
label.text = DIALocalizedString("some_key", comment: "")
```

```objectivec
// label.text = NSLocalizedString(@"some_key", @"");
label.text = DIALocalizedString(@"some_key", @"");
```

### Real-time Automatic Updates

Dialect supports real-time automatic updates of localized objects. This means that you can set a localization key on any object (not limited to UI). Should new translations be downloaded and that key has changed, the object will receive a callback allowing it to update itself for the new localized string. This means you can simply set a localization key to an object and forget about it. If new translations are downloaded the UI will update itself automatically!

Simply call the the setLocalization method, pass a key and an onUpdate closure/block. Every time the translation for that key is updated, the closure/block will be executed. You can call this method on any object, including non-UI objects. The onUpdate closure/block will always pass the key, optionally the table name and the object itself.

```swift
label.setLocalization(key: "some_key") { (localizationKey, table, label) in
    label.text = Dialect.stringFor(key: localizationKey)
}
```

```objectivec
[label setLocalizationKey:@"some_key" onUpdate:^(NSString *localizationKey, NSString *table, UILabel *label) {
    label.text = [Dialect stringFor:localizationKey];
}];
```

Certain UI controls have additional convenience methods that do the above implementation without having to use closures/blocks. You can also combine these convenience methods with tables and replacements.

```swift
// This will set the localized string for the key and automatically update the label text should the value for that key change
label.setTextForLocalization(key: "some_key", replace: [
    "{value_to_replace}": someValue
])

// This will set the localized string for the key and automatically update the button title should the value for that key change
button.setTitleForLocalization(key: "some_key", state: .normal)
```

```objectivec
// This will set the localized string for the key and automatically update the label text should the value for that key change
[label setTextForLocalizationKey:@"some_key" replace:@{
    @"{value_to_replace}": someValue
}];

// This will set the localized string for the key and automatically update the button title should the value for that key change
[button setTitleForLocalizationKey:@"some_key" forState:UIControlStateNormal];
```

## License

Dialect is released under an [MIT License](https://opensource.org/licenses/MIT). See LICENSE for details.
