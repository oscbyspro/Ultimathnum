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
// MARK: * Infini Int x Elements
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  UX.Signitude) {
        self = source.withUnsafeBinaryIntegerElementsAsBytes(perform: Self.init(load:))
    }
        
    @inlinable public init(load source: consuming  UX.Magnitude) {
        self = source.withUnsafeBinaryIntegerElementsAsBytes(perform: Self.init(load:))
    }
    
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        self.withUnsafeBinaryIntegerElementsAsBytes {
            LoadInt($0, as: UX.self)[UX.zero].load(as: UX.BitPattern.self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        let appendix = source.appendix
        let body = Element.Magnitude(raw: source)
        self.init(normalizing: Storage([body], repeating: appendix))
    }
        
    @inlinable public init(load source: consuming  Element.Magnitude) {
        let appendix = source.appendix
        let body = Element.Magnitude(raw: source)
        self.init(normalizing: Storage([body], repeating: appendix))
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        if  let element = self.storage.body.first {
            return element.load(as: Element.BitPattern.self)
        }   else {
            return Element(repeating: self.appendix).load(as: Element.BitPattern.self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: LoadInt<Element.Magnitude>) {
        let body = Storage.Body(source.body())
        self.init(normalizing: Storage(body, repeating: source.appendix))
    }
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        let body = Storage.Body(source.body.buffer())
        self.init(normalizing: Storage(body, repeating: source.appendix))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.appendix
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try self.storage.withUnsafeBinaryIntegerBody(action)
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        defer {
            self.storage.normalize()
        }
        
        return try self.storage.withUnsafeMutableBinaryIntegerBody(action)
    }
}