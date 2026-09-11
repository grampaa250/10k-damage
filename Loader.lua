-- [[ Cargador Oficial ]] --
local modo = getgenv().script_mode

if modo == "PVP" then
    loadstring(game:httpGet("https://githubusercontent.com"))()
else
    print("Modo no reconocido o vacio. Pon getgenv().script_mode = 'PVP'")
end
