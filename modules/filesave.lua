-- Centralized persistent data for Kabocha.
--
-- All settings and highscores go through sys.get_save_file() and are stored
-- as tables (sys.save requires a table). Each setting has a default that is
-- returned when no file exists or when the on-disk data is missing/corrupt.

local M = {}

local APP_NAME = "kabocha"

local DEFAULTS = {
	music_volume = 0.5,
	sound_volume = 0.5,
	highscore = 0,
}

local function load_table(name)
	local path = sys.get_save_file(APP_NAME, name)
	local data = sys.load(path)
	if type(data) ~= "table" then
		return {}
	end
	return data
end

local function save_table(name, data)
	local path = sys.get_save_file(APP_NAME, name)
	sys.save(path, data)
end

-- Music volume -------------------------------------------------------------

function M.load_music_volume()
	local data = load_table("musicvolume")
	return data.volume or DEFAULTS.music_volume
end

function M.save_music_volume(volume)
	save_table("musicvolume", { volume = volume })
end

-- Sound volume -------------------------------------------------------------

function M.load_sound_volume()
	local data = load_table("soundvolume")
	return data.volume or DEFAULTS.sound_volume
end

function M.save_sound_volume(volume)
	save_table("soundvolume", { volume = volume })
end

-- Per-mode highscore -------------------------------------------------------

local function highscore_name(game_mode)
	return "highscore" .. tostring(game_mode)
end

function M.load_highscore(game_mode)
	local data = load_table(highscore_name(game_mode))
	return data.highscore or DEFAULTS.highscore
end

function M.save_highscore(game_mode, highscore)
	save_table(highscore_name(game_mode), { highscore = highscore })
end

return M
