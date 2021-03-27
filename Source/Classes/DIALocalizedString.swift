//
//  DIALocalizedString.swift
//  Dialect-iOS
//
//  Created by David De Bels on 27/03/2021.
//  Copyright © 2021 FlightRange. All rights reserved.
//

import Foundation

public func DIALocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String {
    return Dialect.stringFor(key: key, table: tableName, bundle: bundle, defaultValue: value, replace: nil)
}
