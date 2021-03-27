//
//  ViewController.m
//  Dialect-iOS
//
//  Created by David De Bels on 27/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <Dialect/Dialect.h>

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *singleLineLabel;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *singleLineLabel2;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *multiLineLabel;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *multiLineLabel2;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UILabel *textFieldLabel;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UITextField *textField;
@property (nonatomic, weak, readwrite, nullable) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *shortBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *language = @"ObjC";
    
    
    // Set the localization key and do the action in the onUpdate block. Every time the translation for the key updates, the block will be executed.
    [self.titleLabel setLocalizationKey:@"home_title" onUpdate:^(NSString * _Nonnull localizationKey, NSString * _Nullable table, UILabel * _Nonnull label) {
        label.text = [Dialect stringFor:localizationKey];
    }];
    
    // Easily find replace values in the translation string
    [self.singleLineLabel setLocalizationKey:@"home_subtitle" onUpdate:^(NSString * _Nonnull localizationKey, NSString * _Nullable table, UILabel * _Nonnull label) {
        label.text = [Dialect stringFor:localizationKey replace:@{
            @"{version}": shortBundleVersion
        }];
    }];
    
    // Certain classes such as labels have convenience functions that don't require the block but simply let you set the key and on update the text will be updated automatically
    [self.multiLineLabel setTextForLocalizationKey:@"home_text1"];
    
    // These also works with replacements, custom tables or bundles
    [self.multiLineLabel2 setTextForLocalizationKey:@"home_text2" replace:@{
        @"{version}": shortBundleVersion
    }];
    
    // If you don't require real-time updates, you can of course just set the text manually
    self.textFieldLabel.text = [Dialect stringFor:@"home_textfield_title"];
    
    [self.textField setLocalizationKey:@"home_textfield_placeholder" onUpdate:^(NSString * _Nonnull key, NSString * _Nullable table, UITextField * _Nonnull textField) {
        textField.placeholder = [Dialect stringFor:key];
    }];

    // Convenience methods also exist for buttons
    [self.button setTitleForLocalizationKey:@"home_button" forState:UIControlStateNormal];
    
    // Every object can be localized, even non UI objects. Just set the localization key and do whatever custol logic you want in the block. The block will always pass the key, the table and the object it was set on.
    [self.navigationItem setLocalizationKey:@"home_navbar_title" onUpdate:^(NSString * _Nonnull key, NSString * _Nullable table, id<DIALocalizable>  _Nonnull object) {
        ((UINavigationItem *)object).title = [Dialect stringFor:key replace:@{
            @"{language}": language
        }];
    }];
    
    // If you're currently using NSLocalizedString, you can easily migrate by simply replacing to DIALocalizedString
    // You won't get auto updates this way, but the translation will be updated the next time the text is set
    // self.singleLineLabel2.text = NSLocalizedString(@"home_info", @"");
    self.singleLineLabel2.text = DIALocalizedString(@"home_info", @"");
}

- (IBAction)download:(id)sender {
    // Download from a URL
    NSURL *URL = [NSURL URLWithString:@"https://lib-ios-dialect.s3-eu-west-1.amazonaws.com/dialect_translations.json"];
    [Dialect downloadLocalizationDictionaryWithURL:URL table:nil];
    
    // You can also use a URL Request for more control, for example if there's authentication
    // NSMutableURLRequest *URLRequest = [NSMutableURLRequest new];
    // URLRequest.HTTPMethod = @"GET";
    // URLRequest.URL = URL;
    // [Dialect downloadLocalizationDictionaryWithURLRequest:URLRequest table:nil];
    
    // Or manage the download yourself and set it manually
    // NSDictionary *downloadedDict = ...
    // [Dialect setLocalizationDictionary:downloadedDict table:nil update:YES storeOnDisk:YES];
}

- (IBAction)reset:(id)sender {
    // Reset back to using the local strings file
    [Dialect removeLocalizationDictionaryForTable:nil update:YES removeFromDisk:YES];
}

@end
