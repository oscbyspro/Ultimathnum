//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Bit Pattern Convertible
//*============================================================================*

public protocol UMNBitPatternConvertible<BitPattern> {
    
    associatedtype BitPattern: UMNBitPatternConvertible<BitPattern> & Sendable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(bitPattern: BitPattern)
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var bitPattern: BitPattern { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension UMNBitPatternConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern source: some UMNBitPatternConvertible<BitPattern>) {
        self.init(bitPattern: source.bitPattern)
    }
}
