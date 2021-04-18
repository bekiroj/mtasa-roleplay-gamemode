local browserName = "Safari"
local home_url = "m.google.com"
local wBrowser, zBrowser, cefBrowser, eAddressBar, bUnblockResources

local screenWidth, screenHeight = guiGetScreenSize()
local outputDebugString = function() end

local computerWidth = 1080
local computerHeight = 700
if screenWidth < computerWidth or screenHeight < computerHeight then
    screenWidth, screenHeight = 800, 500
end
local domains = {
	-- domains that exist locally only
	{ fake = 'google.sa', real = 'm.google.com', ssl = true, query = '/ncr' },
	{ fake = 'jgc.sa', real = 'jgcweb.net' },
	{ fake = 'jgcweb.sa', real = 'jgcweb.net' },
	{ fake = 'clubx.sa', real = 'jgcweb.net/clubx' },
	{ fake = 'youtube.sa', real = 'youtube.com', query = '/tv', append_query_only_on_fake_url = true, ssl = true },
}

function getDomainInformation(domain)
	local domain = domain:gsub("www.", ""):lower()
	for _, info in ipairs(domains) do
		if info.fake == domain or info.real == domain then
			return info
		end
	end
	return nil
end

local simple_top_level_domains = {'com', 'org', 'net', 'eu', 'me', 'info', 'biz'}
function getDomainForRequestingWhitelist(domain)
	local s = split(domain, '.')
	if #s < 2 then
		return domain
	end

	for _, name in ipairs(simple_top_level_domains) do
		if s[#s] == name then
			return s[#s-1] .. "." .. name
		end
	end
	return domain
end

local blocked_domains = {'.sa', '.ls', '.gov', 'doubleclick.net'}
function isBlockedDomain(domain)
	if #domain <= 2 then
		return false
	end

	for _, d in ipairs(blocked_domains) do
		if domain:sub(#domain - #d + 1, #domain) == d then
			return true
		end
	end
	return false
end



local function getUrlInfo(url)
    local ssl = url:sub(1, 5) == "https"
    local segments = exports.vrp_global:split(url:gsub("http://", ""):gsub("https://", ""), "/")
    local domain = segments[1]

    table.remove(segments, 1)
    local query = "/" .. table.concat(segments, "/")

    local info = getDomainInformation(domain)
    return domain, query or "/", info, ssl
end

local function getRequestingDomain(url)
    local domain = getUrlInfo(url)
    local request = getDomainForRequestingWhitelist(domain)
    if isBrowserDomainBlocked(domain) and not isBrowserDomainBlocked(request) or domain == request then
        return {url}, true
    end
    return {request, domain}, false
end
local function switchBrowserMode(new)
    setBrowserRenderingPaused(cefBrowser, not new)
    guiSetVisible(zBrowser, new)
end
function loadCEFURLDirectly(url)
    switchBrowserMode(true)
    local loaded = loadBrowserURL(cefBrowser, url)
    outputDebugString("Loading URL " .. url .. ", loaded? " .. tostring(loaded))
    if not loaded then
        local urls, is_url = getRequestingDomain(url)
        requestBrowserDomains(urls, is_url, function(wasAccepted)
            if wasAccepted then
                outputDebugString("User accepted domain request, loading " .. url)
                setTimer(function() loadBrowserURL(cefBrowser, url) end, 1000, 1)
            else
                outputDebugString("User declined domain request for " .. url)
                updateDisplayedInfo()
            end
        end)
    end
end

local function formatURL(domain, query, info, ssl)
    if info ~= nil then
        domain = info.fake
        if info.query and query == info.query then
            query = "/"
        end
    end
    local scheme = ssl and "https://" or ""


    return scheme .. domain .. query
end

local function loadURL(url)
    outputDebugString("Requesting URL " .. url)
    local domain, query, info, ssl = getUrlInfo(url)
    if info ~= nil then
        -- we're visiting a fake domain, replace it with the real one.
        if info.real then
            if query == "/" and (domain:gsub("www.", "") == info.fake or not info.append_query_only_on_fake_url) and info.query then
                query = info.query
            end

            domain = info.real

            local scheme = (ssl or info.ssl) and "https://" or "http://"
            loadCEFURLDirectly(scheme .. domain .. query)
        elseif info.fn then
            closeComputerWindow()
            info.fn()
        else
            get_page(domain .. query)
        end
    elseif isBlockedDomain(domain) then
        -- old, pre-CEF local browser emulation
        get_page("error_404")
    else
        -- not a domain we necessarily know anything about.
        loadCEFURLDirectly((ssl and "https://" or "http://") .. domain .. query)
    end
end

function showFormattedURL(url)
    guiSetText(eAddressBar, (url and #url > 0) and formatURL(getUrlInfo(url)) or "")
end

function updateDisplayedInfo()
   -- guiSetText(wBrowser, getBrowserTitle(cefBrowser) .. " - " .. browserName)
    showFormattedURL(getBrowserURL(cefBrowser))
end

local function navigatedToPage(url, blocked)
    local domain = getUrlInfo(url)
    if blocked then
        if isBlockedDomain(domain) then return end

        outputDebugString("Navigation to page " .. url .. " was blocked")

        local urls, is_url = getRequestingDomain(url)
        requestBrowserDomains(urls, is_url, function(wasAccepted)
            if wasAccepted then
                -- url = getBrowserURL(cefBrowser) maybe this gets around the iframe bug?
                outputDebugString("User accepted domain request, loading " .. url)
                setTimer(function() loadBrowserURL(cefBrowser, url) end, 1000, 1)
            else
                outputDebugString("User declined domain request for " .. url)
                updateDisplayedInfo()
            end
        end)
    else
        showFormattedURL(url)
    end
end

local function toggleUnblockResources()
    local any = false
    for _ in pairs(blockedResources) do
        any = true
        break
    end
end


function toggleSafari(stating)
	if stating then
		safariActive = true
		guiSetInputEnabled(true)
		eAddressBar = guiCreateEdit(45,82,200,16,home_url,false,wPhoneMenu)
		label = guiCreateLabel(0,0,200,16,guiGetText(eAddressBar),false,eAddressBar)
		guiLabelSetColor(label, 142,142,143)
		guiSetFont(label,"default-small")
		guiSetEnabled(label,false)
		guiSetAlpha(eAddressBar,0)
		addEventHandler("onClientGUIAccepted", eAddressBar, function() loadURL(tostring(guiGetText(source))) end, false)
		addEventHandler("onClientGUIClick", eAddressBar, function() focusBrowser(nil) end, false)

		addEventHandler("onClientGUIChanged", eAddressBar, function(edit)
			guiSetText(label, guiGetText(edit))
		end)

	    zBrowser = guiCreateBrowser(17, 105, 233, 412-30, false, false, false, wPhoneMenu)

	    addEventHandler("onClientBrowserCreated", zBrowser, function()
	        cefBrowser = source

	        loadURL(home_url)

	        addEventHandler("onClientBrowserDocumentReady", source, updateDisplayedInfo)
	        addEventHandler("onClientBrowserNavigate", source, navigatedToPage)
	        addEventHandler("onClientBrowserLoadingStart", source, function() blockedResources = {} toggleUnblockResources() showFormattedURL() end)
	        addEventHandler("onClientBrowserLoadingFailed", source, function(...) outputDebugString("Loading Failed: " .. toJSON({...})) end)
	        addEventHandler("onClientBrowserResourceBlocked", source, function(url, domain, reason) if reason == 0 and not isBlockedDomain(domain) then blockedResources[domain] = true; toggleUnblockResources() end end)
	    end)


	else
		guiSetInputEnabled(false)
		safariActive = false
		if isElement(eAddressBar) then
			destroyElement(eAddressBar)
		end
		if isElement(zBrowser) then
			destroyElement(zBrowser)
		end
	end
end