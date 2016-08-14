# Nifty Style Guide

This is the style guide for contributions to Nifty... 

TODO: flesh this out

## Organization

- keep toolboxes large and general, e.g. don't subdivide. We'd like to end up
with only a handful of toolboxes
- keep files small; typically only one function (plus overloads) per file. 
- The exception to one function/file is when multiple functions access a piece 
of private data, in this case functions can be combined into one file if it 
makes more sense to do that then create accessor functions, e.g. time.swift 
contains both tic() and toc() since the both access a private stopwatch.
- prefer making data private when feasible
- lines end at 80 characters, do not extend beyond this

## Naming Convention

- File should be named for the function it contains, e.g. max.swift contains 
the max function overloads.
- Names should match matlab function names if they do the same thing (parameter
lists can be different). If the function has no comparable matlab counterpart, 
name it something that feels similar in style, e.g. we named the function that
re-maps a number from one range to another rmap() instead of something like 
mapToRange().
- private stuff (functions and data) should start with an underscore
- TODO: decide rules on external parameter names, i.e. when should unnamed
parameters be allowed, as in simple(p1: Int, _ p2: Int) vs 
complex(p1: Int, p2: Int, p3: Int)

## Comments

### Functions Headers

Every public function must have a header comment. Private functions probably
should all have one too. Use the following comment block:

```
/// Brief (one or 2 sentences) description of function, e.g. Compute the 
/// magnitude of a vector in three dimensions from the given components.
///
/// More details, notes, explanation, caution, etc. Multi paragraph okay.
///
/// The above components should be complete sentences with proper punctuation.
///
/// - Parameters:
///     - x: The *x* component of the vector (no period)
///     - y: The *y* component of the vector (no period)
///     - z: The *z* component of the vector (no period)
/// - Throws:
///	- error type: may include a phrase description if desired (no period)
/// - Returns: describe what is returned in one phrase (no period)
```

Any of the components can be omitted from the comment block if there is
nothing that should go there. First line (brief description) can not be omitted.
The first line must be an imperative, e.g. 'Compute the magnitude...' rather 
than 'Computes the magnitude...'.

### Structs/Classes

### Enums

### Code

Comments on code should be limited--most description ought to be in the 
function header or the code should be easy enough to read. Some particularly
tricky bits may require comments. In this case, comments go above the code, not
at the end of the line. e.g.

```
// Do something tricky, comment like this
let myTrickyValue = ...

let myTrickyValue2 = ... // not like this
```

### File Header

Every file ought to have a header that indicates purpose, original author,
original creation date, contributors, license, and, copyright. 

```
/*******************************************************************************
 *  fileName.swift
 *
 *  [This file provides... ONE complete sentence description of file.]
 *
 *  Author: [Bob the Original Author]
 *  Creation Date: [1 Jan 1970, in this format... NOT last modified date]
 *  Contributors: [add name here if you contributed substantially to this file]
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Copyright [yyyy] [name of copyright owner]
 ******************************************************************************/
```

### Sections

Major sections of a file can be grouped using MARK, as below.But there should 
probably only be at most a few of these per file. Section heading must be short
enough to fit on one line.

```
//==============================================================================
// MARK: ALL CAPS SHORT SECTION HEADING
//==============================================================================
```

#### Subsections
You may want to use smaller subdivisions (e.g. set off private functions from
the others). If desired, the following subsection heading may be used.

```
//--------------------------------------------------
// Sub Section Heading Title Case
//--------------------------------------------------
```
