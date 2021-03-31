//
//  UIButton+DIALocalizable.m
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import "UIButton+DIALocalizable.h"

#import "Dialect.h"



// MARK: - UIButton DIALocalizable Category Implementation

@implementation UIButton (DIALocalizable)

// MARK: DIALocalizable

- (void)setLocalizationKey:(NSString *)localizationKey onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UIButton * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

- (void)setLocalizationKey:(NSString *)localizationKey table:(NSString *)table onUpdate:(void (^)(NSString * _Nonnull, NSString * _Nullable, UIButton * _Nonnull))onUpdate {
    [super setLocalizationKey:localizationKey table:table onUpdate:(void (^)(NSString *, NSString *, id<DIALocalizable>))onUpdate];
}

// MARK: UIButton specific

- (void)setTitleForLocalizationKey:(NSString *)localizationKey forState:(UIControlState)state {
    [self setTitleForLocalizationKey:localizationKey table:nil bundle:nil replace:nil forState:state];
}

- (void)setTitleForLocalizationKey:(NSString *)localizationKey table:(NSString *)table forState:(UIControlState)state {
    [self setTitleForLocalizationKey:localizationKey table:table bundle:nil replace:nil forState:state];
}

- (void)setTitleForLocalizationKey:(NSString *)localizationKey replace:(NSDictionary *)replace forState:(UIControlState)state {
    [self setTitleForLocalizationKey:localizationKey table:nil bundle:nil replace:replace forState:state];
}

- (void)setTitleForLocalizationKey:(NSString *)localizationKey table:(NSString *)table bundle:(NSBundle *)bundle replace:(NSDictionary *)replace forState:(UIControlState)state {
    [self setLocalizationKey:localizationKey table:table onUpdate:^(NSString * _Nonnull key, NSString * _Nullable table, UIButton * _Nonnull button) {
        [button setTitle:[Dialect stringFor:key table:table bundle:bundle defaultValue:nil replace:replace] forState:state];
    }];
}

@end
