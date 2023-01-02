return {
	--Location Data
	Quarter = 1,
	Possession = true,
	Position = 0,

	--Game Data

	Ball = nil,

	PlayClock = {
		Value = 20,
		Running = false,
	},

	Clock = {
		Value = 300,
		Running = false,
	},

	Down = 1,
	Flag = false,

	Away = {
		Score = 0,
		Team = nil,
		Timeouts = 3,
	},

	Home = {
		Score = 0,
		Team = nil,
		Timeouts = 3,
	},
}
