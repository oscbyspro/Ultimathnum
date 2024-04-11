//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Big Int Literal
//*============================================================================*

@frozen public struct BigIntLiteral: ExpressibleByIntegerLiteral, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Swift.StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Swift.StaticBigInt) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: Swift.StaticBigInt) {
        self.base = Swift.StaticBigInt(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit(self.base.signum() < 0)
    }
    
    @inlinable public var bitWidth: Int {
        self.base.bitWidth
    }
    
    /// A three-way comparison against zero.
    @inlinable public func signum() -> Signum {
        IX(self.base.signum()).signum()
    }
    
    /// The word at the given index, from least significant to most.
    @inlinable public subscript(index: Int) -> UX {
        UX(self.base[index])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withUnsafeBinaryIntegerBody<T>(_ action: (MemoryIntBody<UX>) throws -> T) rethrows -> T {
        let count = IX(self.bitWidth).division(IX(bitWidth: UX.self)).ceil().assert()
        var body  = Array<UX>()
        body.reserveCapacity(Int(bitPattern: count))
        
        for index in 0 ..< count {
            body.append(self[Int(index)])
        }
        
        return try body.withUnsafeBufferPointer {
            try action(MemoryIntBody($0.baseAddress!, count: IX($0.count)))
        }
    }
    
    @inlinable public func withUnsafeBinaryIntegerElements<T>(_ action: (MemoryInt<UX>) throws -> T) rethrows -> T {
        //=--------------------------------------=
        let appendix = self.appendix
        //=--------------------------------------=
        return try self.withUnsafeBinaryIntegerBody {
            try action(MemoryInt($0, repeating: appendix))
        }
    }
}
