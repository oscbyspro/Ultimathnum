//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Utilities x Optional
//*============================================================================*

extension Optional {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func prune<Error>(_ error: @autoclosure () -> Error) throws(Error) -> Wrapped {
        if  let self {
            return self
        }   else {
            throw error()
        }
    }
    
    @inlinable public consuming func result<Error>(_ error: @autoclosure () -> Error) -> Result<Wrapped, Error> {
        if  let self {
            return Result.success(self)
        }   else {
            return Result.failure(error())
        }
    }
}
