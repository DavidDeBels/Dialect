//
//  DialectHeader.h
//  Dialect
//
//  Created by David De Bels on 25/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Dialect.
FOUNDATION_EXPORT double DialectVersionNumber;

//! Project version string for Dialect.
FOUNDATION_EXPORT const unsigned char DialectVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Dialect/PublicHeader.h>

#ifndef _DIALECT_
#define _DIALECT_

// Dialect
#import <Dialect/DIALocalization.h>
#import <Dialect/DIALocalizedString.h>

// Styleables
//#import <Dialect/NSObject+DIALocalizable.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <Dialect/UILabel+DIALocalizable.h>
#import <Dialect/UIButton+DIALocalizable.h>
#import <Dialect/UITextField+DIALocalizable.h>
#endif

#endif
