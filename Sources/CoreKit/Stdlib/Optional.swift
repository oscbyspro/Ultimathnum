//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Optional
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit Cast
//=----------------------------------------------------------------------------=

extension Optional: BitCastable where Wrapped: BitCastable {
    
    public typealias BitPattern = Optional<Wrapped.BitPattern>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        if  let source {
            self.init(Wrapped(raw: source))
        }   else {
            self = nil
        }
    }
    
    @inlinable public func load(as type: BitPattern.Type) -> BitPattern {
        if  let self {
            return self.load(as: Wrapped.BitPattern.self)
        }   else {
            return nil
        }
    }
}
