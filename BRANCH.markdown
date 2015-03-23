Aborted Branch to get SwiftGraphics to rely on SwiftUtilities (moving
most non-graphics related functionality to SwiftUtilities in the
process)

Do not use this branch.

The main problem is that Swift Playgrounds DO NOT work at all well with
dependent frameworks, especially frameworks that are linked to by the
main framework but are not embedded.
