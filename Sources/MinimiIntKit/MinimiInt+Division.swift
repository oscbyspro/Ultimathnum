//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int x Division
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotient (_ divisor: Self) -> Fallible<Self> {
        let error = Self(bitPattern: Self.isSigned) & self | ~divisor
        let value = self &  divisor
        return Fallible(value, error: Bool(bitPattern: error))
    }
        
    @inlinable public func remainder(_ divisor: Self) -> Fallible<Self> {
        let error = Self(bitPattern: Self.isSigned) & self | ~divisor
        let value = self & ~divisor
        return Fallible(value, error: Bool(bitPattern: error))
    }
    
    @inlinable public func division(_ divisor: Self) -> Fallible<Division<Self, Self>> {
        let error = Self(bitPattern: Self.isSigned) & self | ~divisor
        let value = Division(
            quotient:  self &  divisor,
            remainder: self & ~divisor
        )
        return Fallible(value, error: Bool(bitPattern: error))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func division(_ dividend: DoubleIntLayout<Self>, by divisor: Self) -> Fallible<Division<Self, Self>> {
        let error = dividend.high | ~divisor
        let value = Division(
            quotient:  Self(bitPattern: dividend.low) &  divisor,
            remainder: Self(bitPattern: dividend.low) & ~divisor
        )
        return Fallible(value, error: Bool(bitPattern: error))
    }
}
