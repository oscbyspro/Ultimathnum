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
// MARK: * Infini Int x Bit
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
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        let appendix = source.appendix
        let base = InfiniInt.Storage.Base(source.succinct())
        //=--------------------------------------=
        source.consume()
        //=--------------------------------------=
        self.init(unchecked: InfiniInt.Storage(base, repeating: appendix))
    }
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<Element.BitPattern> {
        let appendix = BitExtension<Element.Magnitude>(repeating: source.appendix)
        self.init(normalizing: InfiniInt.Storage([Element.Magnitude(bitPattern: source)], repeating: appendix))
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(bitPattern: self.storage.base.first ?? self.storage.appendix.element)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: IX) {
        fatalError("TODO")
    }
        
    @inlinable public init(load source: UX) {
        fatalError("TODO")
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.appendix.bit
    }
    
    @inlinable public var body: ContiguousArray<Element.Magnitude> {
        self.storage.base
    }
    
    @inlinable public borrowing func count(_ bit: Bit, option: BitSelection) -> Magnitude {
        fatalError("TODO")
    }
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        fatalError("TODO")
    }
}
