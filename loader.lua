repeat task.wait() until game:IsLoaded()
task.wait(1)

if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()
local USER_KEY = getgenv().USER_KEY

if not USER_KEY then
    return warn("❌ Chưa nhập key (getgenv().USER_KEY)")
end

local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 23, min = 59, sec = 59})
end

local data = HttpService:JSONDecode(game:HttpGet(KEY_URL))

for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        if os.time() > toTime(v.expire) then
            return warn("❌ Key hết hạn")
        end

        getgenv().__SCRIPT_LOADED = true
        
        -- URL nạp key vào server Cloudflare
        local url = "https://structures-casinos-fioricet-your.trycloudflare.com/loader?file=premium&key=" .. USER_KEY
        
        print("✅ GitHub xác nhận. Đang kiểm tra với Server Cloudflare...")
        
        local success, scriptContent = pcall(function()
            return game:HttpGet(url)
        end)

        if success then
            -- KIỂM TRA XEM SERVER CÓ TRẢ VỀ LỖI KHÔNG
            if scriptContent:find("Invalid Key") or scriptContent:find("error") then
                getgenv().__SCRIPT_LOADED = false -- Reset để có thể thử lại
                return warn("❌ Server Cloudflare báo lỗi: Key không hợp lệ cho script này!")
            end
            
            loadstring(scriptContent)()
        else
            warn("❌ Không thể kết nối tới Server Cloudflare")
        end
        return
    end
end

warn("❌ Key không tồn tại trên hệ thống GitHub")
