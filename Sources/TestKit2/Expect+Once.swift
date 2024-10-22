//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Expect x Once
//*============================================================================*

/// - Note: The `expect` macro is too slow to call in hot loops.
@inlinable public func withOnlyOneCallToExpect(
    _ comment: @autoclosure () -> Any = "",
    at location: SourceLocation = #_sourceLocation,
    perform expect: ((Bool) -> Void) -> Void
) {
    
    var success = true
    expect({ success = success && $0 })
    #expect((success), Comment(rawValue: String(describing: comment())), sourceLocation: location)
}

/// - Note: The `require` macro is too slow to call in hot loops.
@inlinable public func withOnlyOneCallToRequire(
    _ comment: @autoclosure () -> Any = "",
    at location: SourceLocation = #_sourceLocation,
    perform require: ((Bool) -> Void) throws -> Void
)   throws {
    
    var success = true
    try require({ success = success && $0 })
    try #require((success), Comment(rawValue: String(describing: comment())), sourceLocation: location)
}
