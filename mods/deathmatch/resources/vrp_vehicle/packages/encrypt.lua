
Encrypt = {
    code = md5('Auth'),
    api = 'api:callback',
    key = function(self,event) return exports.api:key(tostring(self.code),tostring(event)) or false end,
    sql = function(self, ...) return triggerServerEvent(self.api,root,...) end,
    server = function(self, ...) return triggerEvent(self.api,root,...) end,
}