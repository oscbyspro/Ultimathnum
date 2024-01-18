//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable
//*============================================================================*

public protocol BitCastable<BitPattern> {
    
    associatedtype BitPattern: BitCastable<BitPattern> & Sendable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(bitPattern: consuming BitPattern)
    
    @inlinable var bitPattern: BitPattern { consuming get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern source: consuming some BitCastable<BitPattern>) {
        self.init(bitPattern: source.bitPattern)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Bit Pattern is Self
//=----------------------------------------------------------------------------=

extension BitCastable where BitPattern == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = bitPattern
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get { consume self }
    }
}

//*============================================================================*
// MARK: * Bit Castable x Models
//*============================================================================*

extension Bool: BitCastable {
    public typealias BitPattern = Self
}

extension Int: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int8: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int16: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int32: BitCastable {
    public typealias BitPattern = Magnitude
}

extension Int64: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt8: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt16: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt32: BitCastable {
    public typealias BitPattern = Magnitude
}

extension UInt64: BitCastable {
    public typealias BitPattern = Magnitude
}
