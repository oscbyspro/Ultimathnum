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
// MARK: * Infini Int x Division
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func quotient (_ divisor: consuming Nonzero<Self>) -> Optional<Fallible<Self>> {
        self.division(divisor)?.map({ $0.quotient })
    }
    
    @inlinable public consuming func remainder(_ divisor: consuming Nonzero<Self>) -> Optional<Self> {
        self.division(divisor)?.value.remainder
    }
    
    @inline(never) @inlinable public consuming func division(_ divisor: consuming Nonzero<Self>) -> Optional<Fallible<Division<Self, Self>>> {
        //=--------------------------------------=
        let lhsAppendixIsSet = Bool(self.appendix)
        let rhsAppendixIsSet = Bool(divisor.value.appendix)
        //=--------------------------------------=
        if !Self.isSigned, lhsAppendixIsSet {
            return nil
        }
        
        if !Self.isSigned, rhsAppendixIsSet {
            switch self.compared(to: divisor.value) {
            case Signum.negative: return Fallible(Division(quotient: .zero, remainder:  self))
            case Signum.zero:     return Fallible(Division(quotient:  0001, remainder: .zero))
            case Signum.positive: return Fallible(Division(quotient:  0001, remainder:  self - divisor.value))
            }
        }
        
        if  Self.isSigned, lhsAppendixIsSet {
            self = self.complement()
        }
        
        if  Self.isSigned, rhsAppendixIsSet {
            divisor = divisor.complement()
        }
        //=--------------------------------------=
        var division = Magnitude(raw: self).divisionAsFiniteByFiniteNonzeroDivisor(Magnitude(raw: divisor.value))
        //=--------------------------------------=
        if  lhsAppendixIsSet  != rhsAppendixIsSet {
            division.quotient  = division.quotient .complement()
        }
        
        if  lhsAppendixIsSet {
            division.remainder = division.remainder.complement()
        }
        
        return Optional(Fallible(Division(raw: division)))
    }
}

//*============================================================================*
// MARK: * Infini Int x Division x Unsigned
//*============================================================================*

extension InfiniInt where Self: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable internal consuming func divisionAsFiniteByFiniteNonzeroDivisor(
        _ divisor: consuming Self
    )   -> Division<Self, Self> {
        //=--------------------------------------=
        Swift.assert(!self   .isInfinite)
        Swift.assert(!divisor.isInfinite)
        Swift.assert(!divisor.isZero)
        //=--------------------------------------=
        // divisor is at most one element
        //=--------------------------------------=
        if  divisor.storage.count <= 1 {
            //=----------------------------------=
            // note: divisor != 0
            //=----------------------------------=
            let divisor:   Element = divisor.storage.body.first!
            let remainder: Element = self.withUnsafeMutableBinaryIntegerBody {
                $0.divisionSetQuotientGetRemainder(Nonzero(unchecked: divisor))
            }
            
            return Division(quotient: self, remainder: Self(load: remainder))
        }
        //=--------------------------------------=
        // division: dividend <= divisor
        //=--------------------------------------=
        switch self.compared(to: divisor) {
        case Signum.positive: break
        case Signum.zero:     return Division(quotient:  0001, remainder: .zero)
        case Signum.negative: return Division(quotient: .zero, remainder:  self)
        }
        //=--------------------------------------=
        // division: dividend >  divisor
        //=--------------------------------------=
        self.storage.body.append(Element.zero)
        
        let capacity = self.storage.count - divisor.storage.count
        let quotient = Self.arbitrary(uninitialized: capacity, repeating: .zero) { quotient -> Void in
            self.withUnsafeMutableBinaryIntegerBody { lhs in
                divisor.storage.withUnsafeMutableBinaryIntegerBody { rhs in
                    let shift = IX(raw: rhs[unchecked: rhs.count - 1].descending(Bit.zero))
                    Swift.assert(Count(raw: shift) < Element.size)
                    
                    if !shift.isZero {
                        lhs.upshift(major: .zero, minorAtLeastOne: shift)
                        rhs.upshift(major: .zero, minorAtLeastOne: shift)
                    }
                    
                    quotient.divisionSetQuotientSetRemainderByLong2111MSB(dividing: lhs, by: DataInt.Body(rhs))
                    
                    if !shift.isZero {
                        lhs.downshift(major: .zero, minorAtLeastOne: shift)
                    }
                }
            }
        }!
        
        Swift.assert(((self)).storage.isNormal)
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return Division(quotient: quotient, remainder: self)
    }
}
