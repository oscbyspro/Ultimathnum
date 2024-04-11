//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Body
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func body() -> Prefix {
        let ratio = UX(bitPattern: MemoryLayout<Element>.stride)
        let major = self.base.body.count &>> IX(bitPattern: ratio.count(0, where: .ascending))
        let minor = self.base.body.count &   IX(bitPattern: ratio.minus(1).assert())
        return Prefix(self, count: Int(bitPattern: major.plus(IX(Bit(minor != 0))).assert()))
    }
}
