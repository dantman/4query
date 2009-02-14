// Create innerHeight, innerWidth, outerHeight and outerWidth methods
jQuery.each([ "Height", "Width" ], function(i, name){

	var tl = i ? "Left"  : "Top",  // top or left
		br = i ? "Right" : "Bottom"; // bottom or right

	// innerHeight and innerWidth
	jQuery.fn["inner" + name] = function(){
		return this[ name.toLowerCase() ]() +
			num(this, "padding" + tl) +
			num(this, "padding" + br);
	};

	// outerHeight and outerWidth
	jQuery.fn["outer" + name] = function(margin) {
		return this["inner" + name]() +
			num(this, "border" + tl + "Width") +
			num(this, "border" + br + "Width") +
			(margin ?
				num(this, "margin" + tl) + num(this, "margin" + br) : 0);
	};
	
	var type = name.toLowerCase();

	jQuery.fn[ type ] = function( size ) {
		// Get window width or height
		return this[0] == window ?
			// Everyone else use document.documentElement or document.body depending on Quirks vs Standards mode
			document.compatMode == "CSS1Compat" && document.documentElement[ "client" + name ] ||
			document.body[ "client" + name ] :

			// Get document width or height
			this[0] == document ?
				// Either scroll[Width/Height] or offset[Width/Height], whichever is greater
				Math.max(
					document.documentElement["client" + name],
					document.body["scroll" + name], document.documentElement["scroll" + name],
					document.body["offset" + name], document.documentElement["offset" + name]
				) :

				// Get or set width or height on the element
				size === undefined ?
					// Get width or height on the element
					(this.length ? jQuery.css( this[0], type ) : null) :

					// Set the width or height on the element (default to pixels if value is unitless)
					this.css( type, typeof size === "string" ? size : size + "px" );
	};

});

// Try to keep the same naming pattern as the the offset API 
jQuery.fn.extend({
	size: function( size ) {
		if( this[0] == window || this[0] == document || size === undefined )
			return {
				width: jQuery.fn.width.call( this ),
				height: jQuery.fn.height.call( this )
			};
		
		if( typeof size === 'object' ) {
			var width = size.width, height = size.height;
		} else {
			var width = arguments[0], height = arguments[1];
		}
		
		jQuery.fn.width.call( this, width );
		jQuery.fn.height.call( this, height );
		
		return this;
	},
	
	innerSize: function() {
		return {
			width: jQuery.fn.innerWidth.call( this ),
			height: jQuery.fn.innerHeight.call( this )
		};
	},
	
	outerSize: function( margin ) {
		return {
			width: jQuery.fn.outerWidth.call( this, margin ),
			height: jQuery.fn.outerHeight.call( this, margin )
		};
	}
});
