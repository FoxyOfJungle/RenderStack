# Render Stack

RenderStack is an input/output processor, mainly for rendering.

RenderStack library basically executes an array of sorted functions (a.k.a virtual Layers) where the `.Draw()` function receives an input, processes it, and returns an output, which would be the initial and final surface.

This is useful for organizing the game's **rendering** into a **deterministic** and **customizable order**, in real time.

Useful if you are using a lighting system, post-processing, pause, and transitions together, as each needs to receive input from the other to function properly.

RenderStack is useful for singleplayer and local split-screen games.

**RenderStack** was created with my libraries in mind ([PPFX](https://foxyofjungle.itch.io/post-processing-fx), [Crystal](https://foxyofjungle.itch.io/crystal-2d-lighting-engine), Transitions), but it can be used for other things (like your own things - following the RenderStack logic).

https://github.com/user-attachments/assets/044265e7-bc2a-4145-9097-01dfbe1d6308

# How to use it

**CREATE EVENT:**  

Ideally, you should create a `RenderStack_Manager()` that will handle the tedious process for you.

The idea behind this manager is to: render all renderers for each viewport and return the final surface for that viewport. For each viewport you have, you will create a RenderStack, which is the set of virtual layers.
```
manager = new RenderStack_Manager();
manager.AddToViewport(new RenderStack(), 0); // Add a render stack for viewport 0
```

</br>


**PRE-DRAW EVENT**

Now, to ensure that the viewport surface references are automatically reset when you add or remove viewports, it's advisable to reset the array in the Pre-Draw event of the same object (`objRenderingManager`):

```gml
manager.Reset();
```

> This is useful if you're changing active viewports in real time (to clean the reference to old viewport surfaces).

</br>


**DRAW END EVENT:**  

The Draw End event is executed for each viewport, just like the normal Draw event; which means this will work naturally if your game is single player or split-screen.

Therefore, we will do it this way:

```gml
manager.Render();
```
Internally, this is what happens _(DO NOT USE THIS CODE - THIS IS JUST AN EXPLANATION)_:

```gml
var _rawGameSurface = view_get_surface_id(view_current);
var _finalOutputSurface = renderStacks[view_current)].Render(_rawGameSurface);
viewportFinalSurfaces[view_current] = _finalOutputSurface;
```

What this code does?

The `.Render()` function from each `RenderStack`:  
- 1 - Receives the viewport surface as the first input surface *(basically the raw surface with the content already drawn in the normal Draw events, the "application_surface")*;  
- 2 - Executes the functions loop internally, and  
- 3 - Returns the final output surface for the viewport.  

The input surface will be used as a base for our complex renderers (Crystal, PPFX etc) to use as input and return an output, which will be used as input for the next renderer, and so on.

Our `viewportFinalSurfaces` variable is the final surfaces array from viewports. (You will use `manager.GetFinalViewportSurfaces()` to get this).

We will use this variable next.

> **NOTE: RenderStack DOESN'T CREATE SURFACES! IT'S JUST AN INPUT/OUTPUT PROCESSOR.**

</br>

**Post-Draw:**
```js
// Draw final surface
draw_surface_stretched(manager.GetFinalViewportSurfaces()[0], 0, 0, window_get_width(), window_get_height());

// Or, if using Rezol Library (Recommended):
screen.DrawInFullscreen(manager.GetFinalViewportSurfaces());
```
