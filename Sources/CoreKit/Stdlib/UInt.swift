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

extension UInt: BaseInteger {
        
    public typealias BitPattern = Magnitude
    
    public typealias Mode = Unsigned
}

extension UInt8: BaseInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Mode = Unsigned
}

extension UInt16: BaseInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Mode = Unsigned
}

extension UInt32: BaseInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Mode = Unsigned
}

extension UInt64: BaseInteger {
    
    public typealias BitPattern = Magnitude
    
    public typealias Mode = Unsigned
}
