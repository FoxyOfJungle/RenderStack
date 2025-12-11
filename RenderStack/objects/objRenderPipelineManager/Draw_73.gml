
// Draw End is called for each viewport, so we're going to renderize it for each viewport and get the final surface from each viewport
viewportSurfacesOutput[view_current] = renderStack[view_current].Render(surface_get_target());
