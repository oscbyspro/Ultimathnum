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
        self.count(bit, where: BitSelection.anywhere)
    }
    
    @inlinable public func count(_ selection: BitSelection.Composition) -> Magnitude {
        typealias T = BitSelection
        typealias E = BitSelection.Composition
        return switch selection {
        case .each         (let bit): self.count(bit, where: T.anywhere)
        case .ascending    (let bit): self.count(bit, where: T.ascending)
        case .nonascending (let bit): Self.bitWidth.minus(self.count(bit, where: T.ascending )).assert()
        case .descending   (let bit): self.count(bit, where: T.descending)
        case .nondescending(let bit): Self.bitWidth.minus(self.count(bit, where: T.descending)).assert()
        case .appendix:    self.count(self.appendix,  where: T.descending)
        case .nonappendix: Self.bitWidth.minus(self.count(self.appendix,  where: T.descending)).assert()
        }
    }
}
