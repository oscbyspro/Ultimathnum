//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Infini Int x Stdlib
//*============================================================================*

extension InfiniInt: Interoperable where Self: FiniteInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming Stdlib) {
        self = source.base
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        Stdlib(self)
    }
    
    //*========================================================================*
    // MARK: * Stdlib
    //*========================================================================*
    
    @frozen public struct Stdlib: AdapterInteger, Swift.SignedInteger {
        
        public typealias Base = InfiniInt
        
        public typealias IntegerLiteralType = Base.IntegerLiteralType
        
        public typealias Magnitude = Self
        
        //=--------------------------------------------------------------------=
        // MARK: Metadata
        //=--------------------------------------------------------------------=
        
        @inlinable public static var isSigned: Bool {
            Base.isSigned
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public var base: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: consuming Base) {
            self.base = base
        }
        
        @inlinable public init(raw source: consuming Base.BitPattern) {
            self.init(Base(raw: source))
        }
        
        @inlinable public consuming func load(as type: Base.BitPattern.Type) -> Base.BitPattern {
            self.base.load(as: Base.BitPattern.self)
        }
    }
}
