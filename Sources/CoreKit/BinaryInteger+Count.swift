//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Count
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func size() -> Magnitude {
        Self.size
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ selection: Bit.Appendix) -> Magnitude {
        self.count(.descending(self.appendix)) // TODO: await borrowing fix
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> Magnitude {
        self.size().minus(self.count(.appendix)).assert("inverse bit count")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonascending) -> Magnitude {
        self.size().minus(self.count( .ascending(selection.bit))).assert("inverse bit count")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nondescending) -> Magnitude {
        self.size().minus(self.count(.descending(selection.bit))).assert("inverse bit count")
    }
}
