//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Trivial Integer
//*============================================================================*

public protocol UMNTrivialInteger: UMNBinaryInteger, UMNBitCastable where
Magnitude: UMNUnsigned & UMNTrivialInteger, Magnitude.BitPattern == BitPattern,
Standard: Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var bitWidth: Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by multiplier: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
}
