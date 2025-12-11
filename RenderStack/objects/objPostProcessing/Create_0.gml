
ppfxRenderer = new PPFX_Renderer();
ppfxRenderer.SetDrawEnable(false);
ppfxRenderer.ProfileLoad(new PPFX_Profile("Viewport 0 Effects", [new FX_Colorize(true, 0, 255, 255, 1)]));

with(objRenderPipelineManager) {
	renderStack[0].AddLayer(new RenderStackLayer("PPFXViewport0", undefined, function(_input) {
		if (instance_exists(objPostProcessing)) {
			_input = objPostProcessing.ppfxRenderer.Render(_input); // or .DrawInFullscreen(_input) with .SetDrawEnable(false) for earlier versions
		}
		return _input;
	}));
}
