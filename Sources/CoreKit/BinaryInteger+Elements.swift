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

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(elements: SequenceInt<T, T.Element.Magnitude>, isSigned: Bool) throws {
        let isLessThanZero = SBISS.isLessThanZero(elements, isSigned: isSigned)
        var stream = elements.chunked(as: Element.Magnitude.self).makeBinaryIntegerStream()
        
        self.init(load: &stream)
        
        // TODO: it should also work for infinity (unsigned, 1...)
        
        let success = self.isLessThanZero == isLessThanZero && stream.succinct().count == Int.zero
        if !success {
            throw Overflow(consume self)
        }
    }
}

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
    
    @inlinable public init<T>(load source: inout SequenceInt<T, Element.Magnitude>.BinaryIntegerStream) {
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
    
    @inlinable public var elements: SequenceInt<Elements, Element.Magnitude> {
        SequenceInt(CollectionOfOne(Magnitude(bitPattern: self)), isSigned: Self.isSigned)
    }
}
