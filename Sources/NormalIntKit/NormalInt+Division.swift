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
        var value = copy self
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  divisor == 0 {
            throw Overflow(Division(quotient: copy value, remainder: value))
        }
        //=--------------------------------------=
        // divisor is one word
        //=--------------------------------------=
        if  divisor.storage.count == 1 {
            
            //  TODO: add single element division to core kit
            
            let divisor = divisor.storage.last as Element
            let remainder = value.storage.withUnsafeMutableBufferPointer { base in
                var remainder = Element()
                
                var index = base.endIndex; while index > base.startIndex {
                    (base).formIndex(before: &index)
                    (base[index], remainder) = try! Element.dividing(Doublet(high: remainder, low: base[index]), by: divisor).components
                }
                
                return remainder as Element
            }
            
            value.storage.normalize()
            return Division(quotient: value, remainder: Self(remainder))
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison = divisor.compared(to: value)
        if  comparison < 0 {
        }   else if comparison == 0 {
            return Division(quotient: 1, remainder: 0)
        }   else {
            return Division(quotient: 0, remainder: value)
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        value.storage.append(0 as Element)
        
        var divisor: Self = divisor
        let shift = divisor.storage.last.count(0, option: .descending).load(as: Int.self)
        
        if  shift != 0 {
            ((value)).storage.withUnsafeMutableBufferPointer({ SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
            divisor .storage.withUnsafeMutableBufferPointer({ SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        //=--------------------------------------=
        // division
        //=--------------------------------------=
        let quotient = Self.uninitialized(count: value.storage.count - divisor.storage.count) { quotient in
        ((value)).storage.withUnsafeMutableBufferPointer { dividend in
        divisor .storage.withUnsafeBufferPointer/*---*/ { divisor  in
            SUI.initializeToQuotientFormRemainderByLongAlgorithm2111MSB(&quotient, dividing: &dividend, by: divisor)
        }}}
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        if  shift != 0 {
            ((value)).storage.withUnsafeMutableBufferPointer({ SUI.bitShiftRight(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        value .storage.normalize()
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return Division(quotient: quotient, remainder: value)
    }
}
