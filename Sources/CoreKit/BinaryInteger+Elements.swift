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
    
    @inlinable public init<T>(elements: ExchangeInt<T, Element>.BitPattern, isSigned: Bool) throws {
        let appendix = elements.extension.bit
        var (stream) = elements.stream()
        
        self.init(load: &stream)
        
        let success = (self.appendix == appendix) && (Self.isSigned == isSigned || appendix == 0) && stream.succinct().count == 0
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
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element.Magnitude>.Stream) {
        self.init(load: source.next())
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern> {
        T(bitPattern: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is Self
//=----------------------------------------------------------------------------=

extension BinaryInteger where Element == Self, Content == CollectionOfOne<Element.Magnitude> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public var elements: ExchangeInt<Content, Element> {
        ExchangeInt(CollectionOfOne(Magnitude(bitPattern: self)), repeating: self.appendix)
    }
}
