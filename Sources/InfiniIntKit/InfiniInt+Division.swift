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
    
    @inlinable consuming public func quotient (_ divisor: consuming Divisor<Self>) -> Fallible<Self> {
        self.division(divisor).map({ $0.quotient })
    }
    
    @inlinable consuming public func remainder(_ divisor: consuming Divisor<Self>) -> Self {
        self.division(divisor).value.remainder
    }
    
    @inline(never) @inlinable consuming public func division(_ divisor: consuming Divisor<Self>) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        var overflow = false
        let lhsAppendixIsSet = Bool(self.appendix)
        let rhsAppendixIsSet = Bool(divisor.value.appendix)
        //=--------------------------------------=
        if !Self.isSigned, rhsAppendixIsSet {
            switch self.compared(to: divisor.value) {
            case Signum.less: return Fallible(Division(quotient: .zero, remainder:  self))
            case Signum.same: return Fallible(Division(quotient:  0001, remainder: .zero))
            case Signum.more: return Fallible(Division(quotient:  0001, remainder:  self - divisor.value))
            }
        }   else if !Self.isSigned, lhsAppendixIsSet {
            overflow = !(divisor.value.storage.count == 1 && divisor.value.storage.body[.zero] == 1)
        }
        //=--------------------------------------=
        if  lhsAppendixIsSet {
            self = self.complement()
        }
        
        if  rhsAppendixIsSet {
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
        
        return Fallible(Division(raw: division), error: overflow)
    }
}

//*============================================================================*
// MARK: * Infini Int x Division x Unsigned
//*============================================================================*

extension InfiniInt where Source == Source.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable internal consuming func divisionAsFiniteByFiniteNonzeroDivisor(
        _ other: consuming Self
    )   -> Division<Self, Self> {
        //=--------------------------------------=
        Swift.assert(!self .isInfinite)
        Swift.assert(!other.isInfinite)
        Swift.assert((other) !=  .zero)
        //=--------------------------------------=
        // divisor is at most one element
        //=--------------------------------------=
        if  other.storage.count <= 1 {
            //=----------------------------------=
            // note: divisor != 0
            //=----------------------------------=
            let divisor = other.storage.body.first! as Element.Magnitude
            let remainder = self.withUnsafeMutableBinaryIntegerBody {
                $0.divisionSetQuotientGetRemainder(Divisor(unchecked: divisor))
            }
            
            return Division(quotient: self, remainder: Self(load: remainder))
        }
        //=--------------------------------------=
        // division: dividend <= divisor
        //=--------------------------------------=
        switch self.compared(to: other) {
        case Signum.more: break
        case Signum.same: return Division(quotient:  0001, remainder: .zero)
        case Signum.less: return Division(quotient: .zero, remainder:  self)
        }
        //=--------------------------------------=
        // division: dividend >  divisor
        //=--------------------------------------=
        self.storage.body.append(Element.zero)
        
        let capacity = self.storage.count - other.storage.count
        let quotient = Self.uninitialized(count: capacity, repeating: .zero) { quotient in
            self.withUnsafeMutableBinaryIntegerBody { lhs in
                other.storage.withUnsafeMutableBinaryIntegerBody { rhs in
                    let shift  = IX(load: rhs[unchecked: rhs.count - 1].count(.appendix))

                    if  shift != .zero {
                        lhs.upshift(environment: .zero, major: .zero, minor: shift)
                        rhs.upshift(environment: .zero, major: .zero, minor: shift)
                    }
                    
                    quotient.divisionSetQuotientSetRemainderByLong2111MSB(dividing: lhs, by: DataInt.Body(rhs))
                    
                    if  shift != .zero {
                        lhs.downshift(environment: .zero, major: .zero, minor: shift)
                    }
                }
            }
        }
        
        Swift.assert(((self)).storage.isNormal)
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return Division(quotient: quotient, remainder: self)
    }
}
