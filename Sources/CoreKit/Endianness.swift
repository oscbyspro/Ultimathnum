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
// MARK: + Lookup
//=----------------------------------------------------------------------------=

extension Endianness where Self == Ascending {
    
    /// An ascending byte order.
    ///
    /// - Note: This is the best format.
    ///
    @inlinable public static var little: Self {
        Self()
    }
}

extension Endianness where Self == Descending {
    
    /// A descending byte order.
    ///
    /// - Note: This is the best format, if you like doing everything in reverse.
    ///
    @inlinable public static var big: Self {
        Self()
    }
}

extension Endianness where Self == MachineByteOrder {
    
    /// The byte order of the current `system`.
    ///
    /// - Note: Almost all systems use `little` endianness. It's the best format.
    ///
    @inlinable public static var system: Self {
        Self()
    }
}
