//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Randomness x Full
//*============================================================================*

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) {
        guard var start = buffer.baseAddress else { return }
        var count: Swift.Int = buffer.count
        
        while count >= MemoryLayout<Element>.stride {
            start.withMemoryRebound(to: Element.self, capacity: 1) {
                $0.initialize(to: self.next())
            }
            
            start   += MemoryLayout<Element>.stride
            count  &-= MemoryLayout<Element>.stride
        }
        
        if  count > Swift.Int.zero {
            Swift.withUnsafeBytes(of:  self.next()) {
                start.copyMemory(from: $0.baseAddress.unsafelyUnwrapped, byteCount: count)
            }
        }
    }
    
    /// Generates more random data.
    @inlinable public mutating func next<T>(as type: T.Type = T.self) -> T where T: SystemsInteger & UnsignedInteger {
        self.systems(as: T.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates more random data.
    ///
    /// - Requires: The given `type` must be a systems integer.
    ///
    @inlinable internal mutating func systems<T>(as type: T.Type = T.self) -> T where T: UnsignedInteger {
        if  T.size <= Element.size {
            T.init(load: self.next())
            
        }   else {
            T.systems(initializer:{ self.fill($0) })!
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    // TODO: consider DataInt<T>.Body requirement vs UnsafeRawBufferPointer
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func fill(_ buffer: consuming MutableDataInt<U8>.Body) {
        self.fill(buffer.bytes())
    }
    
    @inlinable internal mutating func fill(_ buffer: consuming MutableDataInt<Element>.Body) {
        for index: IX in buffer.indices {
            buffer[unchecked: index] = self.next()
        }
    }
    
    @inlinable internal mutating func fill<T>(_ buffer: consuming MutableDataInt<T>.Body) {
        if  T.size < Element.size {
            buffer.reinterpret(as: U8.self) {
                self.fill($0)
            }
            
        }   else {
            buffer.reinterpret(as: Element.self) {
                self.fill($0)
            }
        }
    }
}
