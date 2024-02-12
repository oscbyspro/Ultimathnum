//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int
//*============================================================================*

@frozen public struct InfiniInt: SignedInteger {
    
    public typealias Element = IX
    
    public typealias IntegerLiteralType = StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Magnitude {
        Magnitude.bitWidth
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked storage: consuming Storage) {
        self.storage = storage
        Swift.assert(self.storage.isNormal)
    }
    
    @inlinable init(normalizing storage: consuming Storage) {
        self.storage = storage
        self.storage.normalize()
    }
    
    @inlinable public init(bitPattern: consuming Magnitude) {
        self.init(unchecked: bitPattern.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: Magnitude {
        consuming get {
            Magnitude(unchecked: self.storage)
        }
    }
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            Magnitude(bitPattern: Overflow.ignore({ self < 0 ? try self.negated() : self }))
        }
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    @frozen public struct Magnitude: UnsignedInteger {
                
        public typealias Element = UX
        
        public typealias IntegerLiteralType = StaticBigInt
        
        public typealias Magnitude = Self
        
        //=--------------------------------------------------------------------=
        // MARK: Meta Data
        //=--------------------------------------------------------------------=
        
        @inlinable public static var bitWidth: Magnitude {
            Magnitude.max
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(unchecked storage: consuming Storage) {
            self.storage = storage
            Swift.assert(self.storage.isNormal)
        }
        
        @inlinable init(normalizing storage: consuming Storage) {
            self.storage = storage
            self.storage.normalize()
        }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    /// ### Development
    ///
    /// - TODO: This is a minimum viable product. Improve it at some point.
    ///
    @frozen @usableFromInline struct Storage: Hashable {
        
        @usableFromInline typealias Base = ContiguousArray<UX>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The un/signed source.
        public var `base`: Base
        
        /// The bit extension of the un/signed source.
        public var `extension`: Bit.Extension<Element.Magnitude>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: Base, repeating element: Bit.Extension<Element.Magnitude>) {
            self.base = base
            self.extension = element
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable var isNormal: Bool {
            self.base.last != self.extension.element
        }
        
        @inlinable mutating func normalize() {
            while self.base.last == self.extension.element {
                ((self.base)).removeLast()
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IXL = InfiniInt
public typealias UXL = InfiniInt.Magnitude
