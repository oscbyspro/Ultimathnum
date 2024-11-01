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
    
    /// Sending to another destination.
    @Tag public static var forwarding: Self
    
    /// Relating to a class or group of things.
    @Tag public static var generic: Self
    
    /// Of great significance or value.
    @Tag public static var important: Self
    
    /// Inspired by an open-source project.
    @Tag public static var opensource: Self
    
    /// Something that may be regained.
    @Tag public static var recoverable: Self
    
    /// Happening, done, or chosen by chance.
    @Tag public static var random: Self
    
    /// Not officially authorized or confirmed.
    @Tag public static var unofficial: Self
}
