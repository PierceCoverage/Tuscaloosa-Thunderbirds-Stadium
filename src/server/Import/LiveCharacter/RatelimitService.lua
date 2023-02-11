shared.globalCalls = 0

local Ratelimit = {
	MaxRequestsPerMinute = 300,
	IsRatelimited = false
}

function Ratelimit:callOnFunction(func, ...)	
	if shared.globalCalls >= Ratelimit.MaxRequestsPerMinute then
		--warn('LiveCharacter | Ratelimit hit | Cooling down...')
		repeat wait(1) until shared.globalCalls <= Ratelimit.MaxRequestsPerMinute
	end
	
	shared.globalCalls = shared.globalCalls + 1
	
	delay(1.5, function()
		shared.globalCalls = shared.globalCalls - 1
	end)
	
	--warn('LiveCharacter | Call budget : ' .. shared.globalCalls .. ' / ' .. Ratelimit.MaxRequestsPerMinute)
	return func(...)
end

return Ratelimit
