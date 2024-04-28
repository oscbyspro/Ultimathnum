//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Load Int x Body
//*============================================================================*

extension LoadInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func body() -> Prefix {
        let ratio = UX(raw: MemoryLayout<Element>.stride)
        var major = UX(raw: self.base.body.count)
        major  &>>= UX(raw: ratio.count(0, where: Bit.Selection.ascending))
        var minor = UX(raw: self.base.body.count)
        minor    &= UX(raw: ratio.minus(1).assert())
        return self.prefix(major.plus(UX(Bit(minor != 0))).assert())
    }
}
