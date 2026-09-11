-- [[ Cargador Oficial Limpio ]] --
local modo = getgenv().script_mode

if modo == "PVP" then
    loadstring(game:HttpGet("https://githubusercontent.com"))()
else
    print("Modo no reconocido. Usa getgenv().script_mode = 'PVP'")
end
