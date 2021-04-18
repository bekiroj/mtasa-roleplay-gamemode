local function loadClass()
    ---------
    -- Start of slither.lua dependency
    ---------

    local _LICENSE = -- zlib / libpng
    [[
    Copyright (c) 2011-2014 Bart van Strien

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

      1. The origin of this software must not be misrepresented; you must not
      claim that you wrote the original software. If you use this software
      in a product, an acknowledgment in the product documentation would be
      appreciated but is not required.

      2. Altered source versions must be plainly marked as such, and must not be
      misrepresented as being the original software.

      3. This notice may not be removed or altered from any source
      distribution.
    ]]

    local class =
    {
        _VERSION = "Slither 20140904",
        -- I have no better versioning scheme, deal with it
        _DESCRIPTION = "Slither is a pythonic class library for lua",
        _URL = "http://bitbucket.org/bartbes/slither",
        _LICENSE = _LICENSE,
    }

    local function stringtotable(path)
        local t = _G
        local name

        for part in path:gmatch("[^%.]+") do
            t = name and t[name] or t
            name = part
        end

        return t, name
    end

    local function class_generator(name, b, t)
        local parents = {}
        for _, v in ipairs(b) do
            parents[v] = true
            for _, v in ipairs(v.__parents__) do
                parents[v] = true
            end
        end

        local temp = { __parents__ = {} }
        for i, v in pairs(parents) do
            table.insert(temp.__parents__, i)
        end

        local class = setmetatable(temp, {
            __index = function(self, key)
                if key == "__class__" then return temp end
                if key == "__name__" then return name end
                if t[key] ~= nil then return t[key] end
                for i, v in ipairs(b) do
                    if v[key] ~= nil then return v[key] end
                end
                if tostring(key):match("^__.+__$") then return end
                if self.__getattr__ then
                    return self:__getattr__(key)
                end
            end,

            __newindex = function(self, key, value)
                t[key] = value
            end,

            allocate = function(instance)
                local smt = getmetatable(temp)
                local mt = {__index = smt.__index}

                function mt:__newindex(key, value)
                    if self.__setattr__ then
                        return self:__setattr__(key, value)
                    else
                        return rawset(self, key, value)
                    end
                end

                if temp.__cmp__ then
                    if not smt.eq or not smt.lt then
                        function smt.eq(a, b)
                            return a.__cmp__(a, b) == 0
                        end
                        function smt.lt(a, b)
                            return a.__cmp__(a, b) < 0
                        end
                    end
                    mt.__eq = smt.eq
                    mt.__lt = smt.lt
                end

                for i, v in pairs{
                    __call__ = "__call", __len__ = "__len",
                    __add__ = "__add", __sub__ = "__sub",
                    __mul__ = "__mul", __div__ = "__div",
                    __mod__ = "__mod", __pow__ = "__pow",
                    __neg__ = "__unm", __concat__ = "__concat",
                    __str__ = "__tostring",
                    } do
                    if temp[i] then mt[v] = temp[i] end
                end

                return setmetatable(instance or {}, mt)
            end,

            __call = function(self, ...)
                local instance = getmetatable(self).allocate()
                if instance.__init__ then instance:__init__(...) end
                return instance
            end
            })

        for i, v in ipairs(t.__attributes__ or {}) do
            class = v(class) or class
        end

        return class
    end

    local function inheritance_handler(set, name, ...)
        local args = {...}

        for i = 1, select("#", ...) do
            if args[i] == nil then
                error("nil passed to class, check the parents")
            end
        end

        local t = nil
        if #args == 1 and type(args[1]) == "table" and not args[1].__class__ then
            t = args[1]
            args = {}
        end

        for i, v in ipairs(args) do
            if type(v) == "string" then
                local t, name = stringtotable(v)
                args[i] = t[name]
            end
        end

        local func = function(t)
            local class = class_generator(name, args, t)
            if set then
                local root_table, name = stringtotable(name)
                root_table[name] = class
            end
            return class
        end

        if t then
            return func(t)
        else
            return func
        end
    end

    function class.private(name)
        return function(...)
            return inheritance_handler(false, name, ...)
        end
    end

    class = setmetatable(class, {
        __call = function(self, name)
            return function(...)
                return inheritance_handler(true, name, ...)
            end
        end,
    })


    function class.issubclass(class, parents)
        if parents.__class__ then parents = {parents} end
        for i, v in ipairs(parents) do
            local found = true
            if v ~= class then
                found = false
                for _, p in ipairs(class.__parents__) do
                    if v == p then
                        found = true
                        break
                    end
                end
            end
            if not found then return false end
        end
        return true
    end

    function class.isinstance(obj, parents)
        return type(obj) == "table" and obj.__class__ and class.issubclass(obj.__class__, parents)
    end

    -- Export a Class Commons interface
    -- to allow interoperability between
    -- class libraries.
    -- See https://github.com/bartbes/Class-Commons
    --
    -- NOTE: Implicitly global, as per specification, unfortunately there's no nice
    -- way to both provide this extra interface, and use locals.
    if common_class ~= false then
        common = {}
        function common.class(name, prototype, superclass)
            prototype.__init__ = prototype.init
            return class_generator(name, {superclass}, prototype)
        end

        function common.instance(class, ...)
            return class(...)
        end
    end

    ---------
    -- End of slither.lua dependency
    ---------

    return class;
end

local class = loadClass();

--- GTA:MTA Lua instance thread scheduler.
-- @author Disco
-- @license MIT
-- @dependency slither.lua https://bitbucket.org/bartbes/slither

class "_instance" {

    -- Constructor mehtod
    -- Starts timer to manage scheduler
    -- @access public
    -- @usage local instancemanager = instance();
    __init__ = function(self)

        self.threads = {};
        self.resting = 50; -- in ms (resting time)
        self.maxtime = 200; -- in ms (max thread iteration time)
        self.current = 0;  -- starting frame (resting)
        self.state = "suspended"; -- current scheduler executor state
        self.debug = false;
		self.debugdb = true;
        self.priority = {
            low = {500, 50},     -- better fps
            normal = {200, 200}, -- medium
            high = {50, 500}     -- better perfomance
        };

        self:setPriority("low");
    end,


    -- Switch scheduler state
    -- @access private
    -- @param boolean [istimer] Identifies whether or not
        -- switcher was called from main loop
    switch = function(self, istimer)
        self.state = "running";

        if (self.current + 1  <= #self.threads) then
            self.current = self.current + 1;
            self:execute(self.current);
        else
            self.current = 0;

            if (#self.threads <= 0) then
                self.state = "suspended";
                return;
            end

            -- setTimer(function theFunction, int timeInterval, int timesToExecute)
            -- (GTA:MTA server scripting function)
            -- For other environments use alternatives.
            setTimer(function()
                self:switch();
            end, self.resting, 1);
        end
    end,


    -- Managing thread (resuming, removing)
    -- In case of "dead" thread, removing, and skipping to the next (recursive)
    -- @access private
    -- @param int id Thread id (in table instance.threads)
    execute = function(self, id)
        local thread = self.threads[id];

        if (thread == nil or coroutine.status(thread) == "dead") then
            table.remove(self.threads, id);
            self:switch();
        elseif (thread and coroutine.status(thread) ~= "running") then
            coroutine.resume(thread);
            self:switch();
        end
    end,


    -- Adding thread
    -- @access private
    -- @param function func Function to operate with
    add = function(self, func)
        local thread = coroutine.create(func);
        table.insert(self.threads, thread);
    end,


    -- Set priority for executor
    -- Use before you call 'iterate' or 'foreach'
    -- @access public
    -- @param string|int param1 "low"|"normal"|"high" or number to set 'resting' time
    -- @param int|void param2 number to set 'maxtime' of thread
    -- @usage instance:setPriority("normal");
    -- @usage instance:setPriority(50, 200);
    setPriority = function(self, param1, param2)
        if (type(param1) == "string") then
            if (self.priority[param1] ~= nil) then
                self.resting = self.priority[param1][1];
                self.maxtime = self.priority[param1][2];
            end
        else
            self.resting = param1;
            self.maxtime = param2;
        end
    end,

    -- Set debug mode enabled/disabled
    -- @access public
    -- @param boolean value true - enabled, false - disabled
    -- @usage instance:setDebug(true);
    setDebug = function(self, value)
        self.debug = value;
    end,


    -- Iterate on interval (for cycle)
    -- @access public
    -- @param int from Iterate from
    -- @param int to Iterate to
    -- @param function func Iterate using func
        -- Function func params:
        -- @param int [i] Iteration index
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:iterate(1, 10000, function(i)
        --     print(i);
        -- end);
    iterate = function(self, from, to, func, callback)
        self:add(function()
            local a = getTickCount();
            local lastresume = getTickCount();
            for i = from, to do
                func(i);

                -- int getTickCount()
                -- (GTA:MTA server scripting function)
                -- For other environments use alternatives.
                if getTickCount() > lastresume + self.maxtime then
                    coroutine.yield()
                    lastresume = getTickCount()
                end
            end
            if (self.debug) then
                print("[DEBUG]instance iterate: " .. (getTickCount() - a) .. "ms");
            end
            if (callback) then
                callback();
            end
        end);

        self:switch();
    end,

    -- Iterate over array (foreach cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func Iterate using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:foreach(vehicles, function(vehicle, id)
        --     print(vehicle.title);
        -- end);
    foreach = function(self, array, func, callback)
        self:add(function()
            local a = getTickCount();
            local lastresume = getTickCount();
            for k,v in ipairs(array) do
                func(v,k);

                -- int getTickCount()
                -- (GTA:MTA server scripting function)
                -- For other environments use alternatives.
                if getTickCount() > lastresume + self.maxtime then
                    coroutine.yield()
                    lastresume = getTickCount()
                end
            end
            if (self.debug) then
                print("[DEBUG]instance foreach: " .. (getTickCount() - a) .. "ms");
            end
            if (callback) then
                callback();
            end
        end);

        self:switch();
    end,

    -- foreach_pairs
    -- Iterate over array (foreach cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func Iterate using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:foreach(vehicles, function(vehicle, id)
        --     print(vehicle.title);
        -- end);
    foreach_pairs = function(self, array, func, callback)
        self:add(function()
            local a = getTickCount();
            local lastresume = getTickCount();
            for k,v in pairs(array) do
                func(v,k);

                -- int getTickCount() 
                -- (GTA:MTA server scripting function)
                -- For other environments use alternatives.
                if getTickCount() > lastresume + self.maxtime then
                    coroutine.yield()
                    lastresume = getTickCount()
                end
            end
            if (self.debug) then
            	print("[DEBUG]instance foreach_pairs: " .. (getTickCount() - a) .. "ms");
            end
            if (callback) then
                callback();
            end
        end);

        self:switch();
    end,
	
	-- query
    -- Iterate over array (query cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func query callback using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:query("SELECT * FROM vehicles", false, function(data, id)
        --     print(vehicle.title);
        -- end);
		-- @usage instance:query("SELECT * FROM characters WHERE id = '1'", {player}, function(data, id)
        --     print(vehicle.title);
        -- end);
	query = function(self, query, str, func)
		self:add(function()
			local a = getTickCount();
            local lastresume = getTickCount();
			if (type(str) ~= 'table') and not str == 'no' then str = {'no-one'} end
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						if (rows == 1) and str ~= 'no' then res = res[1] end
						if type(str) == 'table' then
							func(res, rows, err, unpack(str))
						else
							func(res, rows, err)
						end
					else
						func({}, 0, err, unpack(str))
					end
				end,
			exports.vrp_mysql:getConnection(), query)
			
			if (self.debug) then
            	print("[DEBUG] instance query: " .. (getTickCount() - a) .. "ms");
				if (self.debugdb) then
					outputDebugString("[DEBUG] instance query: "..query, 3, 20, 20, 240);
				end
            end
            if (callback) then
                callback();
            end
		end);
		
		self:switch();
	end,
	
	-- select
    -- Iterate over array (select query cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func select callback using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:select("vehicles", {['id'] = 1}, function(data, id)
        --     print(vehicle.title);
        -- end);
	select = function(self, query, str, func)
		self:add(function()
			local a = getTickCount();
            local lastresume = getTickCount();
			if (type(str) ~= 'table') then
				query_string =  "SELECT * FROM "..query..""
			else
				for i, v in pairs(str) do
					query_string =  "SELECT * FROM "..query.." WHERE "..i.." = '"..v.."'"
				end
			end
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						func(res, rows, err)
					end
				end,
			exports.vrp_mysql:getConnection(), query_string)
			
			if (self.debug) then
            	print("[DEBUG] instance query: " .. (getTickCount() - a) .. "ms");
				if (self.debugdb) then
					print("[DEBUG] instance query: "..query_string);
				end
            end
            if (callback) then
                callback();
            end
		end);
		
		self:switch();
	end,
	
	-- exec
    -- Iterate over array (select exec cycle)
    -- @access public
    -- @param table array Input array
    -- @param function func select callback using func
        -- Function func params:
        -- @param int [v] Iteration value
        -- @param int [k] Iteration key
    -- @param function [callback] Callback function, called when execution finished
    -- Usage:
        -- @usage instance:select("vehicles", {['id'] = 1}, function(data, id)
        --     print(vehicle.title);
        -- end);
	exec  = function(self, query)
		self:add(function()
			local a = getTickCount();
            local lastresume = getTickCount();
			local query_string = query
			dbExec(exports.vrp_mysql:getConnection(), query_string)
			if (self.debug) then
            	print("[DEBUG] instance query: " .. (getTickCount() - a) .. "ms");
				if (self.debugdb) then
					print("[DEBUG] instance query: "..query_string);
				end
            end
            if (callback) then
                callback();
            end
		end);
		
		self:switch();
	end,
}

-- instance Singleton wrapper
instance = {
    instance = nil,
};

-- After first call, creates an instance and stores it
local function getInstance()
    if instance.instance == nil then
        instance.instance = _instance();
    end

    return instance.instance;
end

-- proxy methods for public members
function instance:setDebug(...)
    getInstance():setDebug(...);
end

function instance:setPriority(...)
    getInstance():setPriority(...);
end

function instance:iterate(...)
    getInstance():iterate(...);
end

function instance:foreach(...)
    getInstance():foreach(...);
end

function instance:foreach_pairs(...)
    getInstance():foreach_pairs(...);
end

function instance:query(...)
    getInstance():query(...);
end

function instance:select(...)
    getInstance():select(...);
end

function instance:exec(...)
    getInstance():exec(...);
end
