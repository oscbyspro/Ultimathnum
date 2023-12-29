//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Core Integer
//*============================================================================*

public protocol UMNCoreInteger: UMNBitPatternConvertible, Swift.FixedWidthInteger, Sendable 
where BitPattern == Magnitude.BitPattern, Magnitude: Swift.FixedWidthInteger & UMNCoreInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNCoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public consuming func bitPattern() -> BitPattern {
        Swift.unsafeBitCast(self, to: BitPattern.self)
    }
}

//*============================================================================*
// MARK: * UMN x Core Integer x Swift
//*============================================================================*

extension Int: UMNCoreInteger, UMNSigned {
    public typealias BitPattern = Magnitude
}

extension Int8: UMNCoreInteger, UMNSigned {
    public typealias BitPattern = Magnitude
}

extension Int16: UMNCoreInteger, UMNSigned {
    public typealias BitPattern = Magnitude
}

extension Int32: UMNCoreInteger, UMNSigned {
    public typealias BitPattern = Magnitude
}

extension Int64: UMNCoreInteger, UMNSigned {
    public typealias BitPattern = Magnitude
}

extension UInt: UMNCoreInteger, UMNUnsigned {
    public typealias BitPattern = Magnitude
}

extension UInt8: UMNCoreInteger, UMNUnsigned {
    public typealias BitPattern = Magnitude
}

extension UInt16: UMNCoreInteger, UMNUnsigned {
    public typealias BitPattern = Magnitude
}

extension UInt32: UMNCoreInteger, UMNUnsigned {
    public typealias BitPattern = Magnitude
}

extension UInt64: UMNCoreInteger, UMNUnsigned {
    public typealias BitPattern = Magnitude
}
