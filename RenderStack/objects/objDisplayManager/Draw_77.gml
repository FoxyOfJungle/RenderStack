
// Draw final surface
var _inputViewport0 = application_surface; // or view_get_surface_id(0);

if (instance_exists(objRenderPipelineManager)) {
	_inputViewport0 = objRenderPipelineManager.viewportSurfacesOutput[0];
}

draw_surface_stretched(_inputViewport0, 0, 0, window_get_width(), window_get_height());
