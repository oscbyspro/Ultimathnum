//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Bit
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Base.BitPattern) {
        self.base = Base(bitPattern: bitPattern)
    }
    
    @inlinable public var bitPattern: Base.BitPattern {
        consuming get {
            self.base.bitPattern
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
    
    @inlinable public init<T>(load source: T) where T: BitCastable<UX.BitPattern> {
        self.init(Base(truncatingIfNeeded: UInt(bitPattern: source)))
    }
        
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: UInt(truncatingIfNeeded: self.base))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(Self.isSigned && self < 0)
    }
    
    @inlinable public var body: some RandomAccessCollection<Magnitude> {
        CollectionOfOne(Magnitude(bitPattern: self))
    }
    
    @inlinable public func count(_ bit: Bit, option: BitSelection) -> Magnitude {
        switch (Bool(bit), option) {
        case (true,         .all): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base     .nonzeroBitCount))
        case (false,        .all): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base     .nonzeroBitCount))
        case (true,   .ascending): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base.trailingZeroBitCount))
        case (false,  .ascending): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base.trailingZeroBitCount))
        case (true,  .descending): Magnitude(Base.Magnitude(truncatingIfNeeded: (~self).base .leadingZeroBitCount))
        case (false, .descending): Magnitude(Base.Magnitude(truncatingIfNeeded: ( self).base .leadingZeroBitCount))
        }
    }
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        (~self).incremented(increment)
    }
}
