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
// MARK: * Bit Int
//*============================================================================*

/// A signed `1-bit` integer that can represent the values `0` and `-1`.
@frozen public struct BitInt: SystemInteger & SignedInteger {
    
    public typealias BitPattern = Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Magnitude {
        1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Bit) {
        self.bitPattern = (bitPattern)
    }
    
    @inlinable public init(integerLiteral: Swift.Int.IntegerLiteralType) {
        if  integerLiteral == 0 {
            self.bitPattern = 0
        }   else if integerLiteral == -1 {
            self.bitPattern = 1
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
    
    @inlinable public var words: some RandomAccessCollection<UX> {
        consuming get {
            CollectionOfOne(self.load(as: UX.self))
        }
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned `1-bit` integer that can represent the values `0` and `1`.
    @frozen public struct Magnitude: SystemInteger & UnsignedInteger {        
        
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
        
        public let bitPattern: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(bitPattern: Bit) {
            self.bitPattern = (bitPattern)
        }
        
        @inlinable public init(integerLiteral: Swift.UInt.IntegerLiteralType) {
            if  integerLiteral == 0 {
                self.bitPattern = 0
            }   else if integerLiteral == 1 {
                self.bitPattern = 1
            }   else {
                fatalError(.overflow())
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var words: some RandomAccessCollection<UX> {
            consuming get {
                CollectionOfOne(self.load(as: UX.self))
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias I1 = BitInt
public typealias U1 = BitInt.Magnitude
