//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Namespace
//*============================================================================*

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@frozen @usableFromInline package enum Namespace { }

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias IDF = Namespace.IntegerDescriptionFormat

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias PBI<Integer> = Namespace.ProperBinaryInteger<Integer>
where Integer: BinaryInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias PSI<Integer> = Namespace.ProperBinaryInteger<Integer>
where Integer: BinaryInteger & SignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias PUI<Integer> = Namespace.ProperBinaryInteger<Integer>
where Integer: BinaryInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SBI<Base> = Namespace.StrictBinaryInteger<Base>
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SBISS<Base> = Namespace.StrictBinaryInteger<Base>.SubSequence
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SSI<Base> = Namespace.StrictSignedInteger<Base>
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SSISS<Base> = Namespace.StrictSignedInteger<Base>.SubSequence
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SUI<Base> = Namespace.StrictUnsignedInteger<Base>
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@usableFromInline package typealias SUISS<Base> = Namespace.StrictUnsignedInteger<Base>.SubSequence
where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias TBI<High> = Namespace.TupleBinaryInteger<High>
where High: SystemInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias TSI<High> = Namespace.TupleBinaryInteger<High>
where High: SystemInteger & SignedInteger

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@usableFromInline package typealias TUI<High> = Namespace.TupleBinaryInteger<High>
where High: SystemInteger & UnsignedInteger
