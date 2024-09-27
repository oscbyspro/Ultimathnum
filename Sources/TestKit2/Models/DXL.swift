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
// MARK: * DXL
//*============================================================================*

/// A data integer source.
///
/// - Note: Optional values are used to indicate agnostic behavior.
///
@frozen public struct DXL<Element>: CustomTestStringConvertible where Element: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let body: [Element]
    public let appendix: Bit?
    public let mode: Signedness?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ body: [Element], repeating appendix: Bit? = nil, mode: Signedness? = nil) {
        self.body = body
        self.appendix = appendix
        self.mode = mode
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var testDescription: String {
        let mode = switch self.mode {
        case Optional.some(Signedness.unsigned): "U"
        case Optional.some(Signedness  .signed): "S"
        default: "B"
        }
        
        let size = IX(size: Element.self)
        
        let body = String(describing: self.body)
        
        let appendix = switch self.appendix {
        case Optional.some(Bit.zero): "0"
        case Optional.some(Bit.one ): "1"
        default: "X"
        }
        
        return "\(mode)\(size)\(body)...\(appendix)"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func perform(
        reading: (inout        DataInt<Element>, Signedness) -> Void,
        writing: (inout MutableDataInt<Element>, Signedness) -> Void
    ) {
        
        var copy = self.body
        copy.withUnsafeBufferPointer {
            if  self.appendix != Bit.one, self.mode != Signedness.signed {
                var data = DataInt($0, repeating: Bit.zero)!
                reading(&data, Signedness.unsigned)
            }
        }
        
        copy = self.body
        copy.withUnsafeBufferPointer {
            if  self.appendix != Bit.one, self.mode != Signedness.unsigned {
                var data = DataInt($0, repeating: Bit.zero)!
                reading(&data, Signedness.signed)
            }
        }
        
        copy = self.body
        copy.withUnsafeBufferPointer {
            if  self.appendix != Bit.zero, self.mode != Signedness.signed {
                var data = DataInt($0, repeating: Bit.one)!
                reading(&data, Signedness.unsigned)
            }
        }
        
        copy = self.body
        copy.withUnsafeBufferPointer {
            if  self.appendix != Bit.zero, self.mode != Signedness.unsigned {
                var data = DataInt($0, repeating: Bit.one)!
                reading(&data, Signedness.signed)
            }
        }
        
        copy = self.body
        copy.withUnsafeMutableBufferPointer {
            if  self.appendix != Bit.one, self.mode != Signedness.signed {
                var data = MutableDataInt($0, repeating: Bit.zero)!
                writing(&data, Signedness.unsigned)
            }
        }
        
        copy = self.body
        copy.withUnsafeMutableBufferPointer {
            if  self.appendix != Bit.one, self.mode != Signedness.unsigned {
                var data = MutableDataInt($0, repeating: Bit.zero)!
                writing(&data, Signedness.signed)
            }
        }
        
        copy = self.body
        copy.withUnsafeMutableBufferPointer {
            if  self.appendix != Bit.zero, self.mode != Signedness.signed {
                var data = MutableDataInt($0, repeating: Bit.one)!
                writing(&data, Signedness.unsigned)
            }
        }
        
        copy = self.body
        copy.withUnsafeMutableBufferPointer {
            if  self.appendix != Bit.zero, self.mode != Signedness.unsigned {
                var data = MutableDataInt($0, repeating: Bit.one)!
                writing(&data, Signedness.signed)
            }
        }
    }
}
