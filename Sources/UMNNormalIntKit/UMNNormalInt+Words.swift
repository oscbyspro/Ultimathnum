//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * UMN x Normal Int x Words
//*============================================================================*

extension UMNNormalInt {
    
    /// - TODO: Implement better-than-default indices.
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: [UX]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ source: UMNNormalInt) {
            fatalError("TODO")
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: SX {
            SX(self.base.startIndex)
        }
        
        @inlinable public var endIndex: SX {
            SX(self.base.startIndex)
        }
        
        @inlinable public func index(before index: SX) -> SX {
            SX(self.base.index(before: index.standard()))
        }
        
        @inlinable public func index(after index: SX) -> SX {
            SX(self.base.index(after: index.standard()))
        }
        
        @inlinable public func index(_ index: SX, offsetBy distance: SX) -> SX {
            SX(self.base.index(index.standard(), offsetBy: distance.standard()))
        }
        
        @inlinable public func index(_ index: SX, offsetBy distance: SX, limitedBy limit: SX) -> SX? {
            self.base.index(index.standard(), offsetBy: distance.standard(), limitedBy: limit.standard()).map(SX.init(_:))
        }
        
        @inlinable public subscript(index: SX) -> UX {
            self.base[index.standard()]
        }
    }
}
