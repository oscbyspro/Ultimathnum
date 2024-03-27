//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
    
    @inlinable public init(magnitude: consuming Magnitude) throws {
        try self.init(sign: Sign.plus, magnitude: consume magnitude)
    }
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        var isLessThanZero = Bool(bitPattern: consume sign)
        if  isLessThanZero {
            isLessThanZero = Overflow.capture(&magnitude, map:{ try $0.negated() })
        }
        //=--------------------------------------=
        self.init(bitPattern: consume magnitude)
        //=--------------------------------------=
        if  self.isLessThanZero != isLessThanZero {
            throw Overflow(consume self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: consuming T) where T: BinaryInteger {
        try! self.init(exactly: source)
    }
    
    @inlinable public init<T>(exactly source: consuming T) throws where T: BinaryInteger {
        try  self.init(elements: ExchangeInt(source), isSigned: T.isSigned)
    }
    
    @inlinable public init<T>(truncating source: consuming T) where T: BinaryInteger {
        var stream = ExchangeInt(source, as: Element.Magnitude.self).stream()
        self.init(load: &stream)
    }
    
    @inlinable public init<T>(elements: ExchangeInt<T, Element>.BitPattern, isSigned: Bool) throws {
        let appendix = elements.appendix.bit
        var (stream) = elements.stream()
        //=--------------------------------------=
        self.init(load: &stream)
        //=--------------------------------------=
        let success = (self.appendix == appendix) && (Self.isSigned == isSigned || appendix == 0) && stream.succinct().count == 0
        if !success {
            throw Overflow(consume self)
        }
    }
}
