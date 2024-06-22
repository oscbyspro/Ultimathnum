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
@frozen public struct StdlibInt: Swift.LosslessStringConvertible, Swift.Sendable, Swift.SignedInteger {
        
    @usableFromInline typealias Base = InfiniInt<IX>
    
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
    
    @inlinable public init(_ base: consuming InfiniInt<IX>) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: Swift.StaticBigInt) {
        self.base = Base(integerLiteral: integerLiteral)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension InfiniInt<IX> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming StdlibInt) {
        self = source.base
    }
}
