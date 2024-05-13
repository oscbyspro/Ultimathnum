//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Endianness
//*============================================================================*

public protocol Endianness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable var matchesLittleEndianByteOrder: Bool { get }
}

//=----------------------------------------------------------------------------=
// MARK: + System
//=----------------------------------------------------------------------------=

#if _endian(little)
public typealias SystemByteOrder = Ascending
#elseif _endian(big)
public typealias SystemByteOrder = Descending
#else
public typealias SystemByteOrder = Never
#endif

//=----------------------------------------------------------------------------=
// MARK: + Lookup
//=----------------------------------------------------------------------------=

extension Endianness where Self == Ascending {
    @inlinable public static var little: Self {
        Self()
    }
}

extension Endianness where Self == Descending {
    @inlinable public static var big: Self {
        Self()
    }
}

extension Endianness where Self == SystemByteOrder {
    @inlinable public static var system: Self {
        Self()
    }
}
