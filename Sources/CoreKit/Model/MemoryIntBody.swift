//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*========================================================================*
// MARK: * Memory Int Body
//*========================================================================*

@frozen public struct MemoryIntBody<Element> where Element: SystemsInteger {
    
    public typealias Element = Element
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    public let start: UnsafePointer<Element>
    public let count: IX
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX) {
        self.start = start
        self.count = count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<OtherElement, Value>(
        to type: OtherElement.Type,
        perform action: (MemoryIntBody<OtherElement>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Self.memoryCanBeRebound(to: OtherElement.self))
        //=--------------------------------------=
        let ratio = IX(MemoryLayout<Self.Element>.stride / MemoryLayout<OtherElement>.stride)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to: OtherElement.self, capacity: Int(count)) {
            try action(MemoryIntBody<OtherElement>($0, count: count))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - TODO: Move this to SystemsInteger, maybe.
    ///
    @inlinable package static func memoryCanBeRebound<OtherElement>(to type: OtherElement.Type) -> Bool where OtherElement: SystemsInteger {
        let size      = MemoryLayout<Self.Element>.size      % MemoryLayout<OtherElement>.size      == 0
        let stride    = MemoryLayout<Self.Element>.stride    % MemoryLayout<OtherElement>.stride    == 0
        let alignment = MemoryLayout<Self.Element>.alignment % MemoryLayout<OtherElement>.alignment == 0
        return Bool(Bit(size) & Bit(stride) & Bit(alignment))
    }
}
