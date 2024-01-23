//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Elements
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Element is Self
//=----------------------------------------------------------------------------=

extension BinaryInteger where Element == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: BitCastable<Element.BitPattern> {
        self.init(bitPattern: source)
    }
    
    @inlinable public init<T>(load source: inout EndlessInt<T>.Stream) where T.Element == Element.Magnitude {
        self.init(load: source.next())
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern> {
        T(bitPattern: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is Self
//=----------------------------------------------------------------------------=

extension BinaryInteger where Element == Self, Elements == CollectionOfOne<Element.Magnitude> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public var elements: EndlessInt<Elements> {
        let endlessLast = Bit(bitPattern: self.isLessThanZero)
        let base = CollectionOfOne(Magnitude(bitPattern: self))
        return EndlessInt(base, endlessLast: endlessLast)
    }
}
