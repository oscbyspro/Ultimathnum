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
    
    @frozen public struct Words: Swift.CustomStringConvertible, Swift.RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// - Note: Swift.BinaryInteger.Words includes the appendix bit.
        @inlinable internal init(_ base: consuming Base) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Swift.Int {
            self.base.withUnsafeBinaryIntegerElements {
                Swift.Int($0.body.count + IX(Bit($0.body.last?.msb != $0.appendix)))
            }
        }
        
        @inlinable public var startIndex: Swift.Int {
            Swift.Int.zero
        }
        
        @inlinable public var endIndex: Swift.Int {
            self.count as Swift.Int
        }
        
        @inlinable public subscript(index: Swift.Int) -> Swift.UInt {
            Swift.UInt(self.base.withUnsafeBinaryIntegerElements({ $0[UX(IX(index))] }))
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        public var description: String {
            "[\(self.lazy.map({ $0.description }).joined(separator: ", "))]"
        }
    }
}
