//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import DoubleIntKit

//*============================================================================*
// MARK: * Double Int x Words x Stdlib
//*============================================================================*

extension DoubleInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        consuming get {
            Words(self.base)
        }
    }
    
    /// The least significant word.
    ///
    /// ### Development
    ///
    /// - Note: This is a requirement of `Swift.BinaryInteger`.
    ///
    @inlinable public var _lowWord: Swift.UInt {
        Swift.UInt(Words.element(of: self.base, at: IX.zero))
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    /// ### Development
    ///
    /// - todo: Remove un/signed distinction.
    ///
    @frozen public struct Words: Swift.RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable internal init(_ base: consuming Base) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: Swift.Int {
            Swift.Int.zero
        }
        
        @inlinable public var endIndex: Swift.Int {
            self.count as Swift.Int
        }
        
        @inlinable public var count: Swift.Int {
            Swift.Int(Self.count(of: self.base))
        }
        
        @inlinable public subscript(index: Swift.Int) -> Swift.UInt {
            Swift.UInt(Self.element(of: self.base, at: IX(index)))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension DoubleInt.Stdlib.Words {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: borrowing DoubleInt) -> IX {
        if  DoubleInt.size <= UX.size {
            return 1
        }   else {
            return IX(raw: UX(size: DoubleInt.self).quotient(Nonzero(size: UX.self)))
        }        
    }
    
    @inlinable internal static func element(of base: borrowing DoubleInt, at index: IX) -> UX {
        if  DoubleInt.Element.size >= UX.size {
            base.withUnsafeBinaryIntegerElements(as: UX.self) {
                $0[UX(index)]
            }
            
        }   else {
            base.withUnsafeBinaryIntegerElements(as: U8.self) {
                let ratio = UX(raw: MemoryLayout<UX>.size)
                let start = UX(index).times(ratio).optional() ?? UX.max
                return $0[start...].load(as: UX.self)
            }
        }
    }
}
