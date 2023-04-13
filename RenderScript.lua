RenderScript = {
    __index = {
        _s = "", --script stored as string
        _l = {}, --layers variable name stored
        _f = {}, --fonts variable name stored

        ---@alias table Shape IDs
        SHAPES = {
            BEZIER=0,
            BOX=1,
            BOX_ROUNDED=2,
            CIRCLE=3,
            IMAGE=4,
            LINE=5,
            POLYGON=6,
            TEXT=7,
        },

        ---@alias table AlignH IDs
        ALIGN_H = {
            LEFT=0,
            CENTER=1,
            RIGHT=2,
        },

        ---@alias table AlignV IDs
        ALIGN_V = {
            ASCENDER=0,
            TOP=1,
            MIDDLE=2,
            BASELINE=3,
            BOTTOM=4,
            DESCENDER=5,
        },

        --- Create a new layer that will be rendered on top of all previously-created layers
        ---@return integer index The id that can be used to uniquely identify the layer for use with other API functions
        createLayer = function(self)
            local layer_name = '_L' .. (#self._l + 1)
            self._s = self._s .. 'local ' .. layer_name .. '=createLayer();'
            self._l[#self._l + 1] = layer_name
            return #self._l
        end,

        --- Load a font to be used with addText
        ---@param name string The name of the font to load; see the font list section for available font names
        ---@param size integer The size, in vertical pixels, at which the font will render. Note that this size can be changed during script execution with the setFontSize function
        ---@return integer value The id that can be used to uniquely identify the font for use with other API functions
        loadFont = function (self, name, size)
            local font_name = '_F' .. (#self._f + 1)
            self._f[#self._f + 1] = font_name
            self._s = self._s .. 'local ' .. font_name .. '=loadFont("' .. name .. '",' .. size .. ');'
        end,

        --- Return the screen location that is currently raycasted by the player
        ---@return number x, number y A tuple containing the (x, y) coordinates of the cursor, or (-1, -1) if the screen is not currently raycasted
        getCursor = function (self)
            self._s = self._s .. 'local _CX,_CY=getCursor();'
            --cursor x and y are always named _CX and _CY in the RenderScript
            return '_CX','_CY'
        end,

        --- Return the screen's current resolution.
        --- Ideally, your render scripts should be written to adapt to the resolution, as it may change in the future
        ---@return integer width, integer height A tuple containing the (width, height) of the screen's render surface, in pixels
        getResolution = function (self)
            self._s = self._s .. 'local _RX,_RY=getResolution();'
            --resolution x and y are always named _RX and _RY in the RenderScript
            return '_RX','_RY'
        end,

        --- Add a quadratic bezier curve to the given layer.
        --- Supported properties: shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x1 number X coordinate of the first point of the curve (the starting point)
        ---@param y1 number Y coordinate of the first point of the curve (the starting point)
        ---@param x2 number X coordinate of the second point of the curve (the control point)
        ---@param y2 number Y coordinate of the second point of the curve (the control point)
        ---@param x3 number X coordinate of the third point of the curve (the ending point)
        ---@param y3 number Y coordinate of the third point of the curve (the ending point)
        addBezier = function(self, layer, x1, y1, x2, y2, x3, y3)
            self._s = self._s .. 'addBezier(' .. self._l[layer] .. ',' .. x1 .. ',' .. x2 .. ',' .. y1 .. ',' .. y2 .. ',' .. x3 .. ',' .. y3 .. ');'
        end,

        --- Add a box to the given layer.
        --- Supported properties: fillColor, rotation, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x number X coordinate of the box's top-left corner
        ---@param y number Y coordinate of the box's top-left corner
        ---@param sx number Width of the box
        ---@param sy number Height of the box
        addBox = function(self, layer, x, y, sx, sy)
            self._s = self._s .. 'addBox(' .. self._l[layer] .. ',' .. x .. ',' .. y .. ',' .. sx .. ',' .. sy .. ');'
        end,

        --- Add a rounded box to the given layer.
        --- Supported properties: fillColor, rotation, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x number X coordinate of the box's top-left corner
        ---@param y number Y coordinate of the box's top-left corner
        ---@param sx number Width of the box
        ---@param sy number Height of the box
        ---@param r number Rounding radius of the box
        addBoxRounded = function (self, layer, x, y, sx, sy, r)
            self._s = self._s .. 'addBoxRounded(' .. self._l[layer] .. ',' .. x .. ',' .. y .. ',' .. sx .. ',' .. sy .. ',' .. r .. ');'
        end,

        --- Add a circle to the given layer.
        --- Supported properties: fillColor, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x number X coordinate of the circle's center
        ---@param y number Y coordinate of the circle's center
        ---@param r number Radius of the circle
        addCircle = function(self, layer, x, y, r)
            self._s = self._s .. 'addCircle(' .. self._l[layer] .. ',' .. x .. ',' .. y .. ',' .. r .. ');'
        end,

        --- Add an image to the given layer.
        --- Supported properties: fillColor, rotation
        ---@param layer integer The id of the layer to which to add
        ---@param image integer The id of the image to add
        ---@param x number X coordinate of the image's top-left corner
        ---@param y number Y coordinate of the image's top-left corner
        ---@param sx number Width of the image
        ---@param sy number Height of the image
        addImage = function(self, layer, image, x, y, sx, sy)
            self._s = self._s .. 'addImage(' .. self._l[layer] .. ',' .. image .. ',' .. x .. ',' .. y .. ',' .. sx .. ',' .. sy .. ');'
        end,

        --- Add a sub-region of an image to the given layer.
        --- Supported properties: fillColor, rotation
        ---@param layer integer The id of the layer to which to add
        ---@param image integer The id of the image to add
        ---@param x number X coordinate of the image's top-left corner
        ---@param y number Y coordinate of the image's top-left corner
        ---@param sx number Width of the image
        ---@param sy number Height of the image
        ---@param subX number X coordinate of the top-left corner of the sub-region to draw
        ---@param subY number Y coordinate of the top-left corner of the sub-region to draw
        ---@param subSx number Width of the sub-region within the image to draw
        ---@param subSy number Height of the sub-region within the image to draw
        addImageSub = function(self, layer, image, x, y, sx, sy, subX, subY, subSx, subSy)
            self._s = self._s .. 'addImageSub(' .. self._l[layer] .. ',' .. image .. ',' .. x .. ',' .. y .. ',' .. sx .. ',' .. sy .. ',' .. subX .. ',' .. subY .. ',' .. subSx .. ',' .. subSy .. ');'
        end,
        
        --- Add a line to the given layer.
        --- Supported properties: rotation, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x1 number X coordinate of the start of the line
        ---@param y1 number Y coordinate of the start of the line
        ---@param x2 number X coordinate of the end of the line
        ---@param y2 number Y coordinate of the end of the line
        addLine = function(self, layer, x1, y1, x2, y2)
            self._s = self._s .. 'addLine(' .. self._l[layer] .. ',' .. x1 .. ',' .. y1 .. ',' .. x2 .. ',' .. y2 .. ');'
        end,

        --- Add a quadrilateral to the given layer.
        --- Supported properties: fillColor, rotation, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x1 number X coordinate of the first point of the quad
        ---@param y1 number Y coordinate of the first point of the quad
        ---@param x2 number X coordinate of the second point of the quad
        ---@param y2 number Y coordinate of the second point of the quad
        ---@param x3 number X coordinate of the third point of the quad
        ---@param y3 number Y coordinate of the third point of the quad
        ---@param x4 number X coordinate of the fourth point of the quad
        ---@param y4 number Y coordinate of the fourth point of the quad
        addQuad = function(self, layer, x1, y1, x2, y2, x3, y3, x4, y4)
            self._s = self._s .. 'addQuad(' .. self._l[layer] .. ',' .. x1 .. ',' .. y1 .. ',' .. x2 .. ',' .. y2 .. ',' .. x3 .. ',' .. y3 .. ',' .. x4 .. ',' .. y4 .. ');'
        end,

        --- Add a string of text to the given layer.
        --- See setNextTextAlign for information on controlling text anchoring.
        --- Supported properties: fillColor, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param font integer The id of the font to use
        ---@param text string The string of text to be added
        ---@param x number X coordinate of the text anchor
        ---@param y number Y coordinate of the text anchor
        addText = function(self, layer, font, text, x, y)
            self._s = self._s .. 'addText(' .. self._l[layer] .. ',' .. self._f[font] .. ',' .. text .. ',' .. x .. ',' .. y .. ');'
        end,

        --- Add a triangle to the given layer.
        --- Supported properties: fillColor, rotation, shadow, strokeColor, strokeWidth
        ---@param layer integer The id of the layer to which to add
        ---@param x1 number X coordinate of the first point of the triangle
        ---@param y1 number Y coordinate of the first point of the triangle
        ---@param x2 number X coordinate of the second point of the triangle
        ---@param y2 number Y coordinate of the second point of the triangle
        ---@param x3 number X coordinate of the third point of the triangle
        ---@param y3 number Y coordinate of the third point of the triangle
        addTriangle = function(self, layer, x1, y1, x2, y2, x3, y3)
            self._s = self._s .. 'addTriangle(' .. self._l[layer] .. ',' .. x1 .. ',' .. y1 .. ',' .. x2 .. ',' .. y2 .. ',' .. x3 .. ',' .. y3 .. ');'
        end,

        --- Set the background color of the screen
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        setBackgroundColor = function (self, r, g, b)
            self._s = self._s .. 'setBackgroundColor(' .. r .. ',' .. g .. ',' .. b .. ');'
        end,

        --- Set the default fill color for all subsequent shapes of the given type added to the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param shapeType integer The type of shape to which the default will apply (see ShapeType)
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setDefaultFillColor = function (self, layer, shapeType, r, g, b, a)
            self._s = self._s .. 'setDefaultFillColor(' .. self._l[layer] .. ',' .. shapeType .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the default rotation for all subsequent shapes of the given type added to the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param shapeType integer The type of shape to which the default will apply (see ShapeType)
        ---@param rotation number Rotation, in radians; positive is counter-clockwise, negative is clockwise
        setDefaultRotation = function (self, layer, shapeType, rotation)
            self._s = self._s .. 'setDefaultRotation(' .. self._l[layer] .. ',' .. shapeType .. ',' .. rotation .. ');'
        end,

        --- Set the default shadow for all subsequent shapes of the given type added to the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param shapeType integer The type of shape to which the default will apply (see ShapeType)
        ---@param radius number The distance that the shadow extends from the shape's border
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setDefaultShadow = function (self, layer, shapeType, radius, r, g, b, a)
            self._s = self._s .. 'setDefaultShadow(' .. self._l[layer] .. ',' .. shapeType .. ',' .. radius .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the default stroke color for all subsequent shapes of the given type added to the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param shapeType integer The type of shape to which the default will apply (see ShapeType)
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setDefaultStrokeColor = function (self, layer, shapeType, r, g, b, a)
            self._s = self._s .. 'setDefaultStrokeColor(' .. self._l[layer] .. ',' .. shapeType .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the default stroke width for all subsequent shapes of the given type added to the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param shapeType integer The type of shape to which the default will apply (see ShapeType)
        ---@param strokeWidth number Stroke width, in pixels
        setDefaultStrokeWidth = function (self, layer, shapeType, strokeWidth)
            self._s = self._s .. 'setDefaultStrokeWidth(' .. self._l[layer] .. ',' .. shapeType .. ',' .. strokeWidth .. ');'
        end,

        --- Set the default text alignment of all subsequent text strings on the given layer
        ---@param layer integer The layer for which the default will be set
        ---@param alignH integer Specifies the horizontal anchoring of a text string relative to the draw coordinates; must be one of the following built-in constants: AlignH_Left, AlignH_Center, AlignH_Right
        ---@param alignV integer Specifies the vertical anchoring of a text string relative to the draw coordinates; must be one of the following built-in constants: AlignV_Ascender, AlignV_Top, AlignV_Middle, AlignV_Baseline, AlignV_Bottom, AlignV_Descender
        setDefaultTextAlign = function (self, layer, alignH, alignV)
            self._s = self._s .. 'setDefaultTextAlign(' .. self._l[layer] .. ',' .. alignH .. ',' .. alignV .. ');'
        end,

        --- Set the size at which a font will render.
        --- Impacts all subsequent font-related calls, including addText, getFontMetrics, and getTextBounds.
        ---@param font integer The font for which the size will be set
        ---@param size integer The new size, in vertical pixels, at which the font will render
        setFontSize = function (font, size)
            self._s = self._s .. 'setFontSize(' .. self._f[font] .. ',' .. size .. ');'
        end,

        --- Set a clipping rectangle applied to the layer as a whole.
        --- Layer contents that fall outside the clipping rectangle will not be rendered, and those that are
        --- partially within the rectangle will be 'clipped' against it. The clipping rectangle is applied
        --- before layer transformations. Note that clipped contents still count toward the render cost.
        ---@param layer integer The layer for which the clipping rectangle will be set
        ---@param x number X coordinate of the clipping rectangle's top-left corner
        ---@param y number Y coordinate of the clipping rectangle's top-left corner
        ---@param sx number Width of the clipping rectangle
        ---@param sy number Height of the clipping rectangle
        setLayerClipRect = function (self, layer, x, y, sx, sy)
            self._s = self._s .. 'setLayerClipRect(' .. self._l[layer] .. ',' .. x .. ',' .. y .. ',' .. sx .. ',' .. sy .. ');'
        end,

        --- Set the transform origin of a layer; layer scaling and rotation are applied relative to this origin
        ---@param layer integer The layer for which the origin will be set
        ---@param x number X coordinate of the layer's transform origin
        ---@param y number Y coordinate of the layer's transform origin
        setLayerOrigin = function (self, layer, x, y)
            self._s = self._s .. 'setLayerOrigin(' .. self._l[layer] .. ',' .. x .. ',' .. y .. ');'
        end,

        --- Set a rotation applied to the layer as a whole, relative to the layer's transform origin
        ---@param layer integer The layer for which the rotation will be set
        ---@param rotation number Rotation, in radians; positive is counter-clockwise, negative is clockwise
        setLayerRotation = function (self, layer, rotation)
            self._s = self._s .. 'setLayerRotation(' .. self._l[layer] .. ',' .. rotation .. ');'
        end,

        --- Set a scale factor applied to the layer as a whole, relative to the layer's transform origin.
        --- Scale factors are multiplicative, so that a scale >1 enlarges the size of the layer, 1.0 does nothing, and
        --- <1 reduces the size of the layer.
        ---@param layer integer The layer for which the scale factor will be set
        ---@param sx number Scale factor along the X axis
        ---@param sy number Scale factor along the Y axis
        setLayerScale = function (self, layer, sx, sy)
            self._s = self._s .. 'setLayerScale(' .. self._l[layer] .. ',' .. sx .. ',' .. sy .. ');'
        end,

        --- Set a translation applied to the layer as a whole
        ---@param layer integer The layer for which the translation will be set
        ---@param tx number Translation along the X axis
        ---@param ty number Translation along the Y axis
        setLayerTranslation = function (self, layer, tx, ty)
            self._s = self._s .. 'setLayerTranslation(' .. self._l[layer] .. ',' .. tx .. ',' .. ty .. ');'
        end,

        --- Set the fill color of the next rendered shape on the given layer; has no effect on shapes that do not support a fill color
        ---@param layer integer The layer to which this property applies
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setNextFillColor = function (self, layer, r, g, b, a)
            self._s = self._s .. 'setNextFillColor(' .. self._l[layer] .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the rotation of the next rendered shape on the given layer; has no effect on shapes that do not support rotation
        ---@param layer integer The layer to which this property applies
        ---@param rotation number Rotation, in radians; positive is counter-clockwise, negative is clockwise
        setNextRotation = function (self, layer, rotation)
            self._s = self._s .. 'setNextRotation(' .. self._l[layer] .. ',' .. rotation .. ');'
        end,

        --- Set the rotation of the next rendered shape on the given layer; has no effect on shapes that do not support rotation
        ---@param layer integer The layer to which this property applies
        ---@param rotation number Rotation, in degrees; positive is counter-clockwise, negative is clockwise
        setNextRotationDegrees = function (self, layer, rotation)
            self._s = self._s .. 'setNextRotationDegrees(' .. self._l[layer] .. ',' .. rotation .. ');'
        end,

        --- Set the shadow of the next rendered shape on the given layer; has no effect on shapes that do not support a shadow
        ---@param layer integer The layer to which this property applies
        ---@param radius number The distance that the shadow extends from the shape's border
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setNextShadow = function (self, layer, radius, r, g, b, a)
            self._s = self._s .. 'setNextShadow(' .. self._l[layer] .. ',' .. radius .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the stroke color of the next rendered shape on the given layer; has no effect on shapes that do not support a stroke color
        ---@param layer integer The layer to which this property applies
        ---@param r number Red component, between 0 and 1
        ---@param g number Green component, between 0 and 1
        ---@param b number Blue component, between 0 and 1
        ---@param a number Alpha component, between 0 and 1
        setNextStrokeColor = function (self, layer, r, g, b, a)
            self._s = self._s .. 'setNextStrokeColor(' .. self._l[layer] .. ',' .. r .. ',' .. g .. ',' .. b .. ',' .. a .. ');'
        end,

        --- Set the stroke width of the next rendered shape on the given layer; has no effect on shapes that do not support a stroke width
        ---@param layer integer The layer to which this property applies
        ---@param strokeWidth number Stroke width, in pixels
        setNextStrokeWidth = function (self, layer, strokeWidth)
            self._s = self._s .. 'setNextStrokeWidth(' .. self._l[layer] .. ',' .. strokeWidth .. ');'
        end,

        --- Set the text alignment of the next rendered text string on the given layer.
        --- By default, text is anchored horizontally on the left, and vertically on the baseline
        ---@param layer integer The layer to which this property applies
        ---@param alignH AlignH Specifies the horizontal anchoring of a text string relative to the draw coordinates; must be one of the following built-in constants: AlignH_Left, AlignH_Center, AlignH_Right
        ---@param alignV AlignV Specifies the vertical anchoring of a text string relative to the draw coordinates; must be one of the following built-in constants: AlignV_Ascender, AlignV_Top, AlignV_Middle, AlignV_Baseline, AlignV_Bottom, AlignV_Descender
        setNextTextAlign = function (self, layer, alignH, alignV)
            self._s = self._s .. 'setNextTextAlign(' .. self._l[layer] .. ',' .. alignH .. ',' .. alignV .. ');'
        end,

        --************************************************************************************************************
        -- Joker function that is here to permit all the things that are not doable with the other functions
        --************************************************************************************************************

        --- Add a line of code to the renderscript as a string
        ---@param line string The line of code to add
        insertCodeLine = function(self, line)
            self._s = self._s .. line .. '\n'
        end,
        
        --************************************************************************************************************
        -- Third party libraries support
        --************************************************************************************************************

        --- Use a third party library in the renderscript
        ---@param libraryName string The name of the library to use, it will also be used as the variable name to access it in the renderScript
        use = function (self, libraryName)
            self._s = self._s .. 'local ' .. libraryName .. '=require("' .. libraryName .. '");'
        end,

        --- Use the Atlas library in the renderscript the variable name is to access it in the renderScript is "atlas"
        useAtlas = function (self)
            self._s = self._s .. 'local atlas=require("atlas");'
        end,

        --- Use the JSON (dkjson) library in the renderscript the variable name is to access it in the renderScript is "json"
        useJSON = function (self)
            self._s = self._s .. 'local json=require("dkjson");'
        end,

        --- Use the RSLib library in the renderscript the variable name is to access it in the renderScript is "rslib"
        useRSLib = function (self)
            self._s = self._s .. 'local rslib=require("rslib");'
        end,

        --************************************************************************************************************
        -- utilities to add to the renderscript that are not by default in game
        --************************************************************************************************************

        --- Return the maximum size of a renderscript
        ---@return integer The maximum size of a renderscript, in characters
        getMaxSize = function(self)
            return 50000
        end,

        --- Return whether the renderscript is too long
        ---@return boolean Whether the renderscript is too long
        isTooLong = function(self)
            return #self._s > 50000
        end,

        --- Return the current size of the renderscript
        ---@param screen Screen The screen to which to send the renderscript
        sendToScreen = function(self, screen)
            screen.setRenderScript(self._s)
        end,
    },
    __tostring = function(self)
        return self._s
    end,
    __len = function(self)
        return #self._s
    end,
}
