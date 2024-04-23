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
    
    /// Codes values in `0` to `36` to and from ASCII.
    @frozen @usableFromInline package struct Numerals {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let i00x10: U8
        @usableFromInline let o00x10: U8

        @usableFromInline let i10x36: U8
        @usableFromInline var o10x36: U8
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ radix: UX, letters: Letters) throws {
            if  radix <= 10 {
                self.i00x10 = U8(load: radix)
                self.i10x36 = 00
            }   else if radix <= 36 {
                self.i00x10 = 10
                self.i10x36 = U8(load: radix).minus(10).assert()
            }   else {
                throw TextInt.Failure.invalid
            }
            
            self.o00x10 = 48
            self.o10x36 = letters.start
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func lowercased() -> Self {
            self.o10x36 = Letters.lowercase.start
            return self
        }
        
        @inlinable public consuming func uppercased() -> Self {
            self.o10x36 = Letters.uppercase.start
            return self
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var radix: U8 {
            self.i00x10 &+ self.i10x36
        }
        
        @inlinable public var letters: Letters {
            switch self.o10x36 {
            case Letters.uppercase.start: return Letters.uppercase
            case Letters.lowercase.start: return Letters.lowercase
            default: preconditionFailure(String.brokenInvariant())
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode(_ text: consuming U8) throws -> U8 {
            text &-= 48; if text < self.i00x10 { return text }
            text &-= 17; if text < self.i10x36 { return text &+ 10 }
            text &-= 32; if text < self.i10x36 { return text &+ 10 }
            throw TextInt.Failure.invalid
        }
        
        @inlinable public func encode(_ data: consuming U8) throws -> U8 {
            ((((( ))))); if data < self.i00x10 { return data &+ self.o00x10 }
            data &-= 10; if data < self.i10x36 { return data &+ self.o10x36 }
            throw TextInt.Failure.invalid
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Decodes the given numerals and truncates the result if it is too big.
        @inlinable func load(_ numerals: consuming UnsafeBufferPointer<UInt8>, as type: UX.Type) throws -> UX {
            var value = UX.zero
            let radix = UX(load: self.radix)
            
            for numeral in numerals {
                value &*= radix
                value &+= UX(load: try self.decode(U8(numeral)))
            }
            
            return value as UX
        }
    }
}
