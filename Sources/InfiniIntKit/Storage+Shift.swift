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
    
    /// - Note: The result is normalized.
    @inlinable internal mutating func upshift(major: IX, minor: IX) {
        defer {
            Swift.assert(self.isNormal)
        }
        //=--------------------------------------=
        Swift.assert(major >= 0000)
        Swift.assert(UX(raw: minor) < UX(size: Element.self))
        //=--------------------------------------=
        if !Bool(self.appendix), self.body.isEmpty {
            
        }   else if minor.isZero {
            if !major.isZero {
                let zeros = repeatElement(Element.zero, count: Int(major))
                self.body.insert(contentsOf: zeros, at: Int.zero)
            }
            
        }   else {
            let edge = self.body.last ?? Element(repeating: .zero)
            let margin = IX(raw: edge.descending(self.appendix))
            let target = self.count + major + IX(Bit(margin < minor))
            
            self.resize(minCount: target)
            
            self.withUnsafeMutableBinaryIntegerBody {
                $0.upshift(major: major, minorAtLeastOne: minor)
            }
        }
        
        Swift.assert(self.isNormal)
    }
    
    /// - Note: The result is normalized.
    @inlinable internal mutating func downshift(major: IX, minor: IX) {
        //=--------------------------------------=
        Swift.assert(major >= 0000)
        Swift.assert(UX(raw: minor) < UX(size: Element.self))
        //=--------------------------------------=
        guard let edge = self.body.last else { return }
        //=--------------------------------------=
        let margin = IX(raw: edge.nondescending(self.appendix))
        let difference = major + IX(Bit(margin <= minor))
        //=--------------------------------------=
        if  difference >= self.count {
            self.body.removeAll(keepingCapacity: true)

        }   else if minor.isZero {
            self.body.removeSubrange(..<Int(difference))

        }   else {
            let environment = Element(repeating: self.appendix)
            self.withUnsafeMutableBinaryIntegerBody {
                $0.downshift(major: major, minorAtLeastOne: minor, environment: environment)
            }

            self.resize(maxCount: self.count.minus(difference).unchecked())
        }
    }
}
