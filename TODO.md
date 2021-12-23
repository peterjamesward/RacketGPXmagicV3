
# TODO

Post-process for distance, gradient etc.

Tabular view of Euclidean, as there's something screwy there.

Profile view under map. (Use my colours.)

Display track in OpenGL window (see RobotMaze).
> Camera position
> Background
> Pan and Zoom
> Track &c.

Start to put views into child windows.
> Switch between floating and docked, somehow.

Increase map zoom limit (is 18, need 21).
Colour track.
Show track points.
> Worth noting that drawing on map is exactly that -- drawing.
> Which means, if we tweak the drawing, no need for separate Plan view.
> Can I use Mapbox?
> Can I improve zooming (integer?).

Tools, could actually be objects, subclassed from base-tool, say. 
> (Or just explicit functions.)

Drag on map.
> We should have control over mouse actions, before the map gets them (see mapwidget-impl.rkt)
> Likewaise, we can probably make a better marker.

Need: equivalent of elm-geometry, some of which is in Pict3D. (not comparable)

Most graphic attributes to live at window level (e.g. terrain).

# DONE

GPX -> Map, zoomed, centred, "orange" marker.
Basic 3D view, semblance of zooming.