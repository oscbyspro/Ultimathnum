//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Numerals
//*============================================================================*

extension TextInt {
    
    //*========================================================================*
    // MARK: * Numerals
    //*========================================================================*
    
    /// An ASCII numeral coder.
    @frozen @usableFromInline package struct Numerals: Equatable, Sendable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The number of numerals in the range `0..<10`.
        ///
        /// - Note: It equals `min(10, radix)`.
        ///
        @usableFromInline let i0010: U8
        
        /// The number of numerals in the range `10..<36`.
        ///
        /// - Note: It equals `max(0, radix - 10)`.
        ///
        @usableFromInline let i1036: U8
        
        /// The start for numerals in the range `0..<10`
        ///
        /// - Note: The `decimal` start is `48`.
        ///
        @usableFromInline let o0010: U8
        
        /// The start for numerals in the range `10..<36`
        ///
        /// - Note: The uppercase start is `65`.
        ///
        /// - Note: The lowercase start is `97`.
        ///
        @usableFromInline var o1036: U8
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// - Requires: `radix <= 36`
        @inlinable public init(_ radix: UX, letters: Letters) throws {
            if  radix <= 10 {
                self.i0010 = U8(load: radix)
                self.i1036 = 00
            }   else if radix <= 36 {
                self.i0010 = 10
                self.i1036 = U8(load: radix).minus(10).unchecked()
            }   else {
                throw TextInt.Error.invalid
            }
            
            self.o0010 = 48
            self.o1036 = letters.start
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        /// Returns an similar instance that encodes lowercased letters.
        @inlinable public consuming func lowercased() -> Self {
            self.o1036 = Letters.lowercase.start
            return self
        }
        
        /// Returns an similar instance that encodes uppercased letters.
        @inlinable public consuming func uppercased() -> Self {
            self.o1036 = Letters.uppercase.start
            return self
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// The radix of its number system.
        ///
        /// - Returns: A integer in `2...36`.
        ///
        @inlinable public var radix: U8 {
            self.i0010 &+ self.i1036
        }
        
        /// The kind of letters produced by its encoding methods.
        @inlinable public var letters: Letters {
            if  self.o1036 == Letters.uppercase.start {
                return Letters.uppercase
            }   else {
                Swift.assert(self.o1036 == Letters.lowercase.start)
                return Letters.lowercase
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// An ASCII numeral to integer conversion.
        ///
        /// - Returns: A integer in `0..<radix`.
        ///
        /// - Note: This conversion is case-insensitive.
        ///
        @inlinable public func decode(_ data: U8) throws -> U8 {
            var next = data &- 48
            
            if  next < self.i0010 {
                return next
            }
            
            next = (data | 32) &- 97
            
            if  next < self.i1036 {
                return next &+ 10
            }
            
            throw TextInt.Error.invalid
        }
        
        /// An integer to ASCII numeral conversion.
        ///
        /// - The `decimal` range is: `48...57`.
        ///
        /// - The `uppercase` range is: `65...90`.
        ///
        /// - The `lowercase` range is: `97...122`.
        ///
        /// - Note: This conversion is case-sensitive.
        ///
        @inlinable public func encode(_ data: U8) throws -> U8 {
            if  data < self.i0010 {
                return data &+ self.o0010
            }
            
            let next = data &- 10
            
            if  next < self.i1036 {
                return next &+ self.o1036
            }
            
            throw TextInt.Error.invalid
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Decodes the given `numerals` and truncates the result if it is too big.
        @inlinable internal func load(_ numerals: borrowing UnsafeBufferPointer<UInt8>, as type: UX.Type) throws -> UX {
            var value = UX.zero
            let radix = UX(load: self.radix)
            
            for numeral:  UInt8 in numerals {
                value &*= radix
                value &+= UX(load: try self.decode(U8(numeral)))
            }
            
            return value as UX
        }
    }
}
