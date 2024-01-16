//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Normal Int x Division
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-14, Swift 5.9).
    ///
    @inlinable public func quotient (divisor: Self) throws -> Self {
        let division = Overflow.capture({ try self.divided(by: divisor) })
        return try Overflow.resolve(division.value.quotient,  overflow: division.overflow)
    }
    
    /// ### Development
    ///
    /// - FIXME: Consuming caues bad accesss (2024-01-14, Swift 5.9).
    ///
    @inlinable public func remainder(divisor: Self) throws -> Self {
        let division = Overflow.capture({ try self.divided(by: divisor) })
        return try Overflow.resolve(division.value.remainder, overflow: division.overflow)
    }
    
    @inlinable public consuming func divided(by divisor: Self) throws -> Division<Self> {
        //=--------------------------------------=
        // divisor is one word, includes is zero
        //=--------------------------------------=
        if  divisor.storage.count == 1 {
            return try self.divided(by: divisor.storage.first)
        }
        //=--------------------------------------=
        // divisor is comparison
        //=--------------------------------------=
        let comparison = divisor.compared(to: self)
        if  comparison < 0 {
        }   else if comparison == 0 {
            return Division(quotient: 1, remainder: 0000)
        }   else {
            return Division(quotient: 0, remainder: self)
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        self.storage.append(0 as Element)
        
        var divisor: Self = divisor
        let shift = divisor.storage.last.count(0, option: .descending).load(as: Int.self)
        
        if  shift != 0 {
            ((self)).storage.withUnsafeMutableBufferPointer({ SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
            divisor .storage.withUnsafeMutableBufferPointer({ SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        //=--------------------------------------=
        // division
        //=--------------------------------------=
        let quotient = Self.uninitialized(count: self.storage.count - divisor.storage.count) { quotient in
        ((self)).storage.withUnsafeMutableBufferPointer { dividend in
        divisor .storage.withUnsafeBufferPointer/*---*/ { divisor  in
            SUI.initializeToQuotientFormRemainderByLongAlgorithm2111MSB(&quotient, dividing: &dividend, by: divisor)
        }}}
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        if  shift != 0 {
            ((self)).storage.withUnsafeMutableBufferPointer({ SUI.bitShiftRight(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        self .storage.normalize()
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return Division(quotient: quotient, remainder: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Private
//=----------------------------------------------------------------------------=

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal consuming func divided(by divisor: Element) throws -> Division<Self> {
        let remainder = self.storage.withUnsafeMutableBufferPointer { base in
            SUISS.formQuotientWithRemainderReportingOverflow(dividing: &base, by: divisor)
        }
        
        self.storage.normalize()
        return try Overflow.resolve(Division(quotient: self, remainder: Self(remainder.partialValue)), overflow: remainder.overflow)
    }
}
