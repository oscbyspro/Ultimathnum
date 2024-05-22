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
// MARK: * Infini Int x Multiplication
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = self.storage.small {            
            return self.times(small)
        }
        //=--------------------------------------=
        var overflow = Bool(self.appendix)
        if  overflow {
            overflow = !Self.isSigned
            self = self.complement()
        }
        
        let count  = self.storage.count * 2
        let result = Self.uninitialized(count: count, repeating: .zero) { body in
            self.withUnsafeBinaryIntegerElements {
                body.initialize(toSquareProductOf: $0.body)
            }
        }
        
        return Fallible(result, error: overflow)
    }
    
    @inlinable public consuming func times(_ other: borrowing Self) -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = other.storage.small {
            return self.times(small)
            
        }   else if let small = self.storage.small {
            return (copy other).times(small)
        }
        //=--------------------------------------=
        // note that 0s and 1s take the fast path
        //=--------------------------------------=
        let count  = self.storage.count + other.storage.count
        let result = Self.uninitialized(count: count, repeating: self.appendix ^ other.appendix) { product in
            self.withUnsafeBinaryIntegerElements { lhs in
                other.withUnsafeBinaryIntegerElements { rhs in
                    //=--------------------------=
                    product.initialize(to: lhs.body, times: rhs.body)
                    //=--------------------------=
                    if  Bool(rhs.appendix) {
                        product[unchecked: rhs.body.count...].incrementSubSequence(toggling: lhs.body, plus: true).discard()
                    }
                    
                    if  Bool(lhs.appendix) {
                        product[unchecked: lhs.body.count...].incrementSubSequence(toggling: rhs.body, plus: true).discard()
                    }
                }
            }
        }

        return Fallible(result, error: !Self.isSigned && Bool(self.appendix | other.appendix))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension InfiniInt {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func times(_ other: consuming Storage.Small) -> Fallible<Self> {
        //=--------------------------------------=
        let lhsAppendix = Bool(self .appendix)
        let rhsAppendix = Bool(other.appendix)
        let homogeneous = lhsAppendix == rhsAppendix
        //=--------------------------------------=
        let overflow = if Self.isSigned {
            false
        }   else if homogeneous {
            lhsAppendix
        }   else if lhsAppendix {
            other.body > 1
        }   else {
            self.storage.count > 1 || self.load(as: Element.Magnitude.self) > 1
        }
        
        if  rhsAppendix {
            other.body = other.body.complement()
        }
        
        if  lhsAppendix {
            self = self.complement()
        }
        
        self.storage.withUnsafeMutableBinaryIntegerBody {
            other.body = $0.multiply(by: other.body)
        }
        
        self.storage.normalize(appending: Element.Magnitude(raw: other.body))
        
        if !homogeneous {
            self = self.complement()
        }
        
        return self.veto(overflow) as Fallible<Self>
    }
}
