//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: BitCastable {
    
    public typealias BitPattern = Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: UX) {
        self = source.base
    }
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

//*============================================================================*
// MARK: * UInt x 8
//*============================================================================*

extension UInt8: BitCastable {
    
    public typealias BitPattern = Magnitude
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: U8) {
        self = source.base
    }
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

//*============================================================================*
// MARK: * UInt x 16
//*============================================================================*

extension UInt16: BitCastable {
    
    public typealias BitPattern = Magnitude
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: U16) {
        self = source.base
    }
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

//*============================================================================*
// MARK: * UInt x 32
//*============================================================================*

extension UInt32: BitCastable {
    
    public typealias BitPattern = Magnitude
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: U32) {
        self = source.base
    }
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

//*============================================================================*
// MARK: * UInt x 64
//*============================================================================*

extension UInt64: BitCastable {
    
    public typealias BitPattern = Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: U64) {
        self = source.base
    }
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}
