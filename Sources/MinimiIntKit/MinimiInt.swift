//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Minimi Int
//*============================================================================*

/// An un/signed `1-bit` integer.
@frozen public struct MinimiInt<Signedness>: SystemsInteger where Signedness: SystemsInteger<UX.BitPattern> {
    
    public typealias Element = Self
    
    public typealias Magnitude = MinimiInt<Signedness.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Signedness.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Bit
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension MinimiInt:   SignedInteger where Signedness:   SignedInteger { }
extension MinimiInt: UnsignedInteger where Signedness: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias I1 = MinimiInt<IX>
public typealias U1 = MinimiInt<UX>
