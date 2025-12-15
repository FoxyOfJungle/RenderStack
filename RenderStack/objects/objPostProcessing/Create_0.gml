
// simulation
renderer = {
	Render : function(_input) {
		return _input;
	}
};


// --------------------------------------------
// Add this renderer to the render stack
renderLayer = new RenderStack_Layer(300, function(_input) {
	if (instance_exists(objPostProcessing)) _input = objPostProcessing.renderer.Render(_input);
	return _input;
});

renderLayer.Apply(0);
