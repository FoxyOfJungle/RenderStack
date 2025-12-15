
// The idea behind this manager is to: render all renderers for each viewport and return the final surface for that viewport.
// NOTE: RenderStack does not create surfaces in any way; it is only an input/output processor.
manager = new RenderStack_Manager();
manager.AddToViewport(new RenderStack(), 0); // Add a render stack for viewport 0
