//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Namespaces
//*============================================================================*

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum`.
///
@frozen @usableFromInline package enum UMN {
    
    //=------------------------------------------------------------------------=
    // MARK: Namespaces x Binary Integer
    //=------------------------------------------------------------------------=
    
    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SBI<Base> = UMN.StrictBinaryInteger<Base>
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SBISS<Base> = UMN.StrictBinaryInteger<Base>.SubSequence
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger
    
    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SSI<Base> = UMN.StrictSignedInteger<Base>
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SSISS<Base> = UMN.StrictSignedInteger<Base>.SubSequence
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SUI<Base> = UMN.StrictUnsignedInteger<Base>
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger

    /// A namespace for `Ultimathnum` development.
    ///
    /// - Warning: Do not use this namespace outside of `Ultimathnum`.
    ///
    public typealias SUISS<Base> = UMN.StrictUnsignedInteger<Base>.SubSequence
    where Base: RandomAccessCollection, Base.Element: SystemInteger & UnsignedInteger
}
