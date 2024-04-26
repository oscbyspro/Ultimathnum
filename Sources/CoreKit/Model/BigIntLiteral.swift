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
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
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
    
    @inlinable public var size: UX {
        UX(IX(self.base.bitWidth))
    }
    
    /// A three-way comparison against zero.
    @inlinable public func signum() -> Signum {
        IX(self.base.signum()).signum()
    }
    
    /// The word at the given index, from least significant to most.
    @inlinable public subscript(index: UX) -> UX {
        if  let index = IX.exactly(index).optional() {
            return UX(bitPattern: self.base[Int(index)])
        }   else {
            return UX.init(repeating: self.appendix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withUnsafeBinaryIntegerElements<T>(_ action: (DataInt<UX>) throws -> T) rethrows -> T {
        try self.withUnsafeBinaryIntegerBody {
            try action(DataInt($0, repeating: self.appendix))
        }
    }
    
    @inlinable public func withUnsafeBinaryIntegerBody<T>(_ action: (DataInt<UX>.Body) throws -> T) rethrows -> T {
        let count = IX(self.size.division(Divisor(unchecked: UX.size)).ceil().assert())
        return try Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: Int(count)) { buffer in
            //=--------------------------------------=
            // pointee: initialization
            //=--------------------------------------=
            for index in IX.zero ..< count {
                buffer.initializeElement(at: Int(index), to: self[UX(bitPattern: index)])
            }
            //=--------------------------------------=
            // pointee: deferred deinitialization
            //=--------------------------------------=
            defer {
                buffer[..<Int(count)].deinitialize()
            }
            //=--------------------------------------=
            return try action(DataInt.Body(UnsafeBufferPointer(buffer))!)
        }
    }
}
