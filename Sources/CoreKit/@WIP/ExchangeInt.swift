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
    
    /// A namespace for Element.bitWidth \> Base.Element.bitWidth.
    @frozen @usableFromInline enum Major { }
    
    /// A namespace for Element.bitWidth < Base.Element.bitWidth.
    @frozen @usableFromInline enum Minor { }
    
    /// A namespace for Element.bitWidth == Base.Element.bitWidth.
    @frozen @usableFromInline enum Equal { }
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: MemoryInt<U8>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: MemoryInt<U8>, as destination: Element.Type = Element.self) {
        self.base = base
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
