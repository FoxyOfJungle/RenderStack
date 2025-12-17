
// Feather ignore all
#macro RENDERSTACK_VERSION "v2.0"
#macro RENDERSTACK_RELEASE_DATE "December, 15, 2025"

show_debug_message($"RenderStack {RENDERSTACK_VERSION} | Copyright (C) 2026 Mozart Junior (@foxyofjungle)");

global.__currentRenderStackManager = undefined;

/// @ignore
/// @func __renderstack_trace(text)
/// @param {String} text
function __renderstack_trace(_text, _level=1) {
	gml_pragma("forceinline");
	if (_level <= RENDERSTACK_CFG_TRACE_LEVEL) show_debug_message($"# RenderStack >> {_text}");
}

/// @desc This class is responsible for facilitating the rendering of render stacks for each viewport.
/// The idea is that, for each viewport, a render stack (containing layers) is rendered, executing its layers in the defined order, and finally, this manager returns the array with the final surfaces of each viewport (.GetFinalViewportSurfaces()).
/// NOTE: RenderStack does not create surfaces in any way; it is only an input/output processor.
function RenderStack_Manager() constructor {
	renderStacks = []; // each position is a viewport
	viewportFinalSurfaces = [];
	
	global.__currentRenderStackManager = self;
	
	/// @desc Adds a RenderStack to the internal array of render stacks, where the index corresponds to which viewport the render stack will be rendered.
	/// So, for example, if you use this function once, it will correspond to viewport 0, and the next time, viewport 1, etc. Unless you explicitly define which viewport the render stack will run on.
	/// @method AddToViewport(renderStack, viewport)
	static AddToViewport = function(_renderStack, _viewport=undefined) {
		if (_viewport == undefined) {
			array_push(renderStacks, _renderStack);
		} else {
			renderStacks[_viewport] = _renderStack;
		}
	}
	
	/// @desc Reset internal array with surfaces references.
	/// This is useful if you're changing active viewports in real time (to clean the reference to old viewport surfaces).
	/// NOTE: Must be called in "Pre-Draw" event.
	/// @method Reset()
	static Reset = function() {
		array_resize(viewportFinalSurfaces, 0);
	}
	
	/// @desc For each viewport, call the .Render() function from each added RenderStack.
	/// The output of the surfaces can be obtained using .GetOutputSurfaces().
	/// NOTE: Must be called in "Draw End" event. "Draw End" is called for each viewport, so we're going to renderize it for each viewport and get the final surface from each viewport
	static Render = function() {
		var _surf = view_get_surface_id(view_current);
		viewportFinalSurfaces[view_current] = renderStacks[clamp(view_current, 0, array_length(renderStacks)-1)].Render(surface_exists(_surf) ? _surf : application_surface);
	}
	
	/// @desc Returns the array with the final surfaces references, so you can draw them with draw_surface or using "Rezol" library to draw it.
	/// @method GetFinalViewportSurfaces()
	static GetFinalViewportSurfaces = function() {
		return viewportFinalSurfaces;
	}
	
	/// @method DebugDraw(x, y)
	/// @param {Real} x The x position to debug draw info.
	/// @param {Real} y The y position to debug draw info.
	static DebugDraw = function(_x, _y) {
		var _renderStack, _viewportX, _viewportY, _array, _item;
		for (var i = 0; i < array_length(renderStacks); ++i) {
			_renderStack = renderStacks[i];
			_viewportX = _x+i*150;
			_viewportY = _y;
			draw_text(_viewportX, _y, $"RenderStack\nviewport: {i}");
			
			_array = _renderStack.__renderLayers;
			for (var j = 0; j < array_length(_array); ++j) {
				_item = _array[j];
				draw_text(_viewportX, _viewportY+50+j*20, $"Layer Order: {_item.order}");
			}
		}
	}
}
