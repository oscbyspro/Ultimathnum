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
// MARK: * Minimi Int
//*============================================================================*

/// An un/signed `1-bit` integer.
@frozen public struct MinimiInt<Mode>: SystemsInteger where Mode: Signedness {
    
    public typealias Element = Self
    
    public typealias Magnitude = MinimiInt<IsUnsigned>
    
    public typealias Mode = Mode
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Mode.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: Int) {
        if  integerLiteral == 0 {
            self.base = 0
        }   else if integerLiteral == (Self.isSigned ? -1 : 1) {
            self.base = 1
        }   else {
            preconditionFailure(String.overflow())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension MinimiInt:   SignedInteger where Mode == IsSigned   { }
extension MinimiInt: UnsignedInteger where Mode == IsUnsigned { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias I1 = MinimiInt<IsSigned>
public typealias U1 = MinimiInt<IsUnsigned>
