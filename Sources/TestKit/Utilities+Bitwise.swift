//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Utilities x Bitwise x Data Integer
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bits: some RandomAccessCollection<Bit> {
        self.buffer().lazy.flatMap(\.bits)
    }
}

//*============================================================================*
// MARK: * Utilities x Bitwise x Binary Integer
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bits: LazyMapSequence<Range<IX>, Bit> {
        Shift<Magnitude>.all.map({ self[$0] })
    }
}
