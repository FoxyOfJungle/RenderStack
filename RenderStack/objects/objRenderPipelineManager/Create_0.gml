
// Create a render stack for viewport 0 and add functionality to it
renderStack[0] = new RenderStack();
viewportSurfacesOutput = []; // array with final output surface from each viewport



// Add a layer to the render stack, this is doing nothing, but it should renderize something and return the output surface
renderStack[0].AddLayer(new RenderStackLayer("sameInput", undefined, function(_input) {
	show_debug_message(_input);
	return _input;
}));

renderStack[0].AddLayer(new RenderStackLayer("Lighting", undefined, function(_input) {
	return _input;
}));

renderStack[0].AddLayer(new RenderStackLayer("PPFX", undefined, function(_input) {
	return _input;
}));


//renderStack[0].RemoveLayer("sameInput");

//show_debug_message(json_stringify(renderStack, true));
