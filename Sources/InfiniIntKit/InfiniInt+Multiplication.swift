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
    
    @inline(never) @inlinable public borrowing func squared() -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = self.storage.small {            
            return (copy self).times(small)
        }
        //=--------------------------------------=
        let count  = self.storage.count * 2
        let result = Self.uninitialized(count: count, repeating: .zero) { result in
            self.withUnsafeBinaryIntegerElements {
                //=------------------------------=
                result.initialize(toSquareProductOf: $0.body)
                //=------------------------------=
                if  Bool($0.appendix) {
                    result[unchecked: $0.body.count...].incrementSubSequence(toggling: $0.body, plus: true).discard()
                    result[unchecked: $0.body.count...].incrementSubSequence(toggling: $0.body, plus: true).discard()
                }
            }
        }
        
        return Fallible(result, error: !Self.isSigned && Bool(self.appendix))
    }
    
    @inline(never) @inlinable public borrowing func times(_ other: borrowing Self) -> Fallible<Self> {
        //=--------------------------------------=
        if  let small = other.storage.small {
            return (copy self ).times(small)
            
        }   else if let small = self.storage.small {
            return (copy other).times(small)
        }
        //=--------------------------------------=
        // note that 0s and 1s take the fast path
        //=--------------------------------------=
        let count  = self.storage.count + other.storage.count
        let result = Self.uninitialized(count: count, repeating: self.appendix ^ other.appendix) { result in
            self.withUnsafeBinaryIntegerElements { lhs in
                other.withUnsafeBinaryIntegerElements { rhs in
                    //=--------------------------=
                    result.initialize(to: lhs.body, times: rhs.body)
                    //=--------------------------=
                    if  Bool(rhs.appendix) {
                        result[unchecked: rhs.body.count...].incrementSubSequence(toggling: lhs.body, plus: true).discard()
                    }
                    
                    if  Bool(lhs.appendix) {
                        result[unchecked: lhs.body.count...].incrementSubSequence(toggling: rhs.body, plus: true).discard()
                    }
                }
            }
        }
        //=--------------------------------------=
        Swift.assert(result.storage.isNormal)
        //=--------------------------------------=
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
    
    @inline(never) @inlinable internal consuming func times(_ other: consuming Storage.Small) -> Fallible<Self> {
        //=--------------------------------------=
        let lhsAppendix = Bool(self .appendix)
        let rhsAppendix = Bool(other.appendix)
        //=--------------------------------------=
        let overflow = if Self.isSigned {
            false
        }   else if lhsAppendix == rhsAppendix {
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
        
        //  TODO: consider compact small storage
        if  rhsAppendix && other.body == .zero {
            if !self.storage.isZero {
                self.storage.body.insert(other.body, at: .zero)
            }
            
        }   else {
            self.storage.withUnsafeMutableBinaryIntegerBody {
                other.body = $0.multiply(by:  other.body)
            }
            
            self.storage.normalize(appending: other.body)
        }
        
        if  lhsAppendix != rhsAppendix {
            self = self.complement()
        }
        //=--------------------------------------=
        Swift.assert(self.storage.isNormal)
        //=--------------------------------------=
        return self.veto(overflow) as Fallible<Self>
    }
}
