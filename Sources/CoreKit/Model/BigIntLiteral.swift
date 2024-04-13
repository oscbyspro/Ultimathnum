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

@frozen public struct BigIntLiteral: ExpressibleByIntegerLiteral, NaturallyIndexable, Sendable {
    
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
        let count: IX = IX(self.size.division(UX.size).ceil().assert())
        return try Namespace.withUnsafeTemporaryAllocation(copying: self.prefix(count)) {
            return try action(DataInt(UnsafeBufferPointer($0), repeating: self.appendix)!)
        }
    }
}
