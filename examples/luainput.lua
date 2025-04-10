return function ()

	local plain = require("classes.plain")
	local class = plain({ papersize = "a5" })

	SILE.documentState.documentClass = class
	SILE.call("font", { family = "Libertinus Serif", size = "24pt" })
	SILE.typesetter:typeset("To Sherlock Holmes she is always the woman. I have seldom heard him mention her under any other name. In his eyes she eclipses and predominates the whole of her sex.")

end
