local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "../gui/overlay_image.png", --_1080.png
			},
		},
		children = {
			messageLog = {
				widget = "label",
				pos = {0, 0},
				dim = {100, 4},
				text = "",


			},

			inventory = {
				widget = "image",
				pos = {-100, 9.2},
				dim = {100, 77.5},
				images = {
					{
						fileName="../gui/ggMM/bg_ui_option.png"

					},

				},


			},

		},

	},
	game_over = { 
		widget="image",
		dim={100, 100},
		pos = {0, -100},
		images = {
			{
				fileName="../gui/game_over.png",

			},

		},

	},
}

return data