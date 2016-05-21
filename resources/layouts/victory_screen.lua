local data = {
	vicWindow = {
		widget = "image",
		dim = { 50 , 55 },
		pos = { 25 , -125 },
		images = {
			{

				fileName = "../gui/victory_screen/background.png",

			},

		}, -- end of Vic Window images
		children = {
			lbVictory = {
				widget = "label",
				dim = { 20, 4 },
				pos = { 20, 2 },
				text = "VICTORY",
			},

			scoreWidget = {
				widget = "widget list",
				dim = { 48, 40 },
				pos = { 1, 10 },
				rowHeight = 5,
				maxSelect = 1,
				selectionImage = "../gui/buy_menu/selection_image2.png",
				columns = {
					{"", 15, "label"},
					{"", 20, "label"},
					{"", 20, "label"},
				},				
			}, -- end of score Widget

			rematchButton = {
				widget = "button",
				dim = { 20, 10 },
				pos = { 1, 44 },
				text = "Rematch",
				images = {
					normal = {
						{
							fileName = "../gui/victory_screen/orange_button.png",
							color = {1, 1, 1, 1},
						},
					},
				},
			}, -- end of rematch button

			exportButton = {
				widget = "button",
				dim = { 20, 10 },
				pos = { 29, 44 },
				text = "Export",
				images = {
					normal = {
						{
							fileName = "../gui/victory_screen/green_button.png",
							color = {1, 1, 1, 1},
						},
					},
				},
			},

		}, -- end of Vic Window Children
	}, -- end of Vic Window


}

return data