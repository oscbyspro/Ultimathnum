//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Bit
//*============================================================================*

extension BinaryInteger {
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    // NOTE: The compiler wants to convert integer literals to Bit in init(_:).
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: This method is **important** for performance.
    ///
    @_disfavoredOverload @inlinable public init(_ bit: Bit) {
        self = Bool(bit) ?  1 : 0
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bit) ? ~0 : 0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement() -> Self {
        self.complement(true).value
    }
    
    @inlinable public consuming func magnitude() -> Magnitude {
        Magnitude(bitPattern: self.isNegative ? self.complement() : self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The least significant bit in its bit pattern.
    ///
    /// It returns `0` when this value is even, and `1` when it is odd.
    ///
    /// - Note: This accessor tests only the least significant element.
    ///
    @inlinable public var leastSignificantBit: Bit {
        Bit(self.load(as: Element.self) & Element.lsb != 0)
    }
    
    @inlinable public func count(_ bit: Bit) -> Magnitude {
        self.count(bit, where: Bit.Selection.anywhere)
    }
    
    @inlinable public func count(_ selection: Bit.Selection.Integer) -> Magnitude {
        typealias T = Bit.Selection
        return switch selection {
            
        case .bit:
            Self.size
            
        case let .each(x):
            self.count(x, where: T.anywhere)
            
        case let .ascending(x):
            self.count(x, where: T.ascending)
            
        case let .nonascending(x):
            Self.size.minus(self.count(x, where: T.ascending)).assert()
            
        case let .descending(x):
            self.count(x, where: T.descending)
            
        case let .nondescending(x):
            Self.size.minus(self.count(x, where: T.descending)).assert()
            
        case .appendix:
            self.count(self.appendix, where: T.descending)
            
        case .nonappendix:
            Self.size.minus(self.count(self.appendix, where: T.descending)).assert()
        }
    }
}
