//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bad
//*============================================================================*

/// An enumeration of error codes.
public enum Bad: Error {
    
    case any
    case addition
    case division
    case divisor
    case multiplication
    case subtraction
    
    case code123
    case code456
    case code789
    
}
