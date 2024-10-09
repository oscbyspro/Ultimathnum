//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Clamping
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by clamping the given `source`.
    @inlinable public init(clamping source: borrowing some FiniteInteger) {
        self.init(clamping: source)!
    }
    
    /// Creates a new instance by clamping the given `source`.
    @_disfavoredOverload // BinaryInteger.init(clamping: some FiniteInteger)
    @inlinable public init(clamping source: borrowing some BinaryInteger) where Self: EdgyInteger {
        self.init(clamping: source)!
    }
    
    /// Creates a new instance by clamping the given `source`.
    ///
    /// The following illustration shows when clamping is possible:
    ///
    ///                ┌────────────┬────────────┐
    ///                │ Systems    │ Arbitrary  |
    ///     ┌──────────┼────────────┤────────────┤
    ///     │   Signed │ any        │ source ∈ ℤ │
    ///     ├──────────┼────────────┤────────────┤
    ///     │ Unsigned │ any        │ any        │
    ///     └──────────┴────────────┴────────────┘
    ///
    /// - Note: This is the most generic version of `init(clamping:)`.
    ///
    @_disfavoredOverload // BinaryInteger.init(clamping: some FiniteInteger)
    @inlinable public init?(clamping source: borrowing some BinaryInteger) {
        if  Self.isArbitrary {
            
            if  Self.isSigned, source.isInfinite {
                return nil
                
            }   else if !Self.isSigned, source.isNegative {
                self.init()
                
            }   else {
                self.init(load: source)
            }
            
        }   else {
            
            if  let  instance = Self.exactly(source).optional() {
                self = instance
                
            }   else if Self.isSigned {
                self = Self.lsb.up(Shift.max)
                self = source.isNegative ? self : self.toggled()
                
            }   else {
                self.init(repeating: Bit.init(!source.isNegative))
            }
            
        }
    }
}
