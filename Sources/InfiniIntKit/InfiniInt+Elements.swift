//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int x Elements x Signed
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: BitCastable<Element.BitPattern> {
        fatalError("TODO")
    }

    @inlinable public init<T>(load source: inout SequenceInt<T, Element.Magnitude>.Stream) {
        fatalError("TODO")
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern> {
        fatalError("TODO")
    }
    
    @inlinable public var elements: SequenceInt<ContiguousArray<Element.Magnitude>, Element.Magnitude> {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * Infini Int x Elements x Unsigned
//*============================================================================*

extension InfiniInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init<T>(load source: T) where T: BitCastable<Element.BitPattern> {
        fatalError("TODO")
    }

    @inlinable public init<T>(load source: inout SequenceInt<T, Element.Magnitude>.Stream) {
        fatalError("TODO")
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern> {
        fatalError("TODO")
    }
    
    @inlinable public var elements: SequenceInt<ContiguousArray<Element.Magnitude>, Element.Magnitude> {
        fatalError("TODO")
    }
}
