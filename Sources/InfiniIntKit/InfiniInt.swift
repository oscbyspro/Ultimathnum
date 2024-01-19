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

/// ### Development
///
/// Consider making the storage model the same model that is used by init(load:)
/// and perhaps words. This would maximize interoperability.
///
@frozen public struct InfiniInt: SignedInteger {
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Words = ContiguousArray<UX>
    
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
            if  self  < 0 {
                Overflow.ignore(&self, map:{ try $0.negated() })
            }
            
            return Magnitude(bitPattern: self)
        }
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    @frozen public struct Magnitude: UnsignedInteger {
                
        public typealias IntegerLiteralType = StaticBigInt
        
        public typealias Words = ContiguousArray<UX>
        
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
    /// - TODO: Consider short array optimization based on enum.
    ///
    /// - TODO: Consider short array optimization based on emptiness.
    ///
    @frozen @usableFromInline struct Storage: Hashable {
        
        @usableFromInline typealias Body = ContiguousArray<UX>
        @usableFromInline typealias Tail = Body.Element
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var body: Body
        @usableFromInline var tail: Tail
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(body: Body, tail: Tail) {
            self.body = body
            self.tail = tail
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable var isNormal: Bool {
            self.body.last != self.tail
        }
        
        @inlinable mutating func normalize() {
            while self.body.last == self.tail {
                ((self.body)).removeLast()
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IXL = InfiniInt
public typealias UXL = InfiniInt.Magnitude
