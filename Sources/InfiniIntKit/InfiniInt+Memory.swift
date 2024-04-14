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
// MARK: * Infini Int x Memory
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Magnitude) {
        self.init(unchecked: bitPattern.storage)
    }
    
    @inlinable public var bitPattern: Magnitude {
        consuming get {
            Magnitude(unchecked: self.storage)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  UX.Signitude) {
        fatalError("TODO")
    }
        
    @inlinable public init(load source: consuming  UX.Magnitude) {
        fatalError("TODO")
    }
    
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        fatalError("TODO")
    }
        
    @inlinable public init(load source: consuming  Element.Magnitude) {
        fatalError("TODO")
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: DataInt<I8.Magnitude>) {
        fatalError("TODO")
    }
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(self.storage.appendix != 0)
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try self.storage.base.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Canvas) throws -> T
    )   rethrows -> T {
        
        try self.storage.base.withUnsafeMutableBufferPointer {
            try action(DataInt.Canvas($0)!)
        }
    }
}
