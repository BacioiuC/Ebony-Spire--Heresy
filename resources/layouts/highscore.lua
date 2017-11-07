local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "../gui/ggHighScore/main_menu_background_trans.png", --
			},
		},
		children = {
			scrollInfo = {
				widget = "label",
				dim = {100, 10},
				pos = {5, 94},
				text = "==== Scroll <c:9FC43A>UP</c> and <c:9FC43A>DOWN</c> using <c:9FC43A>W</c> and <c:9FC43A>S</c>. Press <c:9FC43A>ESC</c> to return =================",
			},

		},

	},
}

return data