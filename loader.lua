repeat task.wait() until game:IsLoaded()
task.wait(1)

-- Chặn load lại nhiều lần
if getgenv().__SCRIPT_LOADED then
    return warn("❌ Script đã được load")
end

local HttpService = game:GetService("HttpService")

-- 1. CHỐNG CACHE GITHUB (Để cập nhật key mới ngay lập tức)
local KEY_URL = "https://raw.githubusercontent.com/ken0946745792-web/Key-Nexon/main/keys.json?ts=" .. os.time()

-- 2. KEY NGƯỜI DÙNG NHẬP VÀO (Dùng để check hạn trên GitHub)
local USER_KEY = getgenv().USER_KEY
if not USER_KEY then
    return warn("❌ Vui lòng nhập key: getgenv().USER_KEY = 'KEY_CỦA_BẠN'")
end

-- Hàm xử lý thời gian
local function toTime(date)
    local y,m,d = date:match("(%d+)%-(%d+)%-(%d+)")
    if not y then return 0 end
    return os.time({
        year = tonumber(y), month = tonumber(m), day = tonumber(d),
        hour = 23, min = 59, sec = 59
    })
end

-- 3. LẤY DỮ LIỆU TỪ GITHUB
local success, response = pcall(function()
    return game:HttpGet(KEY_URL)
end)

if not success then return warn("❌ Lỗi kết nối GitHub") end

local data = HttpService:JSONDecode(response)
if not data or not data.keys then return warn("❌ Dữ liệu key lỗi") end

-- 4. VÒNG LẶP KIỂM TRA
for _, v in ipairs(data.keys) do
    if v.key == USER_KEY then
        -- Kiểm tra hạn dùng trên GitHub trước
        if os.time() > toTime(v.expire) then
            return warn("❌ Key đã hết hạn trên hệ thống")
        end

        ---------------------------------------------------------
        -- CODE GỐC BẠN CUNG CẤP (ĐÃ ĐƯỢC BẢO VỆ BỞI GITHUB)
        ---------------------------------------------------------
        getgenv().__SCRIPT_LOADED = true
        print("✅ Xác thực thành công! Đang khởi chạy...")

        local License = "NEXON-Q3M8ZK7L1FDR-X92PLT5C7HJB"
        local url = "https://structures-casinos-fioricet-your.trycloudflare.com/loader?file=premium&key=" .. License
        
        local runSuccess, errorMsg = pcall(function()
            loadstring(game:HttpGet(url))()
        end)

        if not runSuccess then
            getgenv().__SCRIPT_LOADED = false -- Reset nếu lỗi để có thể thử lại
            warn("❌ Lỗi thực thi từ Cloudflare: " .. tostring(errorMsg))
        end
        ---------------------------------------------------------
        return
    end
end

warn("❌ Key không tồn tại trên hệ thống!")
