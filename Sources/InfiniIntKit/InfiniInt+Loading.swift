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
// MARK: * Infini Int x Loading
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload // we need this when Element is UX or IX
    @inlinable public init(load source: consuming UX.Signitude) {
        if  Element.size >= UX.size {
            self.init(load: Element.Signitude(load: source))
        }   else {
            self = source.withUnsafeBinaryIntegerElements(as: U8.self, perform: Self.init(load:))
        }
    }
    
    @_disfavoredOverload // we need this when Element is UX or IX
    @inlinable public init(load source: consuming UX.Magnitude) {
        if  Element.size >= UX.size {
            self.init(load: Element.Magnitude(load: source))
        }   else {
            self = source.withUnsafeBinaryIntegerElements(as: U8.self, perform: Self.init(load:))
        }
    }
    
    @_disfavoredOverload // we need this when Element is UX or IX
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        if  Element.size >= UX.size {
            self.withUnsafeBinaryIntegerElements(as: UX.self) {
                $0.first.load(as: UX.BitPattern.self)
            }
            
        }   else {
            self.withUnsafeBinaryIntegerElements(as: U8.self) {
                $0.load(as: UX.self).load(as: UX.BitPattern.self)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming Element.Signitude) {
        var storage = Storage([], repeating: source.appendix)
        
        if  source != Element.Signitude(repeating: storage.appendix) {
            storage.body.append(Element.Magnitude(raw: source))
        }
        
        self.init(unchecked: storage)
    }
    
    @inlinable public init(load source: consuming Element.Magnitude) {
        var storage = Storage([], repeating: source.appendix)
        
        if  source != Element.Magnitude(repeating: storage.appendix) {
            storage.body.append(source)
        }
        
        self.init(unchecked: storage)
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.withUnsafeBinaryIntegerElements {
            $0.first.load(as: Element.BitPattern.self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming DataInt<U8>) {
        //=--------------------------------------=
        source = source.normalized()
        //=--------------------------------------=
        var body = Storage.Body()
        body.reserveCapacity(Int(raw: source.body.count(as: Element.Magnitude.self)))
        
        while !source.body.isEmpty {
            body.append(source.next(as: Element.Magnitude.self))
        }
        
        self.init(unchecked: Storage(body, repeating: source.appendix))
    }
    
    @inlinable public init(load source: consuming DataInt<Element.Magnitude>) {
        //=--------------------------------------=
        source = source.normalized()
        //=--------------------------------------=
        let body = Storage.Body(source.body.buffer())
        self.init(unchecked: Storage(body, repeating: source.appendix))
    }
    
    @inlinable public static func arbitrary(
        uninitialized  count:  IX,
        repeating   appendix:  Bit,
        initializer delegate: (MutableDataInt<Element.Magnitude>.Body) -> IX
    )   -> Optional<Self> {
        
        guard UX(raw: count) <= UX(raw: DataInt<Element.Magnitude>.capacity) else { return nil }
        var storage = Storage.uninitialized(unchecked: count, repeating: appendix, initializer: delegate)
        storage.normalize()
        return Self(unchecked: storage)
    }
}
