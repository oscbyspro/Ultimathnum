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
        // path: 0 or 1
        //=--------------------------------------=
        if  self.storage.count <= 1, self.appendix == .zero {
            if  self.storage.body.isEmpty {
                return Fallible(Self.zero)
            }
            
            if  self.storage.body[0] == 1 {
                return Fallible(copy self)
            }
        }
        //=--------------------------------------=
        let count2 = self.storage.count * 2
        let zeros0 = self.storage.count(while:{ $0.isZero })
        let zeros2 = zeros0.times(2).unchecked()
        //=--------------------------------------=
        // path: (0s, 1s) x (0s, 1s)
        //=--------------------------------------=
        if  zeros2 == count2 {
            Swift.assert(Bool(self.appendix))
            return Fallible(Self(unchecked: Storage(1, at: count2, repeating: .zero)), error: !Self.isSigned)
        }
        //=--------------------------------------=
        let result = Self.arbitrary(uninitialized: count2, repeating: .zero) { result -> Void in
            self.storage.withUnsafeBinaryIntegerElements(unchecked: zeros0...) {
                //=------------------------------=
                result[unchecked: ..<zeros2].initialize(repeating: 000000000000000)
                result[unchecked: zeros2...].initialize(toSquareProductOf: $0.body)
                //=------------------------------=
                if  Bool($0.appendix) {
                    let resultSuffix = result[unchecked: ($0.body.count  &+ zeros2)...]
                    resultSuffix.incrementSubSequence(toggling: $0.body, plus: true).discard()
                    resultSuffix.incrementSubSequence(toggling: $0.body, plus: true).discard()
                }
            }
        }!
        //=--------------------------------------=
        return Fallible(result, error: !Self.isSigned && Bool(self.appendix))
    }
    
    @inline(never) @inlinable public borrowing func times(_ other: borrowing Self) -> Fallible<Self> {
        //=--------------------------------------=
        // path: 0 or 1
        //=--------------------------------------=
        if  other.storage.count <= 1, other.appendix == .zero {
            if  other.storage.body.isEmpty {
                return Fallible(Self.zero)
            }
            
            if  other.storage.body[0] == 1 {
                return Fallible(copy self)
            }
        }
        
        if  self.storage.count <= 1, self.appendix == .zero {
            if  self.storage.body.isEmpty {
                return Fallible(Self.zero)
            }
            
            if  self.storage.body[0] == 1 {
                return Fallible(copy other)
            }
        }
        //=--------------------------------------=
        let count2 = self .storage.count + other.storage.count
        let zeros0 = self .storage.count(while:{ $0.isZero })
        let zeros1 = other.storage.count(while:{ $0.isZero })
        let zeros2 = zeros0.plus(zeros1).unchecked()
        //=--------------------------------------=
        // path: (0s, 1s) x (0s, 1s)
        //=--------------------------------------=
        if  zeros2 == count2 {
            Swift.assert(Bool(self .appendix))
            Swift.assert(Bool(other.appendix))
            return Fallible(Self(unchecked: Storage(1, at: count2, repeating: .zero)), error: !Self.isSigned)
        }
        //=--------------------------------------=
        let result = Self.arbitrary(uninitialized: count2, repeating: self.appendix ^ other.appendix) { result -> Void in
            self.storage.withUnsafeBinaryIntegerElements(unchecked: zeros0...) { lhs in
                other.storage.withUnsafeBinaryIntegerElements(unchecked: zeros1...) { rhs in
                    //=--------------------------=
                    result[unchecked: ..<zeros2].initialize(repeating: 000000000000000000)
                    result[unchecked: zeros2...].initialize(to: lhs.body, times: rhs.body)
                    //=--------------------------=
                    if  Bool(rhs.appendix) {
                        result[unchecked: (rhs.body.count &+ zeros2)...].incrementSubSequence(toggling: lhs.body, plus: true).discard()
                    }
                    
                    if  Bool(lhs.appendix) {
                        result[unchecked: (lhs.body.count &+ zeros2)...].incrementSubSequence(toggling: rhs.body, plus: true).discard()
                    }
                }
            }
        }!
        //=--------------------------------------=
        return Fallible(result, error: !Self.isSigned && Bool(self.appendix | other.appendix))
    }
    
    //=----------------------------------------------------------------------------=
    // MARK: Transformations x 1 by 1 as 2
    //=----------------------------------------------------------------------------=
    
    @inlinable public borrowing func multiplication(_ other: borrowing Self) -> Doublet<Self> {
        if  Self.isSigned {
            let low  = Magnitude(raw: self &* other)
            let high = Self(repeating: low.appendix)
            return Doublet(low: low, high: high)
            
        }   else if self.isZero || other.isZero {
            return Doublet()

        }   else {
            let low  = Magnitude(raw: self &* other)
            let high = switch (Bool(self.appendix), Bool(other.appendix)) {
            case (false, false): (0 as Self )
            case (true,  false): (copy other).decremented().unchecked()
            case (false, true ): (copy self ).decremented().unchecked()
            case (true,  true ): (copy self ) &+ other
            }
            
            return Doublet(low: low, high: high)
        }
    }
}
