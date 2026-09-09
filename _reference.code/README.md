# GraphQL reference code

This directory is a design corpus for the Idriç GraphQL implementation.

It is deliberately outside production source. Nothing under `_reference.code/` is a dependency, and production code must not import, compile, or package it.

## What is copied

Two kinds of upstream material live here:

- **complete source** — the full implementation source when a library is small enough that copying it remains useful as a readable specimen;
- **architectural source slice** — the type, schema, query, validation, code-generation, decoding, or transport files that expose the design of a much larger framework.

Large multi-package repositories are not copied wholesale merely to accumulate build files, test fixtures, JavaScript package state, generated documentation, caches, or framework adapters. Their GraphQL-defining source is the reference material we need.

`SOURCES.tsv` records the upstream repository, exact commit, license, local path, and whether the copy is complete or a slice. `CATALOG.md` is the broader inventory, including libraries whose code has not yet been copied locally.

## Rules

1. Keep upstream code under `_reference.code/`; never move it into production source by convenience.
2. Preserve upstream licenses beside copied code.
3. Pin an exact upstream commit in `SOURCES.tsv`.
4. Do not silently edit upstream files. If an excerpt or modification is necessary, say so in the filename/header and provenance ledger.
5. Copy abstractions only after identifying what invariant they enforce. Do not port framework machinery just because it exists upstream.
6. Networking remains a separate concern from GraphQL typing. A useful reference should make it possible to ask independently how a query is represented, checked, encoded, decoded, and transported.

## Questions to mine from the corpus

The first Idriç pass should compare how these implementations represent:

- schema object/input/enum/interface/union types;
- `NonNull` and list nesting;
- operation kind and root-type legality;
- selection sets and their result types;
- variables tied to a specific operation;
- validation before transport;
- fragments and exhaustive union/interface decoding;
- derivation of JSON decoders from the selected result shape;
- separation of GraphQL request construction from HTTP.

For the Indeed client, the immediate acceptance case is intentionally smaller: represent and execute one typed `jobSearch` operation without designing a general GraphQL framework first.
