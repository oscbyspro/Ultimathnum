//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: CoreInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Signitude  = Int
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

extension UInt8: CoreInteger {
    
    public typealias BitPattern = Magnitude
        
    public typealias Signitude  = Int8
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

extension UInt16: CoreInteger {
    
    public typealias BitPattern = Magnitude
        
    public typealias Signitude  = Int16
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

extension UInt32: CoreInteger {
    
    public typealias BitPattern = Magnitude
        
    public typealias Signitude  = Int32
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}

extension UInt64: CoreInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Signitude  = Int64
    
    @inlinable public static var mode: Unsigned {
        Unsigned()
    }
}
