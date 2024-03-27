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
// MARK: * Minimi Int x Bit
//*============================================================================*

extension MinimiInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: Bit.BitPattern) {
        self.base = Bit(bitPattern: bitPattern)
    }
    
    @inlinable public var bitPattern: Bit.BitPattern {
        consuming get {
            Bit.BitPattern(bitPattern: self.base)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        self.init(load: source.next())
    }
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<Element.BitPattern> {
        self.init(bitPattern: source)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        T(bitPattern: self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<UX.BitPattern> {
        self.init(bitPattern: source.leastSignificantBit)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        T(bitPattern: Bool(bitPattern: self) ? Self.isSigned ? ~0 as UX : 1 as UX : 0 as UX)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(bitPattern: self.isLessThanZero)
    }
    
    @inlinable public var content: some RandomAccessCollection<Magnitude> {
        CollectionOfOne(Magnitude(bitPattern: self))
    }
    
    @inlinable public func count(_ bit: Bit, option: BitSelection) -> Magnitude {
        Magnitude(bitPattern: ~(self.base ^ bit))
    }
}
