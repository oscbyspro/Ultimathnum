//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Expect x Result
//*============================================================================*

@inlinable public func Ɣexpect<T, E>(
    _  value: @autoclosure () throws -> T,
    is expectation: Result<T, E>,
    at location: SourceLocation = #_sourceLocation
)  where T: Equatable, E: Error & Equatable {
    
    var result = expectation // await Swift 6.0
    
    do  {
        result = Result.success(try value())
    }   catch let error as E {
        result = Result.failure(error)
    }   catch {
        #expect(Bool(false), "unknown(\(error))", sourceLocation: location)
    }
    
    #expect(result == expectation, sourceLocation: location)
}
