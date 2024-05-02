//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Countable x Count
//*============================================================================*

extension BitCountable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ selection: Bit.Appendix) -> BitCount {
        self.count(.descending(self.appendix))
    }
    
    @inlinable public func count(_ selection: Bit.Nonappendix) -> BitCount {
        self.size().minus(self.count(.appendix)).assert("inverse bit count")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ selection: Bit .Nonascending) -> BitCount {
        self.size().minus(self.count( .ascending(selection.bit))).assert("inverse bit count")
    }
    
    @inlinable public func count(_ selection: Bit.Nondescending) -> BitCount {
        self.size().minus(self.count(.descending(selection.bit))).assert("inverse bit count")
    }
}
