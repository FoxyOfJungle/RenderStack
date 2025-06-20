
// Disable automatic drawing of application_surface, so we can draw manually later
application_surface_draw_enable(false);


// Create a render stack and add functionality to it
view0renderStack = new RenderStack()
.AddLayers([
	new RenderStackLayer("Lighting", function(_input) {
		if (!instance_exists(objLightingManager)) exit;
		return objLightingManager.renderer.Draw(_input, view_get_camera(0));
	}),
	
	new RenderStackLayer("PPFX", function(_input) {
		if (!instance_exists(objPostProcessing)) exit;
		return objPostProcessing.renderer.Draw(_input);
	}),
	
	//new RenderStackLayer("UI", function(_input) {
	//	//if (!manager.IsAuxGUIEnabled()) exit;
	//	return manager.AuxGUIRender(_input);
	//}),
	
	//new RenderStackLayer("Pause", function(_input) {
	//	if (!instance_exists(objPause)) exit;
	//	return objPause.Draw(_input);
	//})
]);
