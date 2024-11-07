//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Swift IEEE 754
//*============================================================================*

public protocol SwiftIEEE754: Swift.BinaryFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static func random(in range:       Range<Self>, using randomness: inout some Swift.RandomNumberGenerator) -> Self
    static func random(in range: ClosedRange<Self>, using randomness: inout some Swift.RandomNumberGenerator) -> Self
}

//*============================================================================*
// MARK: * Swift IEEE 754 x Models
//*============================================================================*

extension Float32: SwiftIEEE754 { }
extension Float64: SwiftIEEE754 { }
