
// Feather ignore all

#macro RDSK_VERSION "v1.0"
#macro RDSK_RELEASE_DATE "June, 21, 2025"

show_debug_message($"RenderStack {RDSK_VERSION} | Copyright (C) 2025 FoxyOfJungle");


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
		var _effectsNames = struct_get_names(__renderLayers);
		var _effectsAmount = array_length(_effectsNames);
		for (var i = 0; i < _effectsAmount; ++i) {
			__renderLayersOrdered[i] = __renderLayers[$ _effectsNames[i]];
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
		__renderLayers[$ _layer.name] = _layer;
		__layersReorder();
		return self;
	}
	
	/// @desc Add a new stack layer.
	/// @method AddLayer(array)
	/// @param {Array<Struct.RenderStackLayer>} layer Array of stack layers. Example: [new RenderStackLayer(...), new RenderStackLayer(...)].
	static AddLayers = function(_array) {
		var i = 0, isize = array_length(_array), _layer = undefined;
		repeat(isize) {
			_layer = _array[i];
			_layer.order = i;
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
	}
	
	/// @desc Defines a new order for a layer.
	/// @method SetLayerOrder(_name, newOrder)
	/// @param {String} name The name of the layer to reorder.
	/// @param {Real} name The new layer order.
	static SetLayerOrder = function(_name, _newOrder) {
		var _layer = __renderLayers[$ _name];
		if (_layer == undefined) {
			show_debug_message("Not found");
			exit;
		}
		_layer.order = _newOrder;
		__layersReorder();
	}
	
	/// @desc Defines whether a layer is active or not, which causes the function to naturally be executed or not.
	/// @method SetLayerEnable(_name, enable)
	/// @param {String} name The name of the layer to enable/disable/toggle.
	/// @param {Bool} enable Define if the layer is enabled. Use -1 to toggle.
	static SetLayerEnable = function(_name, _enable=-1) {
		var _layer = __renderLayers[$ _name];
		if (_layer == undefined) {
			show_debug_message("Not found");
			exit;
		}
		if (_enable == -1) {
			_layer.enabled = !_layer.enabled;
		} else {
			_layer.enabled = _enable;
		}
		__layersReorder();
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
	}
	
	/// @desc Get the layer struct based on the name.
	/// @method GetLayer(_name)
	/// @param {String} name The name of the layer to get struct.
	static GetLayer = function(_name) {
		return __renderLayers[$ _name];
	}
	
	/// @desc Gets the output of the last layer. Useful to use as input for drawing.
	/// @method GetOutput()
	/// @param {String} name The name of the layer to get struct.
	static GetOutput = function() {
		return __output;
	}
	
	/// @desc Executes all layers based on the defined order. Also returns the output of the last layer.
	/// @method Submit()
	static Submit = function(_input) {
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
/// @param {Function,Method} action The function or method to execute when submiting.
function RenderStackLayer(_nameRef, _action) constructor {
	// Properties
	enabled = true;
	name = _nameRef;
	order = 0;
	action = _action;
}

