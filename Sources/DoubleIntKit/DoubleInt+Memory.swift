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
// MARK: * Double Int x Memory
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Storage.BitPattern) {
        self.init(Storage(raw: source))
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self.storage.load(as: BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: IX) {
        let low  = Low (load: source)
        let high = High(load: source >> IX(size: Low.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public init(load source: UX) {
        let low  = Low (load: source)
        let high = High(load: source >> UX(size: Low.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        let low  = self.storage.low .load(as: UX.self)
        let high = self.storage.high.load(as: UX.self) << UX(size: Low.self)
        return UX.BitPattern.init(raw: low | high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public init(load source: consuming  Element.Magnitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.storage.low.load(as: Element.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: LoadInt<Element.Magnitude>) {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source[Low.size(relativeTo: Element.Magnitude.self).ratio...])
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source[Low.size(relativeTo: Element.Magnitude.self).ratio...])
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.high.appendix
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafePointer(to: self) {
            let count = MemoryLayout<Self>.stride / MemoryLayout<Element.Magnitude>.stride
            return try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: count) {
                try action(DataInt.Body($0, count: IX(count)))
            }
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafeMutablePointer(to: &self) {
            let count = MemoryLayout<Self>.stride / MemoryLayout<Element.Magnitude>.stride
            return try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: count) {
                try action(MutableDataInt.Body($0, count: IX(count)))
            }
        }
    }
}
