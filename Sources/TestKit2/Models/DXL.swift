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
/// - Note: Optional values indicate agnostic behavior.
///
@frozen public struct DXL<Element>: CustomTestStringConvertible where
Element: SystemsInteger & UnsignedInteger, Element.Element == Element {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let body: [Element]
    public let appendix: Bit?
    public let mode: Signedness?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ body: [Element], _ appendix: Bit? = nil, _ mode: Signedness? = nil) {
        self.init(body, repeating: appendix, as: mode)
    }
    
    @inlinable public init(_ body: [Element], repeating appendix: Bit? = nil, as mode: Signedness? = nil) {
        self.body = body
        self.appendix = appendix
        self.mode = mode
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var testDescription: String {
        let mode = switch self.mode {
        case Optional.none:                      "B"
        case Optional.some(Signedness.unsigned): "U"
        case Optional.some(Signedness  .signed): "S"
        }
        
        let size = String(describing: Element.size)
        let body = String(describing:    self.body)
        let appendix = self.appendix?.description ?? "X"
        return "\(mode)\(size)\(body)...\(appendix)"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func perform(
        reading: (inout        DataInt<Element>, Signedness) -> Void,
        writing: (inout MutableDataInt<Element>, Signedness) -> Void
    ) {
        
        self.reading(reading)
        self.writing(writing)
    }
    
    @inlinable public func reading(_ action: (inout DataInt<Element>, Signedness) -> Void) {
        self.combinations { appendix, mode in
            self.body.withUnsafeBufferPointer {
                var data = DataInt($0, repeating: appendix)!
                action(&data, mode)
            }
        }
    }
    
    @inlinable public func writing(_ action: (inout MutableDataInt<Element>, Signedness) -> Void) {
        self.combinations { appendix, mode in
            var x = self.body; x.withUnsafeMutableBufferPointer {
                var data = MutableDataInt($0, repeating: appendix)!
                action(&data, mode)
            }
        }
    }
    
    @inlinable public borrowing func combinations(_ action: (Bit, Signedness) -> Void) {
        for appendix in Bit.all where (self.appendix ?? appendix) == appendix {
            for mode in Signedness.all where (self.mode ??  mode) == mode {
                action(appendix, mode)
            }
        }
    }
}
