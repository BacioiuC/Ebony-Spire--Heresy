local data = {
	background = {
		widget = "image",
		dim = { 100, 100 },
		pos = { 0, 0 },
		images = {
			{

				fileName = "../gui/ggj_mainmenu.png"
			},

		}, -- end of images

		children = {
			btnStart = {
				widget = "button",
				dim = { 80, 18 },
				pos = { 10, 42 },
				text = "Onward! ",
				images = {
					normal = {
						{
							fileName = "../gui/button_1.png",
						},
					},

					pushed = {
						{
							fileName = "../gui/button_2.png",
						},
					},

					hover = {
						{
							fileName = "../gui/button_3.png",
						},
					},
				},
			}, -- end of button battle

			quitBattle = {
				widget = "button",
				dim = { 80, 18 },
				pos = { 10, 62 },
				text = "Exit! ",
				images = {
					normal = {
						{
							fileName = "../gui/button_1.png",
						},
					},

					pushed = {
						{
							fileName = "../gui/button_2.png",
						},
					},

					hover = {
						{
							fileName = "../gui/button_3.png",
						},
					},
				},
			}, -- end of button battle

	
		}, -- end of background children

	}, -- end of background
}

return data