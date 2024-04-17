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
        // TODO: improve it
        //=--------------------------------------=
        return self.times(copy self)
    }
    
    @inlinable public consuming func times(_ other: borrowing Self) -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = other.storage.small {
            return self.times(small)
            
        }   else if let small = self.storage.small {
            // TODO: self.update(other)
            // TODO: return self.times(small)
            return (copy other).times(small)
        }
        let count: IX = self.storage.count + other.storage.count
        let body = Storage.Body(unsafeUninitializedCapacity: Int(count)) {
            let body = DataInt.Canvas($0.baseAddress!, count: IX(count))
            self.withUnsafeBinaryIntegerElements { lhs in
                other.withUnsafeBinaryIntegerElements { rhs in
                    //=---------------------------=
                    // LHS x RHS
                    //=---------------------------=
                    body.initialize(to: lhs.body, times: rhs.body)
                    //=---------------------------=
                    // LHS x RHS.appendix
                    //=---------------------------=
                    if  Bool(rhs.appendix) {
                        var carry = true
                        var index = rhs.body.count
                        
                        for elementIndex in lhs.body.indices {
                            let element = lhs.body[unchecked: elementIndex].toggled()
                            carry = body[unchecked: index][{ $0.plus(element, plus: carry) }]
                            index = index.incremented().assert()
                        }
                    }
                    //=---------------------------=
                    // LHS.appendix x RHS
                    //=---------------------------=
                    if  Bool(lhs.appendix) {
                        var carry = true
                        var index = lhs.body.count
                        
                        for elementIndex in rhs.body.indices {
                            let element = rhs.body[unchecked: elementIndex].toggled()
                            carry = body[unchecked: index][{ $0.plus(element, plus: carry) }]
                            index = index.incremented().assert()
                        }
                    }
                }
            }
            
            $1 = Int(count) // set the initialized count
        }
        //=--------------------------------------=
        let appendix: Bit  = (self.appendix ^  other.appendix)
        let overflow: Bool = !Self.isSigned && Bool(self.appendix |  other.appendix)
        return Fallible(Self(normalizing: Storage(consume body, repeating: appendix)), error: overflow)
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
        let lhsAppendix = Bool(self .appendix)
        let rhsAppendix = Bool(other.appendix)
        let homogeneous = lhsAppendix == rhsAppendix
        
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
            other.body = $0.multiply(by: other.body, add: Element.Magnitude.zero)
        }
        
        self.storage.normalize(appending: Element.Magnitude(bitPattern: other.body))
        
        if !homogeneous {
            self = self.complement()
        }
        
        return self.combine(overflow) as Fallible<Self>
    }
}
