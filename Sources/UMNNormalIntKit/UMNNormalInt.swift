//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * UMN x Normal Int
//*============================================================================*

@frozen public struct UMNNormalInt<Element>: UMNUnsigned & UMNBinaryInteger where Element: UMNUnsigned & UMNTrivialInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(storage: Storage) {
        self.storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Self {
        consuming get { self }
    }
    
    @inlinable public var standard: some Swift.BinaryInteger {
        consuming get { UMNStandardInt(self) }
    }
    
    @inlinable public var words: Words {
        consuming get { Words(self) }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @frozen @usableFromInline enum Storage: Hashable, Sendable {
        case element(Element)
        case array(ContiguousArray<Element>)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

/// An unsigned big integer.
public typealias UXL = UMNNormalInt<UX>
