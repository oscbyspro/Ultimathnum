//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Reinterpretation x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Temporarily rebinds its elements to the given `type` and performs
    /// the `action` on the reinterpreted instance.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public func reinterpret<Destination, Value>(
        as type: Destination.Type,
        perform action: (DataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        
        try self.body.reinterpret(as: Destination.self) {
            try action(.init($0, repeating: self.appendix))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is U8
//=----------------------------------------------------------------------------=

extension DataInt where Element == U8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the first element of the given `type` then drops it.
    @inlinable public mutating func next<Destination>(
        as type: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        defer {
            self = self[UX(raw: MemoryLayout<Destination>.stride)...]
        }
        
        return self.load(as: Destination.self)
    }
    
    /// Returns the first element of the given `type`.
    @inlinable public borrowing func load<Destination>(
        as type: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        if  IX(MemoryLayout<Destination>.size) <= self.body.count {
            return UnsafeRawPointer(self.body.start).loadUnaligned(as: Destination.self)
            
        }   else if IX(MemoryLayout<Destination>.size) == 1 {
            return Destination(repeating: self.appendix)
            
        }   else {
            var index = self.body.count
            var value = Destination(repeating: self.appendix)
            
            while index  > 0 as IX {
                index  &-= 1 as IX
                value &<<= 8 as Destination
                value   |= Destination(load: self.body[unchecked: index])
            }
            
            return value
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Reinterpretation x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Temporarily rebinds its elements to the given `type` and performs
    /// the `action` on the reinterpreted instance.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public func reinterpret<Destination, Value>(
        as type: Destination.Type,
        perform action: (MutableDataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        
        try self.body.reinterpret(as: Destination.self) {
            try action(.init($0, repeating: self.appendix))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is U8
//=----------------------------------------------------------------------------=

extension MutableDataInt where Element == U8 {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the first element of the given `type` then drops it.
    @inlinable public mutating func next<Destination>(
        as type: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        var immutable = Immutable.init(self)

        defer {
            self = Self(mutating: immutable)
        }
        
        return immutable.next(as: Destination.self)
    }
    
    /// Returns the first element of the given `type`.
    @inlinable public borrowing func load<Destination>(
        as type: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        Immutable(self).load(as: Destination.self)
    }
}

//*============================================================================*
// MARK: * Data Int x Reinterpretation x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Temporarily rebinds its elements to the given `type` and performs
    /// the `action` on the reinterpreted instance.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public borrowing func reinterpret<Destination, Value>(
        as type: Destination.Type,
        perform action: (DataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        
        precondition(MemoryLayout<Element>.size      % MemoryLayout<Destination>.size      == 0)
        precondition(MemoryLayout<Element>.stride    % MemoryLayout<Destination>.stride    == 0)
        precondition(MemoryLayout<Element>.alignment % MemoryLayout<Destination>.alignment == 0)
        
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try (self.start).withMemoryRebound(to: Destination.self, capacity: Int(count)) {
            try action(DataInt<Destination>.Body.init($0, count: count))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is U8
//=----------------------------------------------------------------------------=

extension DataInt.Body where Element == U8 {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count<Destination>(
        as type: Destination.Type
    )   -> IX where Destination: SystemsInteger & UnsignedInteger {
        
        var count = UX(raw: self.count)
        count   &+= UX(raw: MemoryLayout<Destination>.stride).decremented().unchecked()
        count  &>>= UX(raw: UX(raw: MemoryLayout<Destination>.stride).ascending(Bit.zero))
        return IX(raw: count)
    }
}

//*============================================================================*
// MARK: * Data Int x Reinterpretation x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Temporarily rebinds its elements to the given `type` and performs
    /// the `action` on the reinterpreted instance.
    ///
    /// Any attempt to rebind the elements of `self` to a larger element `type`
    /// triggers a precondition failure. In other words, you may only downsize
    /// elements with this method.
    ///
    /// - Requires: `Element.size >= Destination.size`
    ///
    /// - Note: You may always reinterpret its elements as bytes (`U8`).
    ///
    @inlinable public borrowing func reinterpret<Destination, Value>(
        as type: Destination.Type,
        perform action: (MutableDataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        
        try Immutable(self).reinterpret(as: Destination.self) {
            try action(MutableDataInt<Destination>.Body(mutating: $0))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Element is U8
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body where Element == U8 {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count<Destination>(
        as type: Destination.Type
    )   -> IX where Destination: SystemsInteger & UnsignedInteger {
        
        Immutable(self).count(as: Destination.self)
    }
}
