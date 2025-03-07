//
//  Mockable.swift
//  Coins
//
//  Created by kayeli dennis on 07/03/2025.
//

import Foundation

/// A protocol for types that can be mocked to another type.
///
/// Types conforming to `Mockable` can convert themselves to a different representation,
/// typically used for transforming external data models (like API responses) to internal Core app models.
public protocol Mockable {
  /// The type that this instance mocked to.
  associatedtype T: Decodable

  /// Converts this instance to its mocked form.
  /// Converts this instance to its mocked form, or throws an error on failure.
  ///
  /// - Returns: The mocked representation of this instance.
  static func mocked() throws(Error) -> T
}
