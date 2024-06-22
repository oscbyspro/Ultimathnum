//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Words
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        consuming get {
            Words(self.base)
        }
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: Swift.RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        public let count: Swift.Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// - Note: Swift.BinaryInteger.Words includes the appendix bit.
        @inlinable internal init(_ base: consuming Base) {
            self.base   = consume  base
            let entropy = self.base.withUnsafeBinaryIntegerElements({ $0.entropy() })
            self.count  = Swift.Int(entropy.division(Divisor(size: UX.self)).ceil().unchecked())
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
        
        @inlinable public subscript(index: Swift.Int) -> Swift.UInt {
            Swift.UInt(self.base.withUnsafeBinaryIntegerElements({ $0[UX(IX(index))] }))
        }
    }
}
