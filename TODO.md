
# APPROACH

Start from scratch but cherry-pick small things from ActivityLog2.
> Avoid wholesale copy as it's hard to extract the irrelevant stuff,
> and it's not my style,
> and I need to be able to understand it.

# TODO

Record structure for GPX file (Track) and points (TrackPoint).
XML parser.
XML -> structure for GPX tags.
(Could at this stage, do a point cloud.)
Post-process for distance, gradient etc.
Take part of the ActivityLog2 map and profile dialog and move into our top level.

Start to put views into child windows.

See if we can promote child windows into top level.

Display track in OpenGL window (see RobotMaze).

Need: equivalent of elm-geometry, some of which is in Pict3D.

Use Pict2D for plan.

Some graphic attributes to live at window level (e.g. terrain).