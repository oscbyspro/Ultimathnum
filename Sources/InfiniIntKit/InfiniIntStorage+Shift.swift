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
// MARK: * Infini Int Storage x Shift
//*============================================================================*

extension InfiniIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func resizeByLenientUpshift(major: IX, minor: IX) {
        //=--------------------------------------=
        Swift.assert(major >= 00000000000)
        Swift.assert(UX(bitPattern: minor) < UX(size: Element.self))
        //=--------------------------------------=
        let test = BitSelection.Integer.descending(self.appendix)
        let last   = self.body.last ?? Element(repeating: Bit.zero)
        let target = self.count + major + IX(Bit(IX(load: last.count(test)) < minor))
        //=--------------------------------------=
        self.resize(minCount: target)
        self.withUnsafeMutableBinaryIntegerBody {
            $0.upshift(environment: Element(), major: major, minor: minor)
        }
    }
    
    @inlinable internal mutating func resizeByLenientDownshift(major: IX, minor: IX) {
        //=--------------------------------------=
        Swift.assert(major >= 00000000000)
        Swift.assert(UX(bitPattern: minor) < UX(size: Element.self))
        //=--------------------------------------=
        let test = BitSelection.Integer.nondescending(self.appendix)
        let last   = self.body.last ?? Element(repeating: self.appendix)
        let target = self.count - major - IX(Bit(IX(load: last.count(test)) < minor))
        //=--------------------------------------=
        if  target > 0 {
            let environment = Element(repeating: self.appendix)
            self.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(environment: environment, major: major, minor: minor)
            }
            
            self.resize(maxCount: target)
        }   else {
            self.body.removeAll(keepingCapacity: true)
        }
    }
}