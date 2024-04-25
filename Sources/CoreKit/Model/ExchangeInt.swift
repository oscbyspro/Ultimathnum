//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int
//*============================================================================*

@frozen public struct ExchangeInt<Element> where Element: SystemsInteger & UnsignedInteger {
    
    public typealias Element = Element
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: DataInt<U8>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: DataInt<U8>, as element: Element.Type = Element.self) {
        self.base = base
    }
    
    @inlinable public init(_ body: DataInt<U8>.Body, repeating appendix: Bit = .zero, as element: Element.Type = Element.self) {
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
    
    @inlinable public subscript(index: UX) -> Element {
        let ratio = UX(IX(MemoryLayout<Element>.stride))
        if  ratio == 1 {
            return Element(load: self.base[index])
            
        }   else {
            var value = Element.zero
            var shift = Element.zero
            
            if  var start = index.times(ratio).optional() {
                let (end) = start.plus(ratio)
                
                if  Bool(Bit(!end.error) & Bit(end.value < UX(bitPattern: self.base.body.count))) {
                    let pointer = UnsafeRawPointer(self.base.body.start)
                    return pointer.loadUnaligned(fromByteOffset: Int(bitPattern: start), as: Element.self)
                }
                
                while start < UX(bitPattern: self.base.body.count) {
                    value = value | Element(load: self.base.body[unchecked: IX(bitPattern: start)]) &<< shift
                    shift = shift.plus(8).assert()
                    start = start.plus(1).assert()
                }
            }
            
            return value | Element(repeating: self.base.appendix) << Element(bitPattern: shift)
        }
    }
}
