//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Numbers
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self = 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: T) where T: BinaryInteger {
        try! self.init(exactly: source)
    }
    
    @inlinable public init<T>(exactly source: T) throws where T: BinaryInteger {
        try  self.init(elements: source.elements, isSigned: T.isSigned)
    }
    
    @inlinable public init<T>(truncating source: T) where T: BinaryInteger {
        var stream = source.elements.chunked(as: Element.Magnitude.self).stream()
        self.init(load: &stream)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public init(magnitude: consuming Magnitude) throws {
        try  self.init(sign: Sign.plus, magnitude: consume magnitude)
    }
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        var bitPattern = consume magnitude
        var isLessThanZero = sign == Sign.minus
        if  isLessThanZero {
            isLessThanZero = Overflow.capture(&bitPattern, map:{ try $0.negated() })
        }
        
        self.init(bitPattern: consume bitPattern)
        if  self.isLessThanZero != isLessThanZero {
            throw Overflow(consume self)
        }
    }
}
