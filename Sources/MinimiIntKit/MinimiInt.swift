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

/// A signed `1-bit` integer that can represent the values `0` and `-1`.
@frozen public struct MinimiInt: SystemsInteger & SignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Magnitude {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: Bool) {
        self.bitPattern = (bitPattern)
    }
    
    @inlinable public init(integerLiteral: Swift.Int.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.bitPattern = false
        }   else if integerLiteral == -1 {
            self.bitPattern = true
        }   else {
            fatalError(.overflow())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            Magnitude(bitPattern: self.bitPattern)
        }
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned `1-bit` integer that can represent the values `0` and `1`.
    @frozen public struct Magnitude: SystemsInteger & UnsignedInteger {        
        
        public typealias Magnitude = Self
        
        //=--------------------------------------------------------------------=
        // MARK: Meta Data
        //=--------------------------------------------------------------------=
        
        @inlinable public static var bitWidth: Magnitude {
            1
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let bitPattern: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(bitPattern: Bool) {
            self.bitPattern = (bitPattern)
        }
        
        @inlinable public init(integerLiteral: Swift.UInt.IntegerLiteralType) {
            if  integerLiteral == 0 {
                self.bitPattern = false
            }   else if integerLiteral == 1 {
                self.bitPattern = true
            }   else {
                fatalError(.overflow())
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Selection
    //*========================================================================*
    
    @frozen public enum Selection {
        case all
        case ascending
        case descending
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias I1 = MinimiInt
public typealias U1 = MinimiInt.Magnitude
