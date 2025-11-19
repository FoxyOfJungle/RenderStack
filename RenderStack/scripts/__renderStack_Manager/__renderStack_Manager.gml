
// Feather ignore all

#macro RENDERSTACK_VERSION "v1.1"
#macro RENDERSTACK_RELEASE_DATE "November, 18, 2025"

show_debug_message($"RenderStack {RENDERSTACK_VERSION} | Copyright (C) 2025 FoxyOfJungle");


/// @desc Creates a stack containing layers, which are functions to be executed in a specific order. If using split-screen, you will create one for each viewport.
function RenderStack() constructor {
	// Copyright (C) 2025, Mozart Junior (FoxyOfJungle)
	__renderLayers = {}; // unordered references
	__renderLayersOrdered = []; // ordered references
	__enabled = true;
	__output = undefined;
	
	#region Private Methods
	/// @ignore
	static __layersSortFunction = function(a, b) {
		return a.order - b.order;
	}
	
	/// @ignore
	static __layersReorder = function() {
		// redefined ordered array
		array_resize(__renderLayersOrdered, 0);
		// copy from effects references to the ordered array
		var _layersNames = struct_get_names(__renderLayers);
		var _layersAmount = array_length(_layersNames);
		for (var i = 0; i < _layersAmount; ++i) {
			__renderLayersOrdered[i] = __renderLayers[$ _layersNames[i]];
		}
		// do a bubble sort for the ordered array (based on stack/rendering order)
		array_sort(__renderLayersOrdered, __layersSortFunction);
	}
	#endregion
	
	#region Public Methods
	/// @desc Add a new stack layer. 
	/// @method AddLayer(layer)
	/// @param {Struct.RenderStackLayer} layer Stack layer. Example: new RenderStackLayer(...).
	static AddLayer = function(_layer) {
		if (_layer.order == undefined) _layer.order = array_length(__renderLayersOrdered) * 100;
		__renderLayers[$ _layer.name] = _layer;
		__layersReorder();
		return self;
	}
	
	/// @desc Add a new stack layer.
	/// @method AddLayers(array)
	/// @param {Array<Struct.RenderStackLayer>} layer Array of stack layers. Example: [new RenderStackLayer(...), new RenderStackLayer(...)].
	static AddLayers = function(_array) {
		var i = 0, isize = array_length(_array), _layer = undefined;
		repeat(isize) {
			_layer = _array[i];
			if (_layer.order == undefined) _layer.order = max(i, array_length(__renderLayersOrdered)) * 100;
			__renderLayers[$ _layer.name] = _layer;
			++i;
		}
		__layersReorder();
		return self;
	}
	
	/// @desc Remove a layer from the stack.
	/// @method RemoveLayer(_name)
	/// @param {String} name The name of the layer to remove. This naturally causes the function to stop executing.
	static RemoveLayer = function(_name) {
		variable_struct_remove(__renderLayers, _name);
		__layersReorder();
		return self;
	}
	
	/// @desc Defines a new order for a layer.
	/// @method SetLayerOrder(_name, newOrder)
	/// @param {String} name The name of the layer to reorder.
	/// @param {Real} name The new layer order.
	static SetLayerOrder = function(_name, _newOrder) {
		var _layer = __renderLayers[$ _name];
		if (_layer == undefined) {
			show_debug_message("LayerStack: Layer not found");
			exit;
		}
		_layer.order = _newOrder;
		__layersReorder();
		return self;
	}
	
	/// @desc Defines whether a layer is active or not, which causes the function to naturally be executed or not.
	/// @method SetLayerEnable(_name, enable)
	/// @param {String} name The name of the layer to enable/disable/toggle.
	/// @param {Bool} enable Define if the layer is enabled. Use -1 to toggle.
	static SetLayerEnable = function(_name, _enable=-1) {
		var _layer = __renderLayers[$ _name];
		if (_layer == undefined) {
			show_debug_message("LayerStack: Layer not found");
			exit;
		}
		if (_enable == -1) {
			_layer.enabled = !_layer.enabled;
		} else {
			_layer.enabled = _enable;
		}
		__layersReorder();
		return self;
	}
	
	/// @desc Defines whether the stack should execute all layers or not.
	/// @method SetEnable(enable)
	/// @param {String} name The name of the layer to enable/disable/toggle.
	/// @param {Bool} enable Define if the layer is enabled. Use -1 to toggle.
	static SetEnable = function(_enable=-1) {
		if (_enable == -1) {
			__enabled = !__enabled;
		} else {
			__enabled = _enable;
		}
		return self;
	}
	
	/// @desc Get the layer struct based on the name.
	/// @method GetLayer(_name)
	/// @param {String} name The name of the layer to get struct.
	static GetLayer = function(_name) {
		return __renderLayers[$ _name];
	}
	
	/// @desc Gets the output of the last layer. Useful to use as input for drawing in Post-Draw event.
	/// @method GetOutput()
	/// @param {String} name The name of the layer to get struct.
	static GetOutput = function() {
		return __output;
	}
	
	/// @desc Executes all layers based on the defined order.
	/// Also returns the output of the last layer - So you can draw it in Post-Draw event.
	/// @method Render()
	static Render = function(_input) {
		__output = _input;
		if (__enabled) {
			var i = 0, isize = array_length(__renderLayersOrdered), _layer = undefined;
			repeat(isize) {
				_layer = __renderLayersOrdered[i];
				if (_layer.enabled) {
					__output = _layer.action(_input) ?? _input;
					_input = __output;
				} else {
					__output = _input;
				}
				++i;
			}
		}
		return __output;
	}
	#endregion
}


/// @desc Responsible for defining the function to be executed and its execution order.
/// @param {String} nameRef The reference name, used to find the layer later.
/// @param {Real} order This is the order that the function will be executed. That it, this will define the rendering order. Use undefined to automatically set the order in ascending order (separated by 100).
/// @param {Function,Method} action The function or method to execute when submiting.
function RenderStackLayer(_nameRef, _order, _action) constructor {
	// Properties
	enabled = true;
	name = _nameRef;
	order = _order;
	action = _action;
	
	/// @desc Define a new rendering order.
	/// @method SetOrder()
	/// @param {Real} newOrder The new order.
	static SetOrder = function(_newOrder) {
		order = _newOrder;
		return self;
	}
	
	/// @desc Returns the layer order
	/// @method GetOrder()
	static GetOrder = function() {
		return order;
	}
}

