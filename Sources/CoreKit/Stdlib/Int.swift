//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Int
//*============================================================================*

extension Int: CoreInteger {
    
    public typealias Signitude = Self
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public init(raw source: Magnitude) {
        self.init(bitPattern:  source)
    }
    
    @inlinable public var bitPattern: Magnitude {
        Magnitude(bitPattern:  self)
    }
}

extension Int8: CoreInteger {
    
    public typealias Signitude = Self
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public init(raw source: Magnitude) {
        self.init(bitPattern:  source)
    }
    
    @inlinable public var bitPattern: Magnitude {
        Magnitude(bitPattern:  self)
    }
}

extension Int16: CoreInteger {
        
    public typealias Signitude = Self
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public init(raw source: Magnitude) {
        self.init(bitPattern:  source)
    }
    
    @inlinable public var bitPattern: Magnitude {
        Magnitude(bitPattern:  self)
    }
}

extension Int32: CoreInteger {
        
    public typealias Signitude = Self
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public init(raw source: Magnitude) {
        self.init(bitPattern:  source)
    }
    
    @inlinable public var bitPattern: Magnitude {
        Magnitude(bitPattern:  self)
    }
}

extension Int64: CoreInteger {
        
    public typealias Signitude = Self
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public init(raw source: Magnitude) {
        self.init(bitPattern:  source)
    }
    
    @inlinable public var bitPattern: Magnitude {
        Magnitude(bitPattern:  self)
    }
}
