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
    
    /// An ASCII numeral coder.
    @frozen public struct Numerals: Equatable, Sendable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The radix of its number system.
        ///
        /// - Note: It is an integer in `2...36`.
        ///
        public let radix: U8
        
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
        
        /// Creates a new instance with a radix of `10`.
        @inlinable public init() {
            self = Self(radix: 10).unchecked()
        }
        
        /// Creates a new instance using the given `radix` and `letters`.
        ///
        /// - Requires: `0 ≤ radix ≤ 36`
        ///
        @inlinable public init?(radix: some BinaryInteger, letters: Letters = .lowercase) {
            guard let radix = UX.exactly(radix).optional() else { return nil }
            self.init(radix:  radix, letters: letters)
        }

        /// Creates a new instance using the given `radix` and `letters`.
        ///
        /// - Requires: `0 ≤ radix ≤ 36`
        ///
        @inlinable public init?(radix: UX, letters: Letters = .lowercase) {
            self.radix = U8(load: radix)
            self.o1036 = (letters.start)
            
            if  radix <=  10 {
                self.i0010 = self.radix
                self.i1036 = 0000000000
                
            }   else if radix <= 36 {
                self.i0010 = 0000000010
                self.i1036 = self.radix.minus(10).unchecked()
                
            }   else {
                return nil
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        /// Returns an similar instance that encodes `lowercase` letters.
        @inlinable public consuming func lowercased() -> Self {
            self.letters(Letters.lowercase)
        }
        
        /// Returns an similar instance that encodes `uppercase` letters.
        @inlinable public consuming func uppercased() -> Self {
            self.letters(Letters.uppercase)
        }
        
        /// Returns an similar instance that encodes the given `letters`.
        @inlinable public consuming func letters(_ letters: Letters) -> Self {
            self.o1036 = letters.start
            return self
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// The kind of letters produced by its encoding methods.
        @inlinable public var letters: Letters {
            if  self.o1036 == Letters.uppercase.start {
                return Letters.uppercase
            }   else {
                Swift.assert(self.o1036 == Letters.lowercase.start)
                return Letters.lowercase
            }
        }
        
        /// An ASCII numeral to integer conversion.
        ///
        /// - Returns: A integer in `0..<radix`.
        ///
        /// - Note: This conversion is case-insensitive.
        ///
        @inlinable public func decode(_ data: U8) -> Optional<U8> {
            var next = data &- 48
            
            if  next < self.i0010 {
                return next
            }
            
            next = (data | 32) &- 97
            
            if  next < self.i1036 {
                return next &+ 10
            }
            
            return nil
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
        @inlinable public func encode(_ data: U8) -> Optional<U8> {
            if  data < self.i0010 {
                return data &+ 48
            }
            
            let next = data &- 10
            
            if  next < self.i1036 {
                return next &+ self.o1036
            }
            
            return nil
        }
    }
}
