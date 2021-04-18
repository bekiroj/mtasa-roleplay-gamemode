-- Ayarlar


Race = {

	Create = {
		price         = 2500, -- Yarış kurmak için gereken miktar
		maxplayers    = 2,    -- Katılabilecek en fazla oyuncu sayısı
		playerlevel   = 3,    -- Yarış menüsü kuran oyuncunun seviye gereksinimi
		minbet        = 1000, -- Bahis miktarının minimum değeri
		maxbet        = 15000, -- Bahis miktarının maksimum değeri
		starttime     = 5,   -- Yarışın başlama süresi
		frozentime    = 2,   -- Oyuncunun dondurulma süresi
	},

	Global = {
		quitcancel    = true, -- Yarışta olan oyuncu oyundan düştükten sonra para iadesi (True = Para idesi var) / (False = Para idesi yok)
		maxmarker     = 5,   -- Yarışa ekleyebileceği maksimum marker
		minmarker     = 3,    -- Yarışa ekleyebileceği minimum marker
	},

	RacePlayers        = {}, -- Yarışta olan oyuncular ve verileri
	RaceArena          = {}, -- Yarış arenaları ve verileri
	RaceInvitedPlayers = {}, -- Yarış daveti olan oyuncular ve verileri

}