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
    
    @inlinable consuming public func quotient (_ divisor: consuming Self) -> Fallible<Self> {
        self.division(divisor).map({ $0.quotient  })
    }
    
    @inlinable consuming public func remainder(_ divisor: consuming Self) -> Fallible<Self> {
        self.division(divisor).map({ $0.remainder })
    }
    
    @inline(never) @inlinable consuming public func division(_ divisor: consuming Self) -> Fallible<Division<Self, Self>> {
        //=--------------------------------------=
        if  divisor.storage.isZero {
            return Fallible.failure(Division(quotient: .zero, remainder: self))
        }
        //=--------------------------------------=
        let lhsAppendixIsSet = Bool(self   .appendix)
        let rhsAppendixIsSet = Bool(divisor.appendix)
        //=--------------------------------------=
        if !Self.isSigned, rhsAppendixIsSet {
            switch self.compared(to: divisor) {
            case Signum.less: return Fallible.success(Division(quotient: .zero, remainder:  self))
            case Signum.same: return Fallible.success(Division(quotient:  0001, remainder: .zero))
            case Signum.more: return Fallible.success(Division(quotient:  0001, remainder:  self - divisor))
            }
        }
        //=--------------------------------------=
        if  lhsAppendixIsSet {
            self[{ $0.complement() }]
        }
        
        if  rhsAppendixIsSet {
            divisor[{ $0.complement() }]
        }
        //=--------------------------------------=
        var result = Magnitude(bitPattern: self).divisionAsFiniteByFiniteNonzeroDivisor(Magnitude(bitPattern: divisor))
        //=--------------------------------------=
        if  lhsAppendixIsSet != rhsAppendixIsSet {
            result.quotient [{ $0.complement() }]
        }
        
        if  lhsAppendixIsSet {
            result.remainder[{ $0.complement() }]
        }
        
        return Fallible.success(Division(bitPattern: result))
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
        Swift.assert((other) != 000000)
        //=--------------------------------------=
        // divisor is at most one element
        //=--------------------------------------=
        if  other.storage.count <= 1 {
            //=----------------------------------=
            // division: divisor != 0
            //=----------------------------------=
            let divisor = other.storage.body.first! as Element.Magnitude
            let remainder = self.withUnsafeMutableBinaryIntegerBody {
                $0.divisionSetQuotientGetRemainder(Nonzero(unchecked: divisor))
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
        let quotient: Self = self.withUnsafeMutableBinaryIntegerBody { lhs in
            other.storage.withUnsafeMutableBinaryIntegerBody { rhs in
                let shift = IX(load: rhs[unchecked: rhs.count - 1].count(.appendix))
                
                if  shift != 0 {
                    lhs.upshift(environment: .zero, major: .zero, minor: shift)
                    rhs.upshift(environment: .zero, major: .zero, minor: shift)
                }
                
                let count = lhs.count - rhs.count
                let quotient = Storage.Body(unsafeUninitializedCapacity: Int(count)) {
                    DataInt.Canvas($0)!.divisionSetQuotientSetRemainderByLong2111MSB(dividing: lhs, by: DataInt.Body(rhs))
                    $1 = Int(count) // set the initialized count
                }
                
                if  shift != 0 {
                    lhs.downshift(environment: .zero, major: .zero, minor: shift)
                }
                
                return Self(normalizing: Storage(consume quotient, repeating: Bit.zero))
            }
        }
        //=--------------------------------------=
        Swift.assert(((self)).storage.isNormal)
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return Division(quotient: quotient, remainder: self)
    }
}
