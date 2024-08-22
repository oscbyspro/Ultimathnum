//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division
//*============================================================================*

@frozen public struct Division<Quotient, Remainder>: BitCastable, Equatable,
Recoverable, Sendable where Quotient: BinaryInteger, Remainder: BinaryInteger {
    
    public typealias Quotient  = Quotient
    
    public typealias Remainder = Remainder
    
    public typealias BitPattern = Division<Quotient.Magnitude, Remainder.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var quotient:  Quotient
    public var remainder: Remainder
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(quotient: Quotient, remainder: Remainder) {
        self.quotient  = quotient
        self.remainder = remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(
            quotient:  Quotient (raw: source.quotient),
            remainder: Remainder(raw: source.remainder)
        )
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(
            quotient:  BitPattern.Quotient (raw: self.quotient),
            remainder: BitPattern.Remainder(raw: self.remainder)
        )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` as a tuple.
    @inlinable public consuming func components() -> (quotient: Quotient, remainder: Remainder) {
        (quotient: self.quotient, remainder: self.remainder)
    }
}
