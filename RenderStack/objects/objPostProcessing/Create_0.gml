
ppfxRenderer = new PPFX_Renderer();
ppfxRenderer.SetDrawEnable(false);
ppfxRenderer.ProfileLoad(new PPFX_Profile("View 0 Effects", [new FX_Colorize(true, 0, 255, 255, 1)]));

objDisplayManager.renderStack[0].AddLayer(new RenderStackLayer("PPFX V0", undefined, function(_input) {
	return ppfxRenderer.DrawInFullscreen(_input);
}));
