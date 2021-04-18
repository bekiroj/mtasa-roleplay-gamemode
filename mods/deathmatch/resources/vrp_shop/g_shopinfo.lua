--- clothe shop skins
blackMales = { 310, 311, 300, 301, 302, 297, 268, 269, 270, 271, 272, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = { 306, 307, 309, 312, 303, 299, 291, 292, 293, 294, 1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = { 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
disabledUpgrades = {
	[1142] = true, 
	[1109] = true,
	[1008] = true,
	[1009] = true,
	[1010] = true,
}
function getDisabledUpgrades()
	return disabledUpgrades
end
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 297, 298, 299, 300, 301, 302, 303, 306, 307, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }
local wheelPrice = 2500
local priceReduce = 2
g_shops = {
	{ -- 1
		name = "Genel Mağaza",
		description = "Bu dükkan her türlü genel amaçlı ürünler satar.",
		image = "general.png",
		
		{
			name = "Genel Eşyalar",
			{ name = "YENİ! Kazma", description = "Maden kazmanızı sağlar.", price = 2500, itemID = 578, itemValue = 0 },
			{ name = "Rampa", description = "Özel tırlarda kullanabileceğiniz bir rampa.", price = 1000, itemID = 117, itemValue = 0 },
			{ name = "Tamir Kiti", description = "Aracınız İçin 10 Kullanımlık Tamir Kiti", price = 5000, itemID = 580, itemValue = 10 },
			{ name = "Kriko Kit", description = "Aracınız İçin 10 Kullanımlık Çevirme Kiti", price = 5000, itemID = 581, itemValue = 10 },
			{ name = "Koli Bandı", description = "/bantla yazarak birilerini susturabilirsin.", price = 10, itemID = 588, itemValue = 10 },
			{ name = "Telefon Rehberi", description = "Herkesin numarasının olduğu büyük bir telefon rehberi.", price = 30, itemID = 7 },
			{ name = "Tek Zar", description = "1,6 arası rastgele sayılar gelen zar.", price = 2, itemID = 10, itemValue = 1 },
			{ name = "Çift Zar", description = "1,6 arası rastgele sayılar gelen iki zar.", price = 2, itemID = 217, itemValue = 1 },
			{ name = "20 Taraflı Zar", description = "Siyah noktalar bulunan yirmi yüzlü bir beyaz zar.", price = 5, itemID = 10, itemValue = 20 },
			-- { name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			{ name = "Sırt Çantası", description = "Makul bir sırt çantası.", price = 30, itemID = 48 },
			{ name = "Olta", description = "7 ayak karbon çelik olta.", price = 300, itemID = 49 },
			{ name = "Maske", description = "Bir kayak maskesi.", price = 20, itemID = 56 },
			{ name = "Benzin Bidonu", description = "Küçük bir metal benzin bidonu.", price = 35, itemID = 57, itemValue = 0 },
			{ name = "Sargı Bezi", description = "Zor günlerinizde yanınızda bulundurmanız gereken bir sargı bezi.", price = 1500, itemID = 70, itemValue = 3 },
			--[[
			{ name = "Mini Notebook", description = "An empty Notebook, enough to write 5 notes.", price = 10, itemID = 71, itemValue = 5 },
			{ name = "Notebook", description = "An empty Notebook, enough to write 50 notes.", price = 15, itemID = 71, itemValue = 50 },
			{ name = "XXL Notebook", description = "An empty Notebook, enough to write 125 notes.", price = 20, itemID = 71, itemValue = 125 },
			]]
			{ name = "Kask", description = "Bisiklete binen insanlar tarafından yaygın olarak kullanılan bir kask.", price = 100, itemID = 90 },
			{ name = "Sigara Paketi", description = "Sigara içebileceğiniz şeyler...", price = 10, itemID = 105, itemValue = 20, minimum_age = 18 },
			{ name = "Çakmak", description = "Bağımlılığınızı aydınlatmak için gerçek bir Zippo!", price = 45, itemID = 107 },
			{ name = "Meyve Bıçağı", description = "Meyve Bıçağı.", price = 15, itemID = 115, itemValue = 4 },
			{ name = "Kağıt Destesi", description = "Oyun oynamak ister misin?", price = 10, itemID = 77 },
			{ name = "Çerçeve", description = "Bunları iç mekan süslemek için kullanabilirsiniz!", price = 50000, itemID = 147, itemValue = 1 },
			{ name = "İş Çantası", description = "Kahverengi deri bir iş çantası.", price = 75, itemID = 160},
			{ name = "Yün Çanta", description = "Üst kısmı ipli kapatma ile kumaştan yapılmış büyük silindirik bir çanta.", price = 60, itemID = 163},
			{ name = "Boş Kitap", description = "Yazılı hiçbir şey olmayan bir ciltli kitap.", price = 40, itemID = 178, itemValue = "New Book"},
		    { name = "Sosisli Tezgahı", description = "Sosisli satışları için gerekli olan tezgah.", price = 2000, itemID = 409},
			{ name = "Dondurma Tezgahı", description = "Dondurma satışları için gerekli olan tezgah.", price = 1500, itemID = 407},
			{ name = "Çin Yemeği Tezgahı", description = "Çin yemeği satışları için gerekli olan tezgah.", price = 750, itemID = 408},
			{ name = "Nargile", description = "Közlerinize inanamayacaksınız.", price = 200, itemID = 227},
			{ name = "Kazma", description = "Kazı yapabileceğiniz bir eşya.", price = 2000, itemID = 578},
		},
		{
			name = "Tüketilebilir",
			{ name = "Sandviç", description = "Peynirli nefis bir sandviç.", price = 6, itemID = 8 },
			{ name = "Meşrubat", description = "Bir Sprunk kutusu.", price = 3, itemID = 9 },
		},
		--[[ {
			name = 'Bandanas',
			{ name = "Light Blue Bandana", description = "A light blue rag.", price = 5, itemID = 122 },
			{ name = "Red Bandana", description = "A red rag.", price = 5, itemID = 123 },
			{ name = "Yellow Bandana", description = "A yellow rag.", price = 5, itemID = 124 },
			{ name = "Purple Bandana", description = "A purple rag.", price = 5, itemID = 125 },
			{ name = "Blue Bandana", description = "A blue rag.", price = 5, itemID = 135 },
			{ name = "Brown Bandana", description = "A brown rag.", price = 5, itemID = 136 },
			{ name = "Green Bandana", description = "A green rag.", price = 5, itemID = 158 },
			{ name = "Orange Bandana", description = "A orange rag.", price = 5, itemID = 168 },
		}, --]]
	},
	{ -- 2
		name = "Gun and Ammo Store",
		description = "All your gun needs since 1914.",
		image = "gun.png",
		
		{
			name = "Guns and Ammo",
			{ name = "Colt-45 Pistol", description = "A silver Colt-45.", price = 850, itemID = 115, itemValue = 22, license = true },
			{ name = "Colt-45 Magazine", description = "Magazine with 17 bullets, compatible with any 9mm pistol.", price = 65, itemID = 116, itemValue = 22, ammo = 17, license = true },
			{ name = "Desert Eagle Pistol", description = "A shiny Desert Eagle.", price = 1200, itemID = 115, itemValue = 24, license = true },
			{ name = "Desert Eagle Magazine", description = "Magazine with 7 bullets.", price = 100, itemID = 116, itemValue = 24, ammo = 7, license = true },
			{ name = "Shotgun", description = "A silver shotgun.", price = 1049, itemID = 115, itemValue = 25, license = true },
			{ name = "Shotgun Rounds", description = "10 rounds for a discount price!", price = 89, itemID = 116, itemValue = 25, ammo = 10, license = true },
			{ name = "Country Rifle", description = "A country rifle.", price = 1599, itemID = 115, itemValue = 33, license = true },
			{ name = "Country Rifle Magazine", description = "Magazine with 10 rounds for a country rifle.", price = 220, itemID = 116, itemValue = 33, ammo = 10, license = true },
		}
	},
	{ -- 3
		name = "Food Store",
		description = "The least poisoned food and drinks on the planet.",
		image = "food.png",
		
		{
			name = "Food",
			{ name = "Sandwich", description = "A yummy sandwich with cheese", price = 5, itemID = 8 },
			{ name = "Taco", description = "A greasy mexican taco", price = 7, itemID = 11 },
			{ name = "Burger", description = "A double cheeseburger with bacon", price = 6, itemID = 12 },
			{ name = "Donut", description = "Hot sticky sugar covered donut", price = 3, itemID = 13 },
			{ name = "Cookie", description = "A luxury chocolate chip cookie", price = 3, itemID = 14 },
			{ name = "Hotdog", description = "Nice, tasty hotdog!", price = 5, itemID = 1 },
			{ name = "Pancake", description = "Yummy, a pancake!!", price = 2, itemID = 108 },
		},
		{
			name = "Drink",
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 5, itemID = 9 },
			{ name = "Water", description = "A bottle of mineral water.", price = 3, itemID = 15 },
		}
	},
	{ -- 4
		name = "Sex Shop",
		description = "All of the items you'll need for the perfect night in.",
		image = "sex.png",
		
		{
			name = "Sexy",
			{ name = "Long Purple Dildo", description = "A very large purple dildo", price = 20, itemID = 115, itemValue = 10 },
			{ name = "Short Tan Dildo", description = "A small tan dildo.", price = 15, itemID = 115, itemValue = 11 },
			{ name = "Vibrator", description = "A vibrator, what more needs to be said?", price = 25, itemID = 115, itemValue = 12 },
			{ name = "Flowers", description = "A bouquet of lovely flowers.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Handcuffs", description = "A metal pair of handcuffs.", price = 90, itemID = 45 },
			{ name = "Rope", description = "A long rope.", price = 15, itemID = 46 },
			{ name = "Blindfold", description = "A black blindfold.", price = 15, itemID = 66 },
		},
		{
			name = "Clothes",
			{ name = "Skin 87", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 87 },
			{ name = "Skin 178", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 178 },
			{ name = "Skin 244", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 244 },
			{ name = "Skin 246", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 246 },
			{ name = "Skin 257", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 257 },
		}
	},
	{ -- 5
		name = "Clothes Shop",
		description = "You don't look fat in those!",
		image = "clothes.png",
		-- Items to be generated elsewhere.
		{
			name = "Clothes fitting you"
		},
		{
			name = "Others"
		}
	},
	{ -- 6
		name = "Gym",
		description = "The best place to learn about hand-to-hand combat.",
		image = "general.png",
		
		{
			name = "Fighting Styles",
			{ name = "Standard Combat for Dummies", description = "Standard everyday fighting.", price = 10, itemID = 20 },
			{ name = "Boxing for Dummies", description = "Mike Tyson, on drugs.", price = 50, itemID = 21 },
			{ name = "Kung Fu for Dummies", description = "I know kung-fu, so can you.", price = 50, itemID = 22 },
			-- item ID 23 is just a greek book, anyhow :o
			{ name = "Grab & Kick for Dummies", description = "Kick his 'ead in!", price = 50, itemID = 24 },
			{ name = "Elbows for Dummies", description = "You may look retarded, but you will kick his ass!", price = 50, itemID = 25 },
		}
	},
	{ -- 7
		name = "Rapid Auto Parts - Viozy",
		description = "If it isn't by Viozy, it's fraud. All sales posted reduced by 50% for exclusive members.",
		image = "viozy-auto.png",
		{
			name = "Tint Application",
			{ name = "HP Charcoal Window Film", description = "Viozy Window Films ((50 /chance))", price = 305 / priceReduce, itemID = 184, itemValue = "Viozy HP Charcoal Window Tint Film ((50 /chance))" },
			{ name = "CXP70 Window Film", description = "Viozy CXP70 Window Film ((95 /chance))", price = 490 / priceReduce, itemID = 185, itemValue = "Viozy CXP70 Window Film ((95 /chance))" },
			{ name = "Border Edge Cutter (Red Anodized)", description = "Border Edge Cutter for Tinting", price = 180 / priceReduce, itemID = 186, itemValue = "Viozy Border Edge Cutter (Red Anodized)" },
			{ name = "Solar Spectrum Tranmission Meter", description = "Spectrum Meter for testing film before use", price = 1000 / priceReduce, itemID = 187, itemValue = "Viozy Solar Spectrum Tranmission Meter" },
			{ name = "Tint Chek 2800", description = "Measures the Visible Light Transmission on any film/glass", price = 280 / priceReduce, itemID = 188, itemValue = "Viozy Tint Chek 2800" },
			{ name = "Equalizer Heatwave Heat Gun", description = "Easy to use heat gun perfect for shrinking back windows", price = 530 / priceReduce, itemID = 189, itemValue = "Viozy Equalizer Heatwave Heat Gun" },
			{ name = "36 Multi-Purpose Cutter Bucket", description = "Ideal for light cutting jobs while applying tint", price = 120 / priceReduce, itemID = 190, itemValue = "Viozy 36 Multi-Purpose Cutter Bucket" },
			{ name = "Tint Demonstration Lamp", description = "Effectve presentation of tinted application", price = 150 / priceReduce, itemID = 191, itemValue = "Viozy Tint Demonstration Lamp" },
			{ name = "Triumph Angled Scraper", description = "6-inch Angled Scraper for applying tint", price = 100 / priceReduce, itemID = 192, itemValue = "Viozy Triumph Angled Scraper" },
			{ name = "Performax 48oz Hand Sprayer", description = "Performax Hand Sprayer for tint application", price = 200 / priceReduce, itemID = 193, itemValue = "Viozy Performax 48oz Hand Sprayer" },

		},

		{
			name = "Mechanics",
			{ name = "Vehicle Ignition - 2010 ((20 /chance))", description = "Vehicle Ignition made by Viozy for 2010", price = 196 / priceReduce, itemID = 194, itemValue = "Viozy Vehicle Ignition - 2010 ((20 /chance))" },
			{ name = "Vehicle Ignition - 2011 ((30 /chance))", description = "Vehicle Ignition made by Viozy for 2011", price = 254 / priceReduce, itemID = 195, itemValue = "Viozy Vehicle Ignition - 2011 ((30 /chance))" },
			{ name = "Vehicle Ignition - 2012 ((40 /chance))", description = "Vehicle Ignition made by Viozy for 2012", price = 364 / priceReduce, itemID = 196, itemValue = "Viozy Vehicle Ignition - 2012 ((40 /chance))" },
			{ name = "Vehicle Ignition - 2013 ((50 /chance))", description = "Vehicle Ignition made by Viozy for 2013", price = 546 / priceReduce, itemID = 197, itemValue = "Viozy Vehicle Ignition - 2013 ((50 /chance))" },
			{ name = "Vehicle Ignition - 2014 ((70 /chance))", description = "Vehicle Ignition made by Viozy for 2014", price = 929 / priceReduce, itemID = 198, itemValue = "Viozy Vehicle Ignition - 2014 ((70 /chance))" },
			{ name = "Vehicle Ignition - 2015 ((90 /chance))", description = "Vehicle Ignition made by Viozy for 2015", price = 1765 / priceReduce, itemID = 199, itemValue = "Viozy Vehicle Ignition - 2015 ((90 /chance))" },
			{ name = "HVT 358 Portable Spark Nano 4.0 ((50 /chance))", description = "GPS HVT 358 Spark Nano 4.0 Portable ((50 /chance to be found)), by Viozy", price = 345 / priceReduce, itemID = 205, itemValue = "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))" },
			{ name = "Hidden Vehicle Tracker 272 Micro ((30 /chance))", description = "GPS HVT 272 Micro, easy installation ((30 /chance to be found)), by Viozy", price = 840 / priceReduce, itemID = 204, itemValue = "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))" },
			{ name = "Hidden Vehicle Tracker 315 Pro ((Undetectable))", description = "GPS HVT 315 Pro, easy installation ((and undetectable)), by Viozy", price = 2229 / priceReduce, itemID = 203, itemValue = "Viozy Hidden Vehicle Tracker 315 Pro ((Undetectable))" },
		},
		{
			name = "Discount Tires",
			{ name = "Access", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1098 },
			{ name = "Virtual", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1097 },
			{ name = "Ahab", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1096 },
			{ name = "Atomic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1085 },
			{ name = "Trance", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1084 },
			{ name = "Dollar", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1083 },
			{ name = "Import", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1082 },
			{ name = "Grove", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1081 },
			{ name = "Switch", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1080 },
			{ name = "Cutter", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1079 },
			{ name = "Twist", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1078 },
			{ name = "Classic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1077 },
			{ name = "Wires", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1076 },
			{ name = "Rimshine", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1075 },
			{ name = "Mega", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1074 },
			{ name = "Shadow", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1073 },
			{ name = "Offroad", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1025 },

		}

	},
	{ -- 8
		name = "Elektronik Mağazası",
		description = "Son teknoloji, son derece kaliteli ürünler burada!",
		image = "general.png",
		
		{
			name = "Elektronikler",
			{ name = "Seyyar Teyp", description = "Siyah bir seyyar teyp.", price = 550, itemID = 54 },
			{ name = "Kamera", description = "Küçük siyah bir analog kamera.", price = 75, itemID = 115, itemValue = 43 },
			{ name = "Cep Telefonu", description = "Şık, ince bir cep telefonu.", price = 500, itemID = 2 },
			{ name = "Telsiz", description = "Siyah bir telsiz.", price = 50, itemID = 6 },
			{ name = "Kulaklık", description = "Bir telsiz ile kullanılabilen bir kulaklık.", price = 225, itemID = 88 },
			{ name = "Saat", description = "Zaman söylemek asla çok seksi değildi!", price = 25, itemID = 17 },
			{ name = "MP3 Çalar", description = "Beyaz, şık görünümlü MP3 Çalar. Markasında EyePod yazar.", price = 120, itemID = 19 },
			{ name = "Kimya Seti", description = "Küçük bir kimya seti.", price = 2000, itemID = 44 },
			{ name = "Kasa", description = "Eşyalarınızı güvende tutmak için bir kasa.", price = 300, itemID = 60 },
			--{ name = "GPS", description = "A GPS Satnav for a car.", price = 300, itemID = 67 },
			{ name = "Taşınabilir GPS", description = "Son haritalar ile kişisel küresel konumlandırma cihazı.", price = 800, itemID = 111 },
			{ name = "Macbook pro A1286 Core i7", description = "E-postaları görüntülemek ve internette gezinmek için Macbook'un en üst noktası.", price = 1500, itemID = 96 },
			{ name = "Taşınabilir TV", description = "TV seyretmek için taşınabilir bir TV.", price = 750, itemID = 104 },
			{ name = "Geçiş Aleti", description = "Aracınız için: Otomatik geçiş kapısından geçerken sizi otomatik olarak ücretlendirir.", price = 400, itemID = 118 },
			{ name = "Araç Alarm Sistemi", description = "Aracınızı bir alarm ile koruyun.", price = 800, itemID = 130 },
			{ name = "El Feneri", description = "Kaliteli marka bir el feneri.", price = 5000, itemID = 145 },
		}
	},
	{ -- 9
		name = "Alcohol Store",
		description = "Everything from Vodka to Beer and the other way round.",
		image = "general.png",
		
		{
			name = "Drinks",
			{ name = "Enes Pilsen Bira", description = "Bira bu kapağın altındadır - Efes Pilsen.", price = 10, itemID = 58, minimum_age = 21 },
			{ name = "Tuborg Bira", description = "Adam gibi bira - Tuborg Bira", price = 25, itemID = 229, minimum_age = 21 },
			{ name = "İstanblue Vodka", description = "Anlatmaya Hazır Mısın? - İstanblue Vodka ", price = 25, itemID = 62, minimum_age = 21 },
			{ name = "Jack Daniels Viski", description = "Asla unutamayacağınız arkadaşlarınızla geçireceğiniz asla hatırlayamayacağınız anılara. ", price = 15, itemID = 63, minimum_age = 21 },
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 3, itemID = 9 },
		}
	},
	{ -- 10
		name = "Book Store",
		description = "New things to learn? Sound like... fun?!",
		image = "general.png",
		
		{
			name = "Books",
			{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			{ name = "Los Santos Highway Code", description = "A paperback book.", price = 10, itemID = 50 },
			{ name = "Chemistry 101", description = "A hardback academic book.", price = 20, itemID = 51 },
			{ name = "Blank Book", description = "A hardcover book with nothing written in it.", price = 40, itemID = 178, itemValue = "New Book"},
		}
	},
	{ -- 11
		name = "Cafe",
		description = "You want some chocolate on your rim?",
		image = "food.png",
		
		{
			name = "Food",
			{ name = "Donut", description = "Hot sticky sugar covered donut", price = 3, itemID = 13 },
			{ name = "Cookie", description = "A luxuty chocolate chip cookie", price = 3, itemID = 14 },
		},
		{
			name = "Drinks",
			{ name = "Coffee", description = "A small cup of coffee.", price = 1, itemID = 83, itemValue = 2 },
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 3, itemID = 9, itemValue = 3 },
			{ name = "Water", description = "A bottle of mineral water.", price = 1, itemID = 15, itemValue = 2 },
		}	
	},
	{ -- 12
		name = "Restorant Satıcısı",
		description = "Açlığınız için ideal.",
		image = "general.png",
		
		{
			name = "Restorant Saticisi",
			{ name = "Hindi", description = "Taze pişmiş hindi eti!", price = 15, itemID = 92 },
			{ name = "Su", description = "Soğuk & Sıcak su.", price = 2, itemID = 15, itemValue = 2 },
			{ name = "Donut", description = "Sıcak yapışkan şeker kaplı çörek.", price = 15, itemID = 13 },
			{ name = "Kurabiye", description = "Bir luxuty çikolatalı kurabiye.", price = 12, itemID = 14 },
			{ name = "Kahve", description = "Küçük bir bardak kahve.", price = 7, itemID = 83, itemValue = 2 },
			{ name = "Küçük Süt Kutusu", description = "Taze günlük süt.", price = 5, itemID = 100 },
			{ name = "Absolut Vodka", description = "Absolut Vodka %40 alkol oranlı içki.", price = 50, itemID = 62, minimum_age = 21 },
			{ name = "Jack Daniels Viski", description = "En iyi içecek Jack Daniels Viskisi %43 alkol oranlı içki.", price = 75, itemID = 63, minimum_age = 21 },
		}
	},
	{ -- 13
		name = "Prison Worker",
		description = "Now that looks... vaguely tasty.",
		image = "general.png",
		
		{
			name  = "Disgusting Stuff",
			{ name = "Mixed Dinner Tray", description = "Lets play the guessing game.", price = 0, itemID = 99 },
			{ name = "Small Milk Carton", description = "Lumps included!", price = 0, itemID = 100 },
			{ name = "Small Juice Carton", description = "Thirsty?", price = 0, itemID = 101 },
		}
	},
	{ -- 14
		name = "One Stop Mod Shop",
		description = "Any parts you'll ever need!",
		image = "general.png",
		
		-- items to be filled in later
		{
			name = "Vehicle Parts"
		}
	},
	{ -- 15
		name = "NPC",
		description = "(( This is just an NPC, not meant to hold any items. ))",
		image = "general.png",
		
		{
			name = "No items"
		}
	},
	{ -- 16
		name = "Hardware Store",
		description = "Need some tools?!",
		image = "general.png",
		
		{
			name = "Power Tools",
			{ name = "Power Drill", description = "An electric battery operated drill.", price = 50, itemID = 80, itemValue = "Power Drill" },
			{ name = "Power Saw", description = "An electric plug-in saw.", price = 65, itemID = 80, itemValue = "Power Saw" },
			{ name = "Pneumatic Nail Gun", description = "A pneumatic-operated nail gun.", price = 80, itemID = 80, itemValue = "Pneumatic Nail Gun" },
			{ name = "Pneumatic Paint Gun", description = "A pneumatic-operated nail gun.", price = 90, itemID = 80, itemValue = "Pneumatic Paint Gun" },
			{ name = "Air Wrench", description = "A pneumatic-operated wrench.", price = 80, itemID = 80, itemValue = "Air Wrench" },
			{ name = "Torch", description = "A mobile natural-gas operated torch set.", price = 80, itemID = 80, itemValue = "Mobile Torch Set" },
			{ name = "Electric Welder", description = "A mobile plug-in electricity operated electric welder.", price = 80, itemID = 80, itemValue = "Mobile Electric Welder" },
		},
		{
			name = "Hand Tools",
			{ name = "Hammer", description = "An iron hammer.", price = 25, itemID = 80, itemValue = "Iron Hammer" },
			{ name = "Phillips Screwdriver", description = "A phillips screwdriver.", price = 5, itemID = 80, itemValue = "Phillips Screwdriver" },
			{ name = "Flathead Screwdriver", description = "A flathead screwdriver.", price = 5, itemID = 80, itemValue = "Flathead Screwdriver" },
			{ name = "Robinson Screwdriver", description = "A robinson screwdriver.", price = 6, itemID = 80, itemValue = "Robinson Screwdriver" },
			{ name = "Torx Screwdriver", description = "A torx screwdriver.", price = 8, itemID = 80, itemValue = "Torx Screwdriver" },
			{ name = "Needlenose Pliers", description = "Pliers.", price = 25, itemID = 80, itemValue = "Needlenose Pliers" },
			{ name = "Crowbar", description = "A large iron crowbar.", price = 30, itemID = 80, itemValue = "Iron Crowbar" },
			{ name = "Tire Iron", description = "A tire iron.", price = 25, itemID = 80, itemValue = "Tire Iron" },
			{ name = "Wrench", description = "An adjustable wrench.", price = 7, itemID = 80, itemValue = "Wrench" },
			{ name = "Monkey Wrench", description = "A large monkey wrench.", price = 12, itemValue = "Monkey Wrench" },
			{ name = "Socket Wrench", description = "A socket wrench.", price = 8, itemValue = "Socket Wrench" },
			{ name = "Torque Wrench", description = "A large torque wrench.", price = 35, itemID = 80, itemValue = "Torque Wrench" },
			{ name = "Vise Grip", decsription = "A vise grip.", price = 12, itemID = 80, itemValue = "Vise Grip" },
			{ name = "Wirecutters", decsription = "Used to cut wires.", price = 6, itemID = 80, itemValue = "Wirecutters" },
			{ name = "Hack Saw", description = "A hack saw.", price = 40, itemID = 80, itemValue = "Hack Saw" },
		},
		{
			name = "Screws & Nails",
			{ name = "Phillips Screws", description = "A box of phillips screws.", price = 3, itemID = 80, itemValue = "Phillips Screws (100)" },
			{ name = "Flathead Screws", description = "A box of flathead screws.", price = 3, itemID = 80, itemValue = "Flathead Screws (100)" },
			{ name = "Robinson Screws", description = "A box of robinson screws.", price = 3, itemID = 80, itemValue = "Robinson Screws (100)" },
			{ name = "Torx Screws", description = "A box of torx screws.", price = 3, itemID = 80, itemValue = "Torx Screws (100)" },
			{ name = "Iron Nails", description = "A box of iron nails.", price = 2, itemID = 80, itemValue = "Iron Nails (100)" },
		},
		{
			name = "Misc.",
			{ name = "Bosch 6 Gallon Air Compressor", description = "A 6 gallon Bosch air compressor.", price = 300, itemID = 80, itemValue = "Bosch 6 Gallon Air Compressor" },
			{ name = "Leather Gloves", description = "Wearable protective leather gloves.", price = 2, itemID = 80, itemValue = "Leather Gloves" },
			{ name = "Latex Gloves", description = "Wearable latex gloves.", price = 1, itemID = 80, itemValue = "Latex Gloves" },
			{ name = "Chlorex Bleach", description = "A bottle of Chlorex bleach.", price = 13, itemID = 80, itemValue = "Chlorex Bleach" },
			{ name = "Paint Can", description = "A can of paint in your colour of choice.", price = 10, itemID = 80, itemValue = "Paint Can" },
			{ name = "Toolbox", description = "A red metal toolbox.", price = 20, itemID = 80, itemValue = "Red Metal Toolbox" },
			{ name = "Rubbermaid Plastic Trashcan", description = "A Rubbermaid plastic trashcan.", price = 25, itemID = 80, itemValue = "Rubbermaid Plastic Trashcan" },
		}
	},
	{ -- 17
		name = "Tamirci Dükkanı",
		description = " ",
		image = "general.png",
	},
	{ -- 18
		name = "Faction Drop NPC - General Items",
		description = " ",
		image = "general.png",
	},
	{ -- 19
		name = "Faction Drop NPC - Weapons",
		description = " ",
		image = "general.png",
	},
	{ -- 20
		name = "Aksesuar Dükkanı",
		description = " ",
		image = "general.png",
		
		{
			name = "Maskeler",
			{ name = "Domuz Maskesi", description = "Aksesuar.", price = 500, itemID = 220, itemValue = "1" },
			{ name = "Canavar Maskesi", description = "Aksesuar.", price = 500, itemID = 221, itemValue = "1" },
			{ name = "Hokey Maskesi", description = "Aksesuar.", price = 500, itemID = 222, itemValue = "1" },
			{ name = "Maymun Maskesi", description = "Aksesuar.", price = 500, itemID = 223, itemValue = "1" },
			{ name = "Sigara İçen Maymun Maskesi", description = "Aksesuar.", price = 500, itemID = 224, itemValue = "1" },
			{ name = "Karnaval Maskesi", description = "Aksesuar.", price = 500, itemID = 225, itemValue = "1" },
			{ name = "Balkabagi", description = "Halloween.", price = 2000, itemID = 231, itemValue = "1" },
			{ name = "Devamı Eklenecek", description = "Devamı Eklenecek.", price = 999999999, itemID = 219, itemValue = "1" },
		},
		{
			name = "Şapkalar",
			{ name = "Fakir Şapkası", description = "Aksesuar.", price = 250, itemID = 218, itemValue = "1" },
			{ name = "Noel Şapkası", description = "Aksesuar.", price = 250, itemID = 219, itemValue = "1" },
			{ name = "Devamı Eklenecek", description = "Devamı Eklenecek.", price = 999999999, itemID = 219, itemValue = "1" },
		},
		{
			name = "Gözlükler",
			{ name = "Siyah Güneş Gözlüğü", description = "Aksesuar.", price = 250, itemID = 227, itemValue = "1" },
			{ name = "Siyah Güneş Gözlüğü #1", description = "Aksesuar.", price = 2000, itemID = 232, itemValue = "1" },
			{ name = "Devamı Eklenecek", description = "Devamı Eklenecek.", price = 999999999, itemID = 219, itemValue = "1" },
		},
		{
			name = "Eşyalar",
			{ name = "Gitar", description = "Aksesuar.", price = 750, itemID = 226, itemValue = "1" },
			{ name = "Mikrafon", description = "Elde tutulabilir aksesuar", price = 200, itemID = 228, itemValue = "1" },
			{ name = "Devamı Eklenecek", description = "Devamı Eklenecek.", price = 999999999, itemID = 219, itemValue = "1" },
		},
	},
	{ -- 20
		name = "Pet Shop",
		description = " ",
		image = "general.png",
		
		{
			name = "Pet Shop",
			--{ name = "Köpek Maması", description = "", price = 500, itemID = 897, itemValue = "1" },
			{ name = "Beyaz Pitbull", description = "", price = 100000, itemID = 890, itemValue = "1" },
			{ name = "Siyah Pitbull", description = "", price = 100000, itemID = 891, itemValue = "1" },
			{ name = "Gri Pitbull", description = "", price = 100000, itemID = 892, itemValue = "1" },
			{ name = "German Boxer", description = "", price = 100000, itemID = 893, itemValue = "1" },
			{ name = "Alman Kurdu", description = "", price = 100000, itemID = 894, itemValue = "1" },
			{ name = "Husky", description = "", price = 100000, itemID = 895, itemValue = "1" },
			{ name = "Rottweiler", description = "", price = 100000, itemID = 896, itemValue = "1" },
			{ name = "French Bulldog2", description = "", price = 100000, itemID = 898, itemValue = "1" },
		},
	},	
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['vrp_languages']:getLanguageCount() do
		local ln = exports['vrp_languages']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " Dictionary", description = "A Dictionary, useful for learning " .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getItemFromIndex( shop_type, index )
	local shop = g_shops[ shop_type ]
	if shop then
		for _, category in ipairs( shop ) do
			if index <= #category then
				return category[index]
			else
				index = index - #category
			end
		end
	end
end

--
--local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- one simple small cache it is - prevents us from creating those tables again and again
		--[[
		local c = simplesmallcache[tostring(race) .. "|" .. tostring(gender)]
		if c then
			shop = c
			return
		end
		]]
		
		-- load the shop
		local shop = g_shops[shop_type]
		
		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			table.insert( shop[1], { name = "Skin " .. v, description = "MTA Skin #" .. v .. ".", price = 50, itemID = 16, itemValue = v, fitting = true } )
			nat[v] = true
		end
		
		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)
		
		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Skin " .. v, description = "MTA Skin #" .. v .." - you can NOT wear this.", price = 50, itemID = 16, itemValue = v } )
		end
		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		--[[local c = simplesmallcache["vm"]
		if c then
			return
		end]]
		
		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['vrp_items']:getItemDescription( 114, v )
				
				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				if not disabledUpgrades[v] then
					table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
				end
			end
		end
		
		--simplesmallcache["vm"] = true
	end
end

function getFittingSkins()
	return fittingskins
end

--Faction Drop
weaponList = {
--	ItemID, ItemValue, ItemName
    {115, 10, "Kazma"},
	{115, 22, "Colt 45"},
	--{116, 22, "Ammo for Colt 45"},
	{115, 24, "Deagle"},
	--{116, 24, "Ammo for Deagle"},
	{115, 23, "Silenced"},
	--{116, 23, "Ammo for Silenced"},
	{115, 25, "Shotgun"},
	--{116, 25, "Ammo for Shotgun"},
	{115, 32, "Tec-9"},
	--{116, 32, "Ammo for Tec-9"},
	{115, 28, "Uzi"},
	--{116, 28, "Ammo for Uzi"},
	--{115, 29, "MP5"},
	--{116, 29, "Ammo for MP5"},
	--{115, 30, "AK-47"},
	--{116, 30, "Ammo for AK-47"},
	--{115, 31, "M4A1"},
	--{116, 31, "Ammo for M4A1"},
	--{115, 18, "Molotov"},
	--{116, 18, "Ammo for Molotov"},
	--{115, 3, "Nightstick"},
	--{116, 3, "Ammo for Nightstick"},
	--{115, 8, "Katana"},
	--{116, 8, "Ammo for Katana"},
	--{115, 9, "Chainsaw"},
	--{116, 9, "Ammo for Chainsaw"},
	--{115, 1, "Brass Knuckles"},
	--{116, 1, "Ammo for Brass Knuckles"},
	--{115, 34, "Sniper"},
	--{116, 34, "Ammo for Sniper"},
	--{115, 26, "Sawed-off"},
	--{116, 26, "Ammo for Sawed-off"},
	--{115, 33, "Country Rifle"},
	--{116, 33, "Ammo for Country Rifle"},
	--{115, 27, "Combat Shotgun"},
	--{116, 27, "Ammo for Combat Shotgun"},
	--{115, 35, "Rocket Launcher"},
	--{116, 35, "Ammo for Rocket Launcher"},
}
