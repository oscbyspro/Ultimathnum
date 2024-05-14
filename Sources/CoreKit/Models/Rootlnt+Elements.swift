//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Root Int
//*============================================================================*

extension RootInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The bit that extends the body of this integer.
    @inlinable public var appendix: Bit {
        Bit(self.base.signum() < 0)
    }
    
    /// The word at `index`, ordered from least significant to most significant.
    @inlinable public subscript(index: UX) -> UX {
        if  let index = IX.exactly(index).optional() {
            return UX(raw: self.base[Int(index)])
        }   else {
            return UX(repeating: self.appendix)
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
        let count = Int(raw: self.count(.entropy).division(Divisor(UX.size)).ceil().assert())
        return try Swift.withUnsafeTemporaryAllocation(of: UX.self, capacity: count) { buffer in
            //=--------------------------------------=
            // pointee: initialization
            //=--------------------------------------=
            for index in Int.zero ..< count {
                buffer.initializeElement(at: index, to: self[UX(raw: index)])
            }
            //=--------------------------------------=
            // pointee: deferred deinitialization
            //=--------------------------------------=
            defer {
                buffer[..<count].deinitialize()
            }
            //=--------------------------------------=
            return try action(DataInt.Body(UnsafeBufferPointer(buffer))!)
        }
    }
}
