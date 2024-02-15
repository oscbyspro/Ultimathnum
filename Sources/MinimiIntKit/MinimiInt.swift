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
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: Bit.BitPattern) {
        self.base = Bit(bitPattern: bitPattern)
    }
    
    @inlinable public init(integerLiteral: Signedness.IntegerLiteralType) {
        if  Signedness(integerLiteral: integerLiteral) == 0 {
            self.base = 0
        }   else if Signedness(integerLiteral: integerLiteral) == (Self.isSigned ? -1 : 1) {
            self.base = 1
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: Bit.BitPattern {
        consuming get {
            Bit.BitPattern(bitPattern: self.base)
        }
    }
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            Magnitude(bitPattern: self.bitPattern)
        }
    }
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
