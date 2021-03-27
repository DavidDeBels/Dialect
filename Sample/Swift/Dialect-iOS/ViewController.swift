//
//  ViewController.swift
//  Dialect-iOS
//
//  Created by David De Bels on 27/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

import UIKit
import Dialect

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singleLineLabel: UILabel!
    @IBOutlet weak var singleLineLabel2: UILabel!
    @IBOutlet weak var multiLineLabel: UILabel!
    @IBOutlet weak var multiLineLabel2: UILabel!
    @IBOutlet weak var textFieldLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let shortBundleVersion = Bundle.main.object(forInfoDictionaryKey:"CFBundleShortVersionString") as! String
        let language = "Swift"
        
        
        // Set the localization key and do the action in the onUpdate closure. Every time the translation for the key updates, the closure will be executed.
        titleLabel.setLocalization(key: "home_title") { (key, tbl, label) in
            label.text = Dialect.stringFor(key: key)
        }
        
        // Easily find replace values in the translation string
        singleLineLabel.setLocalization(key: "home_subtitle") { (key, tbl, label) in
            label.text = Dialect.stringFor(key: key, replace: [
                "{version}": shortBundleVersion
            ])
        }
        
        // Certain classes such as labels have convenience functions that don't require the closure but simply let you set the key and on update the text will be updated automatically
        multiLineLabel.setTextForLocalization(key: "home_text1")
        
        // These also works with replacements, custom tables or bundles
        multiLineLabel2.setTextForLocalization(key: "home_text2", replace: [
            "{version}": shortBundleVersion
        ])
        
        // If you don't require real-time updates, you can of course just set the text manually
        textFieldLabel.text = Dialect.stringFor(key: "home_textfield_title")
        
        textField.setLocalization(key: "home_textfield_placeholder") { (key, tbl, textField) in
            textField.placeholder = Dialect.stringFor(key: key)
        }
        
        // Convenience methods also exist for buttons
        button.setTitleForLocalization(key: "home_button", state: .normal)
        
        // Every object can be localized, even non UI objects. Just set the localization key and do whatever custol logic you want in the closure. The closure will always pass the key, the table and the object it was set on.
        navigationItem.setLocalization(key: "home_navbar_title") { (key, tbl, object) in
            (object as! UINavigationItem).title = Dialect.stringFor(key: key, replace: [
                "{language}": language
            ])
        }
   
        // If you're currently using NSLocalizedString, you can easily migrate by simply replacing to DIALocalizedString
        // You won't get auto updates this way, but the translation will be updated the next time the text is set
        // singleLineLabel2.text = NSLocalizedString("home_info", comment: "")
        singleLineLabel2.text = DIALocalizedString("home_info", comment: "")
    }

    @IBAction func download(_ sender: UIButton) {
        // Download from a URL
        let url = URL.init(string: "https://lib-ios-dialect.s3-eu-west-1.amazonaws.com/dialect_translations.json")
        Dialect.downloadLocalizationDictionary(with: url!, table: nil)
    
        // You can also use a URL Request for more control, for example if there's authentication
        // var request = URLRequest.init(url: url!)
        // request.httpMethod = "GET"
        // request.url = url!;
        // Dialect.downloadLocalizationDictionary(with: request, table: nil)
        
        // Or manage the download yourself and set it manually
        // var downloadedDict = ...
        // Dialect.setLocalization(dictionary: downloadedDict, table: nil, update: true, storeOnDisk: true)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        // Reset back to using the local strings file
        Dialect.removeLocalizationDictionary(table: nil, update: true, removeFromDisk: true)
    }

}

