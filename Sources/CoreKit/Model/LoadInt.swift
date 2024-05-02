//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Load Int
//*============================================================================*

@frozen public struct LoadInt<Element> where Element: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: UX {
        UX(IX(MemoryLayout<Element>.stride))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let data: DataInt<U8>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ data: some SomeDataInt<U8>, as element: Element.Type = Element.self) {
        self.data = DataInt(data)
    }
    
    @inlinable public init(_ body: some SomeDataIntBody<U8>, repeating appendix: Bit = .zero, as element: Element.Type = Element.self) {
        self.init(DataInt(body, repeating: appendix))
    }
    
    @inlinable public init?(_ body: UnsafeBufferPointer<U8>, repeating appendix: Bit = .zero, as element: Element.Type = Element.self) {
        guard let base = DataInt(body, repeating: appendix) else { return nil }
        self.init(base)
    }
    
    @inlinable public init(_ start: UnsafePointer<U8>, count: IX, repeating appendix: Bit = .zero, as element: Element.Type = Element.self) {
        self.init(DataInt(start, count: count, repeating: appendix))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.data.appendix
    }
    
    @inlinable public var appendixIndexIsZero: Bool {
        self.data.body.isEmpty
    }
    
    @inlinable public borrowing func appendixIndex() -> UX {
        let count = UX(raw:   self.data.body.count)
        let major = count &>> Self.ratio.count(.ascending((0)))
        let minor = count &   Self.ratio.decremented().assert()
        return major.plus(UX(Bit(minor != 0))).assert()
    }
}
