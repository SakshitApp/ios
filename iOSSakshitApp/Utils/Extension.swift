//
//  Extection.swift
//  iOSSakshitApp
//
//  Created by Punit Chhajer on 22/03/21.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
