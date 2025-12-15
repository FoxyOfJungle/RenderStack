
// Feather ignore all
/// @desc A stack that controls the order in which visual elements are drawn on the screen.
/// Contains an array of layers, which are functions to be executed in a deterministic order.
/// The idea is to have one of these for each viewport (if needed... you can have just one for single-player games), and the rendering function should correspond to the viewport in question.
/// NOTE: RenderStack does not create surfaces in any way; it is only an input/output processor.
function RenderStack() constructor {
	// Copyright (C) 2025, Mozart Junior (FoxyOfJungle)
	__renderLayers = []; // ordered references
	__enabled = true;
	__output = undefined;
	
	#region Public Methods
	/// @desc Add a new render stack layer.
	/// @method AddLayer(layer)
	/// @param {Struct.RenderStack_Layer} layer Stack layer. Example: new RenderStackLayer(...).
	static AddLayer = function(_layer) {
		if (_layer.order == undefined) {
			_layer.order = array_length(__renderLayers) * 100;
		}
		array_push(__renderLayers, _layer);
		Sort();
		return self;
	}
	
	/// @desc Do a bubble sort for the layers array, based on order.
	/// @method Sort()
	static Sort = function() {
		static __layersSortFunction = function(a, b) {
			return a.order - b.order;
		}
		array_sort(__renderLayers, __layersSortFunction);
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
	
	/// @desc Gets the output of the last layer. Useful to use as input for drawing in Post-Draw event.
	/// @method GetOutput()
	/// @param {String} name The name of the layer to get struct.
	static GetOutput = function() {
		return __output;
	}
	
	/// @desc This function executes all layers, where the first layer uses "input" as input, returns something, and that something serves as input for the next layer; and finally, the output of the last layer is returned.
	/// Also returns the output of the last layer - So you can draw it in Post-Draw event.
	/// @method Render()
	/// @param {Id.Surface} input The input (surface).
	/// @returns {Id.Surface} The output surface.
	static Render = function(_input) {
		__output = _input;
		if (__enabled) {
			var i = 0, isize = array_length(__renderLayers), _layer = undefined;
			repeat(isize) {
				_layer = __renderLayers[i];
				if (_layer.__destroyed) {
					array_delete(__renderLayers, i, 1);
				} else {
					if (_layer.enabled) {
						__output = _layer.action(_input) ?? _input;
						_input = __output;
					} else {
						__output = _input;
					}
					++i;
				}
			}
		}
		return __output;
	}
	#endregion
}

/// @desc Responsible for defining the function to be executed and its execution order (the rendering order).
/// @param {Real} order This is the order that the function will be executed. That it, this will define the rendering order. Use undefined to automatically set the order in ascending order (separated by 100).
/// @param {Function,Method} action The function or method to execute. The idea is that a renderer has a function like ".Render()" that receives an input, processes it, and then returns an output, which will serve as input for the next one.
function RenderStack_Layer(_order, _action) constructor {
	// Properties
	enabled = true;
	order = _order;
	action = _action;
	
	// Base
	__destroyed = false;
	
	/// @desc Remove layer from the render stack.
	/// @method Destroy()
	static Destroy = function() {
		__destroyed = true;
	}
	
	/// @desc Add layer to a render stack index (which corresponds to a viewport). If your game is split-screen, it's ideal to call this function once for each viewport.
	/// This function only works if you have previously created a RenderStack_Manager.
	/// @method Apply(renderStackIndex)
	/// @param {Real} renderStackIndex The render stack number, which corresponds to a viewport. From 0 to 7 recommended.
	static Apply = function(_renderStackIndex=0) {
		var _manager = global.__currentRenderStackManager;
		if (_manager != undefined) {
			var _number = array_length(_manager.renderStacks);
			if (_renderStackIndex > _number-1) {
				__renderstack_trace($"Error: The render stack \"{_renderStackIndex}\" exceeds the defined number of render stacks in the Manager ({_number}).");
				exit;
			}
			var _renderStack = _manager.renderStacks[_renderStackIndex];
			_renderStack.AddLayer(self);
		} else {
			__renderstack_trace("Error: RenderStack_Manager not found, can't add this layer to a render stack in this way. You may use \".AddLayer()\" from a RenderStack then", 1);
		}
	}
	
	/// @desc Defines whether a layer is active or not, which causes the function to naturally be executed or not.
	/// @method SetEnable(enable)
	/// @param {Bool} enable Define if the layer is enabled. Use -1 to toggle.
	static SetEnable = function(_enable=-1) {
		if (_enable == -1) {
			enabled = !enabled;
		} else {
			enabled = _enable;
		}
		return self;
	}
	
	/// @desc Define a new rendering order. Note that if the layer has already been added to the render stack, the new order is not automatically reflected unless you remove the layer and add it again.
	/// Unless you force a sort on the render stack.
	/// @method SetOrder()
	/// @param {Real} newOrder The new order.
	static SetOrder = function(_newOrder) {
		order = _newOrder;
		return self;
	}
}
