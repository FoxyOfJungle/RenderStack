# Render Stack

This library is useful for organizing the game's **rendering** into a **defined** and **customizable order**, in real time.

Useful if you are using a lighting system, post-processing, pause, and transitions together, as each needs to receive input from the other to function properly.

**RenderStack** was created with my libraries in mind ([PPFX](https://foxyofjungle.itch.io/post-processing-fx), [Crystal](https://foxyofjungle.itch.io/crystal-2d-lighting-engine), Transitions), but it can be used for other things (like your own things - following the RenderStack logic).

https://github.com/user-attachments/assets/044265e7-bc2a-4145-9097-01dfbe1d6308

# How to use it

```gml
// Create a render stack (you need one for each viewport - we will only use one here)
view0renderStack = new RenderStack()

// Add functionality to it. The order of addition is the order of execution by default, but you can use .SetLayerOrder(), .SetLayerEnable() and others to stop executing something on the fly, etc
.AddLayers([
	new RenderStackLayer("Lighting", function(_input) {
		if (!instance_exists(objLightingManager)) exit;
		return objLightingManager.renderer.Draw(_input, view_get_camera(0));
	}),
	
	new RenderStackLayer("PPFX", function(_input) {
		if (!instance_exists(objPostProcessing)) exit;
		return objPostProcessing.renderer.Draw(_input);
	}),
	
	new RenderStackLayer("UI", function(_input) {
		if (!manager.IsAuxGUIEnabled()) exit;
		return manager.AuxGUIRender(_input);
	}),
	
	new RenderStackLayer("Pause", function(_input) {
		if (!instance_exists(objPause)) exit;
		return objPause.Draw(_input);
	})
]);
```
When the object does not exist in the room and the function is finished, the input from the previous one will be used naturally.

Then you can get the output surface to do whatever you want, like drawing:
```gml
// Get input surface (the initial surface in the stack)
var _view0Surf = application_surface; // or view_get_surface_id(0);
// Draw final surface
draw_surface_stretched(view0renderStack.Submit(_view0Surf), 0, 0, window_get_width(), window_get_height());
```
