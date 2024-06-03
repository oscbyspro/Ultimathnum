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
        let zeros1 = self.storage.count(while:{ $0 == .zero })
        let zeros2 = zeros1.times(2).unchecked()
        let count2 = self.storage.count * 000002
        //=--------------------------------------=
        // path: (0s, 1s) x (0s, 1s)
        //=--------------------------------------=
        if  count2 == zeros2 {
            Swift.assert(Bool(self.appendix))
            return Fallible(Self(unchecked: Storage(1, at: count2, repeating: .zero)), error: !Self.isSigned)
        }
        //=--------------------------------------=
        let result = Self.uninitialized(count: count2, repeating: .zero) { result in
            self.withUnsafeBinaryIntegerElements {
                //=------------------------------=
                let suffix = $0.body[unchecked: zeros1...]
                //=------------------------------=
                result[unchecked: ..<zeros2].initialize(repeating: 00000000000000)
                result[unchecked: zeros2...].initialize(toSquareProductOf: suffix)
                //=------------------------------=
                if  Bool($0.appendix) {
                    result[unchecked: ($0.body.count &+ zeros1)...].incrementSubSequence(toggling: suffix, plus: true).discard()
                    result[unchecked: ($0.body.count &+ zeros1)...].incrementSubSequence(toggling: suffix, plus: true).discard()
                }
            }
        }
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
        let zeros0 = self .storage.count(while:{ $0 == .zero })
        let zeros1 = other.storage.count(while:{ $0 == .zero })
        let zeros2 = zeros0.plus(zeros1).unchecked()
        let count2 = self.storage.count + other.storage.count
        //=--------------------------------------=
        // path: (0s, 1s) x (0s, 1s)
        //=--------------------------------------=
        if  count2 == zeros2 {
            Swift.assert(Bool(self .appendix))
            Swift.assert(Bool(other.appendix))
            return Fallible(Self(unchecked: Storage(1, at: count2, repeating: .zero)), error: !Self.isSigned)
        }
        //=--------------------------------------=
        let result = Self.uninitialized(count: count2, repeating: self.appendix ^ other.appendix) { result in
            self.withUnsafeBinaryIntegerElements { lhs in
                other.withUnsafeBinaryIntegerElements { rhs in
                    //=--------------------------=
                    let lhsSuffix = lhs.body[unchecked: zeros0...]
                    let rhsSuffix = rhs.body[unchecked: zeros1...]
                    //=--------------------------=
                    result[unchecked: ..<zeros2].initialize(repeating: 00000000000000000000)
                    result[unchecked: zeros2...].initialize(to: lhsSuffix, times: rhsSuffix)
                    //=--------------------------=
                    if  Bool(rhs.appendix) {
                        result[unchecked:(rhs.body.count &+ zeros0)...].incrementSubSequence(toggling: lhsSuffix, plus: true).discard()
                    }
                    
                    if  Bool(lhs.appendix) {
                        result[unchecked:(lhs.body.count &+ zeros1)...].incrementSubSequence(toggling: rhsSuffix, plus: true).discard()
                    }
                }
            }
        }
        //=--------------------------------------=
        return Fallible(result, error: !Self.isSigned && Bool(self.appendix | other.appendix))
    }
}
