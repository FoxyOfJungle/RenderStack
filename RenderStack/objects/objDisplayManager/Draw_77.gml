
// Draw final surface
if (instance_exists(objRenderingManager)) {
	var _surfaces = objRenderingManager.manager.GetFinalViewportSurfaces();
	draw_surface_stretched(_surfaces[0], view_get_xport(0), view_get_yport(0), view_get_wport(0), view_get_hport(0));
	exit;
}

draw_surface_stretched(application_surface, 0, 0, window_get_width(), window_get_height());
