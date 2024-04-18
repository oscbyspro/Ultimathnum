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
            self[{ $0.complement() }]
        }
        
        let count: IX = self.storage.count * 2
        let body = Storage.Body(unsafeUninitializedCapacity: Int(count)) {
            let body = DataInt.Canvas($0.baseAddress!,count:  IX(count))
            self.withUnsafeBinaryIntegerElements {
                body.initialize(toSquareProductOf: $0.body)
            }
            
            $1 = Int(count) // set the initialized count
        }
        
        return Fallible(Self(normalizing: Storage(consume body, repeating: Bit.zero)), error: overflow)
    }
    
    @inlinable public consuming func times(_ other: borrowing Self) -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = other.storage.small {
            return self.times(small)
            
        }   else if let small = self.storage.small {
            return (copy other).times(small)
        }
        //=--------------------------------------=
        let count: IX = self.storage.count + other.storage.count
        let body = Storage.Body(unsafeUninitializedCapacity: Int(count)) {
            let body = DataInt.Canvas($0.baseAddress!,count:  IX(count))
            self.withUnsafeBinaryIntegerElements { lhs in
                other.withUnsafeBinaryIntegerElements { rhs in
                    body.initialize(to: lhs.body,times: rhs.body)
                    
                    if  Bool(rhs.appendix) {
                        body[unchecked: rhs.body.count...].incrementSubSequence(byComplementOf: lhs.body)
                    }
                    
                    if  Bool(lhs.appendix) {
                        body[unchecked: lhs.body.count...].incrementSubSequence(byComplementOf: rhs.body)
                    }
                }
            }
            
            $1 = Int(count) // set the initialized count
        }
        //=--------------------------------------=
        // note that 0s and 1s take the fast path
        //=--------------------------------------=
        let appendix = (self.appendix ^   other.appendix)
        let overflow = !Self.isSigned &&  Bool(self.appendix |  other.appendix)
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
        
        self.storage.normalize(appending: Element.Magnitude(bitPattern: other.body))
        
        if !homogeneous {
            self = self.complement()
        }
        
        return self.combine(overflow) as Fallible<Self>
    }
}
