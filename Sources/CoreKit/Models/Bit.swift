//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit
//*============================================================================*

@frozen public struct Bit: BitCastable, BitOperable, Comparable, Hashable, ExpressibleByIntegerLiteral, Sendable {
    
    public typealias BitPattern = Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// A bit set to `0`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let zero = 0 as Self
    
    
    /// A bit set to `1`.
    ///
    /// - Note: A bit can only bet set to `0` or `1`.
    ///
    public static let one  = 1 as Self
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Sign) {
        self.init(raw: source)
    }
    
    @inlinable public init(_ source: Bool) {
        self.init(raw: source)
    }
    
    @inlinable public init(integerLiteral: IX.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.init(false)
        }   else if integerLiteral == 1 {
            self.init(true )
        }   else {
            Swift.preconditionFailure(String.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: BitPattern) {
        self.base = source
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self.base
    }
}
