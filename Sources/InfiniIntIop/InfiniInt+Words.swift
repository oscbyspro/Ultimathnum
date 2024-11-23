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
import InfiniIntKit

//*============================================================================*
// MARK: * Infini Int x Words x Stdlib
//*============================================================================*

extension InfiniInt.Stdlib {
    
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
    
    @frozen public struct Words: Swift.CustomStringConvertible, Swift.RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        public let count: Swift.Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable internal init(_ base: consuming Base) {
            self.count = Swift.Int(Self.count(of: base))
            self.base  = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var description: String {
            "[\(self.lazy.map(String.init(describing:)).joined(separator: ", "))]"
        }
        
        @inlinable public var startIndex: Swift.Int {
            Swift.Int.zero
        }
        
        @inlinable public var endIndex: Swift.Int {
            self.count as Swift.Int
        }
        
        @inlinable public subscript(index: Swift.Int) -> Swift.UInt {
            Swift.UInt(Self.element(of: self.base, at: IX(index)))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension InfiniInt.Stdlib.Words {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func count(of base: borrowing InfiniInt) -> IX {
        if  InfiniInt.Element.size >= UX.size {
            base.withUnsafeBinaryIntegerElements(as: UX.self) {
                $0.body.count + IX(Bit($0.body.last?.msb != $0.appendix))
            }
            
        }   else {
            base.withUnsafeBinaryIntegerElements(as: U8.self) {
                let divisor = Nonzero(unchecked: UX(raw: MemoryLayout<UX>.size))
                var division: Division = UX(raw: $0.body.count).division(divisor)
                
                if !division.remainder.isZero {
                    division.quotient &+= 1
                }   else {
                    division.quotient &+= UX(Bit($0.body.last?.msb != $0.appendix))
                }
                
                return IX(raw: division.quotient)
            }
        }
    }
    
    @inlinable internal static func element(of base: borrowing InfiniInt, at index: IX) -> UX {
        if  InfiniInt.Element.size >= UX.size {
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
