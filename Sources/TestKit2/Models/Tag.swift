//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tag
//*============================================================================*

extension Tag {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Removing uncertainty of meaning.
    @Tag public static var disambiguation: Self
    
    /// Material that serves as a record.
    @Tag public static var documentation: Self
    
    /// Including or considering all arguments.
    @Tag public static var exhaustive: Self
    
    /// Not officially authorized or confirmed.
    @Tag public static var unofficial: Self
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata x Attribution
    //=------------------------------------------------------------------------=
    
    /// Written (or inspired) by another open source project.
    ///
    /// - Note: Open source tests is one of few ways to prove: feature parity.
    ///
    @Tag public static var opensource: Self
}
