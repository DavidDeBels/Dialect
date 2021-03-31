//
//  UILabel+DIALocalizable.m
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import "UILabel+DIALocalizable.h"

#import "Dialect.h"



// MARK: - UILabel DIALocalizable Category Implementation

@implementation UILabel (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UILabel * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

- (void)setLocalizationKey:(NSString *)localizationKey table:(NSString *)table onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UILabel * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey table:table onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

// MARK: UILabel specific

- (void)setTextForLocalizationKey:(NSString *)localizationKey {
    [self setTextForLocalizationKey:localizationKey table:nil bundle:nil replace:nil];
}

- (void)setTextForLocalizationKey:(NSString *)localizationKey table:(NSString *)table {
    [self setTextForLocalizationKey:localizationKey table:table bundle:nil replace:nil];
}

- (void)setTextForLocalizationKey:(NSString *)localizationKey replace:(NSDictionary *)replace {
    [self setTextForLocalizationKey:localizationKey table:nil bundle:nil replace:replace];
}

- (void)setTextForLocalizationKey:(NSString *)localizationKey table:(NSString *)table bundle:(NSBundle *)bundle replace:(NSDictionary *)replace {
    [self setLocalizationKey:localizationKey table:table onUpdate:^(NSString * _Nonnull key, NSString * _Nullable table, UILabel * _Nonnull label) {
        label.text = [Dialect stringFor:key table:table bundle:bundle defaultValue:nil replace:replace];
    }];
}

@end
