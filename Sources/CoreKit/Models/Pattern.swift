//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Pattern
//*============================================================================*

/// The integer currency type.
///
/// ### Development
///
/// - TODO: Consider helper methods like matches(\_:), etc.
/// - TODO: Consider alternative EndlessInt model.
///
@frozen public struct Pattern<Base> where Base: RandomAccessCollection<UX> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Base
    public let sign: UX
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, isSigned: Bool) {
        self.base = base; self.sign = UX(repeating: U1(bitPattern: isSigned && Swift.Int(bitPattern: base.last ?? 0) < 0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isLessThanZero: Bool {
        self.sign != (0 as UX)
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        self.base.first ?? self.sign
    }
}
