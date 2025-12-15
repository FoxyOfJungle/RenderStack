
// simulation
renderer = {
	Render : function(_input, _camera) {
		return _input;
	}
};


// --------------------------------------------
// Add this renderer to the render stack
renderLayer = new RenderStack_Layer(200, function(_input) {
	if (instance_exists(objLightingManager)) _input = objLightingManager.renderer.Render(_input, view_get_camera(0));
	return _input;
});
renderLayer.Apply(0);
