//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Recoverable
//*============================================================================*

/// A type with some functional features.
///
/// A recoverable type is essentially any type designed to propagate through
/// the `Fallible<Value>` recovery metchanism. Such types should not have any
/// independent failure modes.
///
/// - Note: This protocol is about ergonomic enhancements.
///
/// #### Perform mutations with a special subscript syntax
///
/// Types that conform to this protocol may perform mutations with a special
/// subscript syntax. The syntax reduces the amount of code that needs testing,
/// while acknowledging the convenience of mutations.
///
/// ```swift
/// var value = U8.zero
/// let error = value[{ $0.decremented() }]
///
/// print(value) // 255
/// print(error) // true
/// ```
///
public protocol Recoverable { }
