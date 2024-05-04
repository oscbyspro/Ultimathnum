//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer Initialization
//*============================================================================*

extension DataInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ body: Body.Buffer, repeating appendix: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: appendix)
    }
    
    @inlinable public init(_ start: Body.Address, count: IX, repeating appendix: Bit = .zero) {
        self.init(Body(start, count: count), repeating: appendix)
    }
}
