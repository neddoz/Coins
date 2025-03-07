//
//  Normalize.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

import Foundation

/// A protocol for types that can be normalized to another type.
///
/// Types conforming to `Normalizable` can convert themselves to a different representation,
/// typically used for transforming external data models (like API responses) to internal Core app models.
public protocol Normalizable {
  /// The type that this instance normalizes to.
  associatedtype Output
  /// The error that might result from a failed normalization.
  associatedtype Failure: Error

  /// Converts this instance to its normalized form.
  /// Converts this instance to its normalized form, or throws an error on failure.
  ///
  /// - Returns: The normalized representation of this instance.
  func normalize() throws(Failure) -> Output
}
