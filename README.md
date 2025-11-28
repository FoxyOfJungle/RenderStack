# Render Stack

RenderStack library basically executes an array of sorted functions (a.k.a virtual Layers) where the `.Draw()` function receives an input, processes it, and returns an output, which would be the initial and final surface.

This is useful for organizing the game's **rendering** into a **deterministic** and **customizable order**, in real time.

Useful if you are using a lighting system, post-processing, pause, and transitions together, as each needs to receive input from the other to function properly.

RenderStack is useful for singleplayer and local split-screen games.

**RenderStack** was created with my libraries in mind ([PPFX](https://foxyofjungle.itch.io/post-processing-fx), [Crystal](https://foxyofjungle.itch.io/crystal-2d-lighting-engine), Transitions), but it can be used for other things (like your own things - following the RenderStack logic).

https://github.com/user-attachments/assets/044265e7-bc2a-4145-9097-01dfbe1d6308

# How to use it

Create Event:
```js
// Create a render stack for viewport 0 and add functionality to it
// (you need one for each viewport - we will only use one here)
renderStack[0] = new RenderStack();
viewportSurfacesOutput = []; // array with final output surface from each viewport

// Add a layer to the render stack, this is doing nothing, but it should renderize something and return the output surface
renderStack[0].AddLayer(new RenderStackLayer("sameInput", undefined, function(_input) {
	show_debug_message(_input);
	return _input;
}));

// Example (using Post-Processing FX in the rendering pipeline):
renderStack[0].AddLayer(new RenderStackLayer("PPFX", undefined, function(_input) {
	if (instance_exists(objPostProcessing)) _input = objPostProcessing.renderer.Render(_input);
	return _input;
}));
```

Pre-Draw:
```js
// Reset our array with surfaces references
// This is useful if you're changing active viewports in real time (to clean the reference to old viewport surfaces)
array_resize(viewportSurfacesOutput, 0);
```

Draw End:
(RenderStack will always be rendering stuff on Draw End - and draw in Post-Draw only)
```js
// Draw End is called for each viewport, so we're going to renderize it for each viewport and get the final surface from each viewport
viewportSurfacesOutput[view_current] = renderStack[view_current].Render(surface_get_target());
```

Post-Draw:
```js
// Draw final surface
draw_surface_stretched(viewportSurfacesOutput[0], 0, 0, window_get_width(), window_get_height());

// Or, if using Rezol Library (Recommended):
screen.DrawInFullscreen(viewportSurfacesOutput);
```
