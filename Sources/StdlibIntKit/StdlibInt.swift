//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int
//*============================================================================*

/// An arbitrary `Swift.SignedInteger` value type.
@frozen public struct StdlibInt: BitCastable, Swift.LosslessStringConvertible, Swift.Sendable, Swift.SignedInteger {
    
    @usableFromInline typealias Base = IXL
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Base.isSigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming IXL) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: Swift.StaticBigInt) {
        self.base = Base(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming IXL.BitPattern) {
        self.init(Base(raw: source))
    }
    
    @inlinable public consuming func load(as type: IXL.BitPattern.Type) -> IXL.BitPattern {
        self.base.load(as: IXL.BitPattern.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension IXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming StdlibInt) {
        self = source.base
    }
}
