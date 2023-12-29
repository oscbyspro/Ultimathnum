//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Fixed Width Integer
//*============================================================================*

public protocol  UMNFixedWidthInteger: UMNBinaryInteger, UMNBitPatternConvertible
where Magnitude: UMNFixedWidthInteger, Magnitude.BitPattern == BitPattern, Standard: Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func multiplying(_ multiplicand: consuming Self, by multiplier: borrowing Self) -> UMNFullWidth<Self, Magnitude>
    
    @inlinable static func dividing(_ dividend: consuming UMNFullWidth<Self, Magnitude>, by multiplier: borrowing Self) -> UMNOverflow<UMNQuoRem<Self, Self>>
}
